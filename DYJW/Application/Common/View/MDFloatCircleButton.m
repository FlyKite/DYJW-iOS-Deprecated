//
//  MDFloatCircleButton.m
//  DYJW
//
//  Created by 风筝 on 16/5/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "MDFloatCircleButton.h"
#import "MDColor.h"
#import "UIView+MDRippleView.h"

#define Height 48
#define Width 48
#define Padding 16

@implementation MDFloatCircleButton
+ (id)buttonWithType:(UIButtonType)buttonType {
    MDFloatCircleButton *button = [super buttonWithType:buttonType];
    button.frame = CGRectMake(0, 0, Width, Height);
    button.backgroundColor = [MDColor lightBlue500];
    [button createRippleView];
    return button;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = Height;
    frame.size.width = Width;
    [super setFrame:frame];
    
    self.layer.cornerRadius = Width / 2;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:Width / 2];
    self.layer.shadowColor = [MDColor grey900].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setTitleColor:[MDColor grey50] forState:state];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
}
@end
