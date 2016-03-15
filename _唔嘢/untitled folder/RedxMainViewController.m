//
//  RedxMainViewController.m
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import "RedxMainViewController.h"
#import "Redx_DropdownMenuViewController.h"
#import "Redx_CollectionViewCell.h"
#import "Redx_DropdownMenuItem.h"
@interface RedxMainViewController ()
@property(nonatomic ,strong)NSArray *menuItems;
@property(nonatomic, strong)UIView *mainView;
@property(nonatomic, assign)Redx_DropdownMenuStyle menuStyle;
@end

@implementation RedxMainViewController
-(void)loadView{
    [super loadView];
    
    self.mainView = [[UIView new]initWithFrame:self.view.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(presentMenuFromNav:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"Share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentMenuFromNav:)];
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [titleBtn setTitle:@"菜单" forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"Title"] forState:UIControlStateNormal];
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [titleBtn addTarget:self action:@selector(presentStyleMenu) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn sizeToFit];
    self.navigationItem.titleView = titleBtn;
}
//-(NSArray *)menuItems{
//    if(!self.menuItems){
//        self.menuItems = @[
//                           
//                           ];
//    }
//    return self.menuItems;
//}
//
//-(void)presentMenuFromMenu:(id)sender {
//    NSLog(@"123");
//    
//}
//
//-(void)presentMenuFromShare:(id)sender {
//    NSLog(@"321");
//}
//
//-(void)presentMenuFromTitle {
//    NSLog(@"132");
//    
//}
-(NSArray *)menuItems{
    if(!_menuItems){
        _menuItems = @[
                       [Redx_DropdownMenuItem itemWithText:@"Menu" image:[UIImage imageNamed:@"menu"] action:nil],
                       
                       [Redx_DropdownMenuItem itemWithText:@"Share" image:[UIImage imageNamed:@"share"] action:nil],
                       
                       [Redx_DropdownMenuItem itemWithText:@"Down" image:[UIImage imageNamed:@"down"] action:nil]
                       ];
    }
    return _menuItems;
}

-(void)presentMenuFromNav:(id)sender{
    Redx_DropdownMenuCellAligment alignment = RedxDropdownMenuCellAligmentCenter;
    if(sender == self.navigationItem.leftBarButtonItem){
        alignment = RedxDropdownMenuCellAligmentLeft;
        
    }else{
        
        alignment = RedxDropdownMenuCellAligmentRight;
    }
    [Redx_DropdownMenuViewController presentFromViewController:self
                                                     withItems:self.menuItems
                                                         align:alignment
                                                         style:self.menuStyle
                                                   navBarImage:[sender image]
                                                    completion:nil];
}

-(void)presentMenuFromMenu:(id)sender{
    NSLog(@"123");
    
}

-(void)presentStyleMenu {
    NSArray *styleItems = @[
                            [Redx_DropdownMenuItem itemWithText:@"个人发帖" image:nil action:^{
                                self.menuStyle = Redx_DropdownMenuStyleBlackGradient;
                            }],
                            [Redx_DropdownMenuItem itemWithText:@"社区公告" image:nil action:^{
                                self.menuStyle = Redx_DropdownMenuStyleTranslucent;
                            }]
                            ];
    [Redx_DropdownMenuViewController presentFromViewController:self withItems:styleItems align:RedxDropdownMenuCellAligmentCenter style:self.menuStyle navBarImage:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
