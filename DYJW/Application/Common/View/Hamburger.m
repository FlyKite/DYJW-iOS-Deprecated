//
//  Hamburger.m
//  DYJW
//
//  Created by 风筝 on 15/10/19.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "Hamburger.h"

#define Width 56.0
#define Padding 18.0
#define LineWidth 20.0
#define LineHeight LineWidth * 6.0 / 56.0
#define Interval LineHeight * 10.0 / 6.0
#define LineY (56.0 - (Interval * 2.0 + LineHeight * 3.0)) / 2.0
#define Pi M_PI
#define AnimationDuration 0.3

@interface Hamburger ()
@property (nonatomic, weak)UIView *line1;
@property (nonatomic, weak)UIView *line3;
@property (nonatomic, assign)CGRect line1Frame;
@property (nonatomic, assign)CGRect line3Frame;
@end

@implementation Hamburger
+ (id)hamburger {
    return [[self alloc] init];
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:CGRectMake(0, 0, Width, Width)]) {
        for (int i = 0; i < 3; i++) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(Padding,  LineY + (Interval + LineHeight) * i, LineWidth, LineHeight)];
            line.backgroundColor = [UIColor whiteColor];
            [self addSubview:line];
            switch (i) {
                case 0:
                    self.line1Frame = line.frame;
                    self.line1 = line;
                    break;
                case 2:
                    self.line3Frame = line.frame;
                    self.line3 = line;
                    break;
            }
        }
    };
    return self;
}

- (void)setState:(HamburgerState)state {
    if (state != HamburgerStatePopBack && _state != state) {
        [self toggle];
    } else if (state == HamburgerStatePopBack) {
        self.stateValue = _state == HamburgerStateNormal ? 1 : 0;
        _state = HamburgerStatePopBack;
    }
}

- (void)clearTransform {
    self.transform = CGAffineTransformMakeRotation(0);
    self.line1.transform = CGAffineTransformMakeRotation(0);
    self.line1.frame = self.line1Frame;
    self.line3.transform = CGAffineTransformMakeRotation(0);
    self.line3.frame = self.line1Frame;
}

- (void)setStateValue:(CGFloat)stateValue {
    // 限制stateValue的值的范围
    stateValue = stateValue > 1 ? 1 : (stateValue < 0 ? 0 : stateValue);
    
    [UIView animateWithDuration:AnimationDuration * (1 - _stateValue) animations:^{
        // 整个控件的旋转
        [self clearTransform];
    
        self.transform = CGAffineTransformMakeRotation(Pi * (stateValue + (self.state == HamburgerStateNormal ? 0 : 1)));
        
        // 判断是从剪头状态回到普通状态还是从普通状态转为剪头状态
        CGFloat xyValue = self.state == HamburgerStateNormal ? stateValue : 1 - stateValue;
        CGFloat widthValue = self.state == HamburgerStateNormal ? 3 - stateValue : 2 + stateValue;
        
        // line1的变换
        CGRect frame = self.line1Frame;
        frame.origin.x += LineWidth * xyValue / 2;
        frame.origin.y += Interval * xyValue / 2;
        frame.size.width = frame.size.width * widthValue / 3;
        self.line1.frame = frame;
        self.line1.transform = CGAffineTransformMakeRotation(Pi / 4 * xyValue);
        
        // line3的变换
        frame = self.line3Frame;
        frame.origin.x += LineWidth * xyValue / 2;
        frame.origin.y -= Interval * xyValue / 2;
        frame.size.width = frame.size.width * widthValue / 3;
        self.line3.frame = frame;
        self.line3.transform = CGAffineTransformMakeRotation(-Pi / 4 * xyValue);
        
    }];
    // 如果stateValue值为1则完成变换，更改state
    _state = stateValue == 1 ? (_state == HamburgerStateNormal ? HamburgerStateBack : HamburgerStateNormal) : _state;
    _stateValue = stateValue == 1 ? 0 : stateValue;
}

- (void)toggle {
    [UIView animateWithDuration:AnimationDuration * (1 - self.stateValue) delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.stateValue = 1;
    } completion:^(BOOL finished) {
        if (self.state == HamburgerStateNormal) {
            self.transform = CGAffineTransformMakeRotation(0);
        }
    }];
}

- (void)setOnClickAction:(onClickAction)onClickAction {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealClick)];
    [self addGestureRecognizer:tap];
}

- (void)dealClick {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
