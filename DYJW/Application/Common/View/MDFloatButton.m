//
//  MDFloatButton.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDFloatButton.h"
#import "MDColor.h"
#import "UIView+MDRippleView.h"

#define Height 48
#define Width 88
#define Padding 16

@implementation MDFloatButton
+ (id) buttonWithType:(UIButtonType)buttonType {
    MDFloatButton *button = [super buttonWithType:buttonType];
    button.backgroundColor = [MDColor lightBlue500];
    [button createRippleView];
    return button;
}

- (void) setFrame:(CGRect)frame {
    frame.size.height = Height;
    frame.size.width = frame.size.width > Width ? frame.size.width : Width;
    [super setFrame:frame];
    
    self.layer.cornerRadius = 2;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowColor = [MDColor grey900].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setTitleColor:[MDColor grey50] forState:state];
    [self sizeToFit];
    CGRect frame = self.frame;
    frame.size.width += Padding * 2;
    self.frame = frame;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
}
@end
