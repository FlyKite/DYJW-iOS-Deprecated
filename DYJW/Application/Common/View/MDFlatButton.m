//
//  MDFlatButton.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/21.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDFlatButton.h"
#import "MDColor.h"

#define Height 36
#define Width 88
#define Padding 16

@interface MDFlatButton () {
    UIView *rippleView;
    NSTimer *rippleTimer;
}

@end

@implementation MDFlatButton
+ (id) buttonWithType:(UIButtonType)buttonType {
    MDFlatButton *button = [super buttonWithType:buttonType];
    return button;
}
- (void) touchDown:(UIButton *)btn {
    
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
    rippleView.layer.cornerRadius = frame.size.width / 2;
    rippleView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
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
    rippleView.layer.cornerRadius = frame.size.width / 2;
    rippleView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    if (frame.size.width >= self.frame.size.width + 20) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            rippleView.alpha = 0;
        } completion:^(BOOL finished) {
            rippleView.alpha = 1;
            rippleView.frame = CGRectMake(0, 0, 0, 0);
            rippleView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        }];
        [rippleTimer invalidate];
    }
}
- (void) touchUp:(UIButton *)btn {
    if (rippleTimer) {
        [rippleTimer invalidate];
    }
    rippleTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(rippleToFill) userInfo:nil repeats:YES];
}
- (void) setFrame:(CGRect)frame {
    frame.size.height = Height;
//    frame.size.width = frame.size.width > Width ? frame.size.width : Width;
    [super setFrame:frame];
    self.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    [self createRippleView];
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
}
- (void) createRippleView {
    if (!rippleView) {
        rippleView = [[UIView alloc] init];
        rippleView.clipsToBounds = YES;
        rippleView.backgroundColor = [MDColor grey300];
        [self addSubview:rippleView];
    }
    rippleView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
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
