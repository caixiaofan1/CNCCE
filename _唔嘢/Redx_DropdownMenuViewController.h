//
//  Redx_DropdownMenuViewController.h
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Redx_CollectionViewCell.h"
typedef NS_ENUM(NSInteger, Redx_DropdownMenuStyle){
    Redx_DropdownMenuStyleBlackGradient = 0,
    Redx_DropdownMenuStyleTranslucent,
    Redx_DropdownMenuStyleWhite,
};


@interface Redx_DropdownMenuViewController : UIViewController

@property(nonatomic, strong, readonly)UIView *backgroundView;
@property(nonatomic, strong, readonly)UICollectionView *collectionView;

+(void)presentFromViewController:(UIViewController*)viewController
                       withItems:(NSArray *)items
                           align:(Redx_DropdownMenuCellAligment)align
                           style:(Redx_DropdownMenuStyle)style
                     navBarImage:(UIImage*)navBarImage
                      completion:(void(^)(void))completion;
@end
