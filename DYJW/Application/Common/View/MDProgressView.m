//
//  MDProgressBar.m
//  DYJW
//
//  Created by 风筝 on 16/1/7.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "MDProgressView.h"
#import "MDColor.h"

@interface MDProgressView () {
    CGFloat _lineWidth;
    CGFloat _radius;
    CGFloat _startAngle;
}
@property (nonatomic, weak)CALayer *backMaskLayer;
@property (nonatomic, weak)CAShapeLayer *refreshLayer;
@property (nonatomic, strong)CAKeyframeAnimation *refreshAnimation;
@property (nonatomic, strong)CAKeyframeAnimation *endRefreshAnimation;
@end

@implementation MDProgressView
+ (id)progressViewWithStyle:(MDProgressViewStyle)style {
    return [[self alloc] initWithViewStyle:style];
}

- (id)initWithViewStyle:(MDProgressViewStyle)style {
    CGRect frame;
    switch (style) {
        case MDProgressViewStyleLoadingLarge:
            frame = CGRectMake(0, 0, 72, 72);
            _lineWidth = 5;
            _radius = 20;
            break;
        case MDProgressViewStyleLoadingMedium:
            frame = CGRectMake(0, 0, 48, 48);
            _lineWidth = 4;
            _radius = 12;
            break;
        case MDProgressViewStyleLoadingSmall:
            frame = CGRectMake(0, 0, 36, 36);
            _lineWidth = 3;
            _radius = 8;
            break;
        case MDProgressViewStyleBar:
            frame = CGRectMake(0, 0, 4, 100);
            break;
    }
    _style = style;
    _color = [MDColor lightBlue500];
    if (self = [super initWithFrame:frame]) {
        self.showBackMask = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self startAnimate];
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = self.frame.size.height;
    frame.size.width = self.frame.size.width;
    [super setFrame:frame];
}

- (void)setColor:(UIColor *)color {
    if (self.style == MDProgressViewStyleBar) {
        
    } else {
        self.refreshLayer.strokeColor = color.CGColor;
    }
    _color = color;
}

- (CALayer *)backMaskLayer {
    if (!_backMaskLayer) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = self.bounds;
        layer.cornerRadius = self.frame.size.width / 2;
        layer.backgroundColor = [MDColor whiteColor].CGColor;
        layer.shadowColor = [MDColor grey500].CGColor;
        layer.shadowOpacity = 0.5;
        layer.shadowOffset = CGSizeMake(0, 2);
        [self.layer addSublayer:layer];
        _backMaskLayer = layer;
    }
    return _backMaskLayer;
}

- (CAShapeLayer *)refreshLayer {
    if (!_refreshLayer) {
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = self.bounds;
        [self.layer addSublayer:layer];
        _refreshLayer = layer;
        layer.lineWidth = _lineWidth;
        layer.strokeColor = self.color.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        
        CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:_radius
                                                        startAngle:0
                                                          endAngle:10 * M_PI
                                                         clockwise:YES];
        layer.path = path.CGPath;
    }
    return _refreshLayer;
}

- (void)setShowBackMask:(BOOL)showBackMask {
    _showBackMask = showBackMask;
    self.backMaskLayer.hidden = !showBackMask;
}

- (void)setShowBackMaskShadow:(BOOL)showBackMaskShadow {
    _showBackMaskShadow = showBackMaskShadow;
    self.backMaskLayer.shadowOpacity = showBackMaskShadow ? 0.5 : 0;
}

- (void)startAnimate {
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.duration = 2;
    rotation.fromValue = @(0);
    rotation.toValue = @(M_PI * 2);
    rotation.repeatCount = MAXFLOAT;
    [self.refreshLayer addAnimation:rotation forKey:@"transform.rotation.z"];
    
    self.refreshAnimation.values = @[@0.02, @0.18, @0.18,
                                     @0.34, @0.34, @0.50,
                                     @0.50, @0.66, @0.66,
                                     @0.82, @0.82];
    self.endRefreshAnimation.values = @[@0.00, @0.00, @0.16,
                                        @0.16, @0.32, @0.32,
                                        @0.48, @0.48, @0.64,
                                        @0.64, @0.80];
    NSMutableArray *timingFunctions = [[NSMutableArray alloc] init];
    for (int i = 0; i < 11; i++) {
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    }
    self.refreshAnimation.timingFunctions = timingFunctions;
    [self.refreshLayer addAnimation:self.refreshAnimation forKey:@"strokeEnd"];
    [self.refreshLayer addAnimation:self.endRefreshAnimation forKey:@"strokeStart"];
}

- (CAKeyframeAnimation *)refreshAnimation {
    if (!_refreshAnimation) {
        CAKeyframeAnimation *refresh = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        refresh.duration = 10;
        refresh.repeatCount = MAXFLOAT;
        _refreshAnimation = refresh;
    }
    return _refreshAnimation;
}
- (CAKeyframeAnimation *)endRefreshAnimation {
    if (!_endRefreshAnimation) {
        CAKeyframeAnimation *endRefresh = [CAKeyframeAnimation animationWithKeyPath:@"strokeStart"];
        endRefresh.duration = 10;
        endRefresh.repeatCount = MAXFLOAT;
        _endRefreshAnimation = endRefresh;
    }
    return _endRefreshAnimation;
}

@end
