//
//  MDFlatButton.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDFlatButton.h"
#import "MDColor.h"
#import "UIView+MDRippleView.h"

#define Height 36
#define Width 88
#define Padding 16

@implementation MDFlatButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    MDFlatButton *button = [super buttonWithType:buttonType];
    [button createRippleView];
    return button;
}
- (void)setFrame:(CGRect)frame {
    frame.size.height = Height;
    [super setFrame:frame];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
}
- (void) setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setTitleColor:[MDColor lightBlue500] forState:state];
    [self sizeToFit];
    CGRect frame = self.frame;
    frame.size.width += Padding * 2;
    self.frame = frame;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
}

// The background of flat button should be always transparent
- (void) setBackgroundColor:(UIColor *)backgroundColor {
    
}
- (void) setBackgroundImage:(UIImage *)image forState:(UIControlState)state {
    
}
@end
