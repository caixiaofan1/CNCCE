//
//  Redx_CollectionViewCell.m
//  _唔嘢
//
//  Created by Huangshenghang on 16/3/14.
//  Copyright © 2016年 Huangshenghang. All rights reserved.
//

#import "Redx_CollectionViewCell.h"

@implementation Redx_CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self)
    {
        _textLabel = [UILabel new];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        _textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_textLabel];
        
        self.imageView = [UIImageView new];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_imageView];
        self.backgroundColor = [UIColor clearColor];
        self.imageView.image = nil;
        self.selectedBackgroundView = [UIView new];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

-(UIColor*)inversedTintColor{
    CGFloat white = 0;
    CGFloat alpha = 0;
    [self.tintColor getWhite:&white alpha:&alpha];
    return [UIColor colorWithWhite:1.2 - white alpha:alpha];
}

- (void)tintColorDidChange
{
    [super tintColorDidChange];
    self.textLabel.textColor = self.tintColor;
    self.selectedBackgroundView.backgroundColor = self.tintColor;
    self.textLabel.highlightedTextColor = [self inversedTintColor];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.imageView.tintColor = [self inversedTintColor];
    }
    else
    {
        self.imageView.tintColor = self.tintColor;
    }
}

/*
 - (void)setSelected:(BOOL)selected
 {
 if (selected)
 {
 self.tintColor = [UIColor colorWithWhite:0.2 alpha:1.0];
 }
 else
 {
 self.tintColor = nil;
 }
 [super setSelected:selected];
 }
 */

- (void)setAlignment:(Redx_DropdownMenuCellAligment)alignment
{
    _alignment = alignment;
    self.imageView.hidden = (alignment == RedxDropdownMenuCellAligmentCenter);
    switch (_alignment) {
        case RedxDropdownMenuCellAligmentLeft:
            self.textLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case RedxDropdownMenuCellAligmentCenter:
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case RedxDropdownMenuCellAligmentRight:
            self.textLabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.contentView removeConstraints:self.contentView.constraints];
    NSDictionary *views = @{@"text":self.textLabel, @"image":self.imageView};
    
    // vertical centering
    for (UIView *v in [views allValues])
    {
        [self.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:v
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                         constant:0.0]
         ];
    }
    
    CGFloat margin = 20;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        margin = 25;
    }
    
    // horizontal
    NSString *vfs = nil;
    switch (self.alignment) {
        case RedxDropdownMenuCellAligmentCenter:
            vfs = @"H:|[text]|";
            break;
            
        case RedxDropdownMenuCellAligmentLeft:
            vfs = @"H:[image]-(15)-[text]|";
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:margin]];
            break;
            
        case RedxDropdownMenuCellAligmentRight:
            vfs = @"H:|[text]-(15)-[image]";
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-margin]];
            break;
            
        default:
            break;
    }
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfs options:0 metrics:nil views:views]];
}
@end

