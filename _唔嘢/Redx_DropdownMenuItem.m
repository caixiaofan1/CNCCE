//
//  Redx_DropdownMenuItem.m
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import "Redx_DropdownMenuItem.h"

@implementation Redx_DropdownMenuItem

+(instancetype)itemWithText:(NSString *)text image:(UIImage *)image action:(void (^)(void))action{
    Redx_DropdownMenuItem *item = [self new];
    item.text = text;
    item.image = image;
    item.action = action;
    return item;
}
@end

