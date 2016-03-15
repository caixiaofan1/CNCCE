//
//  Redx_DropdownMenuBackgroundView.m
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import "Redx_DropdownMenuBackgroundView.h"

@implementation Redx_DropdownMenuBackgroundView

//将Redx_DropdownMenuBackgroundView的layer 设置为CAGradientLayer类
+(Class)layerClass{
    return [CAGradientLayer class];
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        CAGradientLayer *layer = (CAGradientLayer*)self.layer;
        layer.colors = @[
                         (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                         (id)[[UIColor colorWithWhite:0 alpha:0.7] CGColor],
                         ];
    }
    return self;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */



@end
