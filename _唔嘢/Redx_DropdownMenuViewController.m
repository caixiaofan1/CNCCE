//
//  Redx_DropdownMenuViewController.m
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import "Redx_DropdownMenuViewController.h"
#import "Redx_DropdownMenuBackgroundView.h"
#import "Redx_CollectionViewCell.h"
//#import "Redx_DropdownMenuPopoverHelper.h"
#import "Redx_DropdownMenuTransitionController.h"
#import "Redx_DropdownMenuItem.h"

static NSString * const CellId = @"RWDropdownMenuCell";
@interface Redx_DropdownMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIViewControllerTransitioningDelegate>
@property(nonatomic, strong)NSArray *items;
@property(nonatomic, strong)UIImage *navBarImage;
@property(nonatomic, strong)UICollectionView *collectionView;
@property(nonatomic, strong)UIToolbar *blurView;
@property(nonatomic, assign)BOOL isInPopover;

@property(nonatomic, assign)Redx_DropdownMenuStyle style;
@property(nonatomic, assign)Redx_DropdownMenuCellAligment aligment;
@property(nonatomic, strong)Redx_DropdownMenuBackgroundView *gradientBackground;
@property(nonatomic, strong)Redx_DropdownMenuTransitionController *transitionController;

-(void)enterTheStageWithCompletion:(void(^)(void))completion;
-(void)leaveTheStageWithCompletion:(void(^)(void))completion;

@end

@implementation Redx_DropdownMenuViewController
- (UIView *)backgroundView
{
    
    switch (self.style) {
        case Redx_DropdownMenuStyleBlackGradient:
            return self.gradientBackground;
            
        case Redx_DropdownMenuStyleTranslucent:
            return self.blurView;
            
        case Redx_DropdownMenuStyleWhite:
            return nil;
            
        default:
            return nil;
    }
}

-(void)loadView{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.tintColor = [UIColor whiteColor];
    
    if(self.style == Redx_DropdownMenuStyleTranslucent)
    {
        self.blurView = [[UIToolbar alloc]initWithFrame:self.view.bounds];
        self.blurView.autoresizingMask = 0;
        self.blurView.barStyle = UIBarStyleBlackTranslucent;
        [self.view addSubview:self.blurView];
    }
    else if (self.style == Redx_DropdownMenuStyleBlackGradient)
    {
        self.gradientBackground = [[Redx_DropdownMenuBackgroundView alloc]initWithFrame:self.view.bounds];
        self.gradientBackground.autoresizingMask = 0;
        [self.view addSubview:self.gradientBackground];
    }
    else if (self.style == Redx_DropdownMenuStyleWhite)
    {
        self.view.backgroundColor = [UIColor clearColor];
        self.view.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    }
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.autoresizingMask = 0;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.clipsToBounds = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[Redx_CollectionViewCell class] forCellWithReuseIdentifier:CellId];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundView = [UIView new];
    self.collectionView.backgroundView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView.userInteractionEnabled = YES;
    [self.collectionView.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)]];
    [self prepareNavigationItem];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    CGFloat barHeight = [self topLayoutGuide].length;
    self.backgroundView.frame = self.view.bounds;
    self.collectionView.frame = UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(barHeight, 0, 0, 0));
}

-(void)prepareNavigationItem{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:self.navBarImage style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    if(self.aligment == RedxDropdownMenuCellAligmentLeft)
    {
        self.navigationItem.leftBarButtonItem = barButtonItem;
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if(self.aligment == RedxDropdownMenuCellAligmentRight)
    {
        self.navigationItem.rightBarButtonItem = barButtonItem;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (CGSize)preferredContentSize
{
    CGSize size = CGSizeMake(200, 0);
    size.height = [self itemHeight] * self.items.count;
    if (self.items.count > 0)
    {
        size.height += [self collectionView:self.collectionView
                                     layout:self.collectionView.collectionViewLayout
        minimumLineSpacingForSectionAtIndex:0]* (self.items.count - 1);
        //padding == UIEdgeInsets
        UIEdgeInsets insets = [self collectionView:self.collectionView
                                            layout:self.collectionView.collectionViewLayout
                            insetForSectionAtIndex:0];
        size.height += insets.top + insets.bottom;
    }
    
    return size;
}

-(void)dismiss:(id)sender{
    UIViewController *vc = [self presentingViewController];
    if([vc isKindOfClass:[UINavigationController class]])
    {
        vc = [vc performSelector:@selector(topViewController)];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [vc.view setNeedsLayout];
        if([vc respondsToSelector:@selector(collectionView)])
        {
            UICollectionView *collectionView = [vc performSelector:@selector(collectionView)];
            [collectionView.collectionViewLayout invalidateLayout];
        }
    }];
    
}

+(void)presentFromViewController:(UIViewController *)viewController withItems:(NSArray *)items align:(Redx_DropdownMenuCellAligment)align style:(Redx_DropdownMenuStyle)style navBarImage:(UIImage *)navBarImage completion:(void (^)(void))completion{
    Redx_DropdownMenuViewController *menu = [[Redx_DropdownMenuViewController alloc]initWithNibName:nil bundle:nil];
    menu.style = style;
    menu.aligment = align;
    menu.items = items;
    menu.navBarImage = navBarImage;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:menu];
    nav.view.tintColor = menu.view.tintColor;
    nav.navigationBar.barStyle = UIBarStyleBlack;
    nav.navigationBar.translucent = YES;
    nav.navigationBar.userInteractionEnabled = YES;
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    [nav.navigationBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:) ]];
    
    nav.transitioningDelegate = menu;
    nav.modalPresentationStyle = UIModalPresentationCurrentContext;
    [viewController presentViewController:nav animated:YES completion:^{
        //mark...
        if(completion){
            completion();
        }
    }];
}

