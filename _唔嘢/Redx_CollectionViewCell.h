//
//  Redx_CollectionViewCell.h
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

@import UIKit;
//#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Redx_DropdownMenuCellAligment){
    RedxDropdownMenuCellAligmentLeft = 0,
    RedxDropdownMenuCellAligmentCenter,
    RedxDropdownMenuCellAligmentRight,
};

@interface Redx_CollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UILabel *textLabel;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, assign)Redx_DropdownMenuCellAligment alignment;



@end
