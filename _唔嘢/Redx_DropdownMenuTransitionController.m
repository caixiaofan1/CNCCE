//
//  Redx_DropdownMenuTransitionController.m
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import "Redx_DropdownMenuTransitionController.h"
#import "Redx_DropdownMenuViewController.h"
@interface Redx_DropdownMenuViewController(TransitionController)
-(void)enterTheStageWithCompletion:(void(^)(void))completion;
-(void)leaveTheStageWithCompletion:(void(^)(void))completion;
@end

@interface Redx_DropdownMenuTransitionController ()

@property (nonatomic, strong) UIView *snapshotView;

@end

@implementation Redx_DropdownMenuTransitionController

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0;
}
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.isDismissing)
    {
        UINavigationController *nav = (UINavigationController *)fromViewController;
        Redx_DropdownMenuViewController *menu = (Redx_DropdownMenuViewController *)nav.topViewController;
        
        [menu leaveTheStageWithCompletion:^{
            [nav.view removeFromSuperview];
            [self.snapshotView removeFromSuperview];
            self.snapshotView = nil;
            [transitionContext completeTransition:YES];
        }];
    }
    else
    {
        // fromViewController.view will be disappeared when presenting using UIModalPresentationCurrentContext
        // so we put a snapshot underneath our menu
        self.snapshotView = [container snapshotViewAfterScreenUpdates:NO];
        
        UINavigationController *nav = (UINavigationController *)toViewController;
        Redx_DropdownMenuViewController *menu = (Redx_DropdownMenuViewController *)nav.topViewController;
        
        nav.view.frame = container.bounds;
        [container addSubview:nav.view];
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [menu.view insertSubview:self.snapshotView atIndex:0];
            self.snapshotView.frame = menu.view.bounds;
            
            [menu enterTheStageWithCompletion:^{
                [transitionContext completeTransition:YES];
            }];
        }];
        
        
    }
}

@end