#pragma mark - transition
- (Redx_DropdownMenuTransitionController *)transitionController
{
    if (!_transitionController)
    {
        _transitionController = [Redx_DropdownMenuTransitionController new];
    }
    return _transitionController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionController.isDismissing = YES;
    return self.transitionController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitionController.isDismissing = NO;
    return self.transitionController;
}

- (CGAffineTransform)offStageTransformForItemAtIndex:(NSInteger)idx negative:(BOOL)negative
{
    const CGFloat maxTranslation = 400;
    const CGFloat minTranslation = 100;
    CGFloat translation = maxTranslation - (maxTranslation - minTranslation) * ((CGFloat)idx / self.items.count);
    if (negative)
    {
        translation = -translation;
    }
    
    switch (self.aligment) {
        case RedxDropdownMenuCellAligmentLeft:
            return CGAffineTransformMakeTranslation(translation, 0);
            
        case RedxDropdownMenuCellAligmentRight:
            return CGAffineTransformMakeTranslation(-translation, 0);
            
        case RedxDropdownMenuCellAligmentCenter:
            return CGAffineTransformMakeTranslation(0, -translation);
            
        default:
            return CGAffineTransformIdentity;
    }
}

#pragma mark - Layout
- (CGFloat)itemHeight
{
    return 44;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width, [self itemHeight]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.style != Redx_DropdownMenuStyleWhite)
    {
        return UIEdgeInsetsMake(5, 0, 5, 0);
    }
    else
    {
        return UIEdgeInsetsMake(20, 0, 20, 0);
    }
}


#pragma mark - collectionView delegate;
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Redx_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellId forIndexPath:indexPath];
    
    cell.tintColor = self.view.tintColor;
    
    Redx_DropdownMenuItem *item = self.items[indexPath.row];
    cell.textLabel.text = item.text;
    cell.imageView.image = item.image;
    cell.alignment = self.aligment;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    double delayInSeconds = 0.15;
    Redx_DropdownMenuItem *item = self.items[indexPath.row];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //        if (self.isInPopover){
        //            [[Redx_DropdownMenuPopoverHelper sharedInstance].popover dismissPopoverAnimated:YES];
        //            if (item.action){
        //                item.action();
        //            }
        //        }
        [self dismissViewControllerAnimated:YES completion:^{
            if (item.action)
            {
                double delayInSeconds = 0.15;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    item.action();
                });
            }
        }];
    });
}

#pragma mark - enterPresent
- (void)enterTheStageWithCompletion:(void (^)(void))completion
{
    for (NSInteger idx = 0; idx < self.items.count; ++idx)
    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
        cell.transform = [self offStageTransformForItemAtIndex:idx negative:NO];
        cell.alpha = 0;
    }
    
    self.collectionView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    for (NSInteger idx = 0; idx < self.items.count; ++idx)
    {
        // [UIView animateWithDuration:0.3 delay:0.02 * idx options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat delay = 0.02 * idx;
        if (!self.isInPopover)
        {
            delay += 0.05; // wait for backgroundView
        }
        [UIView animateWithDuration:0.8 delay:delay usingSpringWithDamping:0.4 initialSpringVelocity:3 options:0 animations:^{
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
            cell.transform = CGAffineTransformIdentity;
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (idx + 1 == self.items.count && completion)
            {
                completion();
            }
        }];
    }
}

#pragma mark -leavePresent
- (void)leaveTheStageWithCompletion:(void (^)(void))completion
{
    for (NSInteger idx = 0; idx < self.items.count; ++idx)
    {
        [UIView animateWithDuration:0.3 delay:0.02 * idx options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.items.count - idx - 1 inSection:0]];
            cell.transform = [self offStageTransformForItemAtIndex:idx negative:YES];
            cell.alpha = 0;
            if (idx + 1 == self.items.count)
            {
                self.backgroundView.alpha = 0;
            }
        } completion:^(BOOL finished) {
            if (idx + 1 == self.items.count && completion)
            {
                completion();
            }
        }];
    }
}



//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
