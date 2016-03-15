//
//  Redx_DropdownMenuItem.h
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

@import UIKit;
#import <Foundation/Foundation.h>

@interface Redx_DropdownMenuItem : NSObject

@property(nonatomic, copy)NSString *text;
@property(nonatomic, copy)void (^action)(void);
@property(nonatomic, strong)UIImage *image;

+(instancetype)itemWithText:(NSString*)text image:(UIImage*)image action:(void(^)(void))action;
@end
