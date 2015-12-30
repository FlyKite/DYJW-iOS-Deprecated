//
//  MDFloatButton.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDFloatButton.h"
#import "MDColor.h"

#define Height 48
#define Width 88
#define Padding 16

@interface MDFloatButton () {
    UIView *rippleView;
    NSTimer *rippleTimer;
    UIView *background;
    UIView *rippleContainer;
}

@end

@implementation MDFloatButton
+ (id) buttonWithType:(UIButtonType)buttonType {
    MDFloatButton *button = [super buttonWithType:buttonType];
    button.backgroundColor = [MDColor lightBlue500];
    return button;
}
- (void) touchDown {
    if (rippleTimer) {
        [rippleTimer invalidate];
    }
    rippleTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(rippleToMid) userInfo:nil repeats:YES];
}
- (void) rippleToMid {
    float add = (self.frame.size.width + 20) / 30;
    CGRect frame = rippleView.frame;
    frame.size.width += add;
    frame.size.height += add;
    rippleView.frame = frame;
    frame.size.height = frame.size.height > Height ? Height : frame.size.height;
    rippleContainer.frame = frame;
    rippleView.layer.cornerRadius = frame.size.width / 2;
    rippleView.center = CGPointMake(rippleContainer.frame.size.width / 2, rippleContainer.frame.size.height / 2);
    rippleContainer.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    if (frame.size.width >= self.frame.size.width * 2 / 3) {
        [rippleTimer invalidate];
    }
}
- (void) rippleToFill {
    float add = (self.frame.size.width + 20) / 30;
    CGRect frame = rippleView.frame;
    frame.size.width += add;
    frame.size.height += add;
    rippleView.frame = frame;
    if (frame.size.width >= self.frame.size.width + 20) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            rippleView.alpha = 0;
        } completion:^(BOOL finished) {
            rippleContainer.frame = CGRectMake(0, 0, 0, 0);
            rippleView.alpha = 0.3;
            rippleView.frame = CGRectMake(0, 0, 0, 0);
            rippleView.center = CGPointMake(rippleContainer.frame.size.width / 2, rippleContainer.frame.size.height / 2);
        }];
        [rippleTimer invalidate];
    }
    frame.size.width = frame.size.width > self.frame.size.width ? self.frame.size.width : frame.size.width;
    frame.size.height = frame.size.height > Height ? Height : frame.size.height;
    rippleContainer.frame = frame;
    rippleView.layer.cornerRadius = frame.size.width / 2;
    rippleView.center = CGPointMake(rippleContainer.frame.size.width / 2, rippleContainer.frame.size.height / 2);
    rippleContainer.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}
- (void) touchUp {
    if (rippleTimer) {
        [rippleTimer invalidate];
    }
    rippleTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(rippleToFill) userInfo:nil repeats:YES];
}
- (void) setFrame:(CGRect)frame {
    frame.size.height = Height;
    frame.size.width = frame.size.width > Width ? frame.size.width : Width;
    [super setFrame:frame];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    
    [self createRippleView];
    rippleContainer.frame = self.frame;
    
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpOutside];
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [MDColor grey900].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowPath = shadowPath.CGPath;
}
- (void) createRippleView {
    if (!rippleView) {
        rippleContainer = [[UIView alloc] init];
        rippleContainer.layer.masksToBounds = YES;
        rippleContainer.clipsToBounds = YES;
        rippleContainer.layer.cornerRadius = 2;
        
        rippleView = [[UIView alloc] init];
        rippleView.clipsToBounds = YES;
        rippleView.backgroundColor = [MDColor grey300];
        rippleView.alpha = 0.5;
        
        [rippleContainer addSubview:rippleView];
        [self addSubview:rippleContainer];
    }
}
- (void) setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setTitleColor:[MDColor grey50] forState:state];
    [self sizeToFit];
    CGRect frame = self.frame;
    frame.size.width += Padding * 2;
    self.frame = frame;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
}
@end
