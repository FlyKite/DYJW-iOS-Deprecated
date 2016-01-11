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
@property (nonatomic, weak)CAShapeLayer *refreshTransLayer;
@property (nonatomic, weak)CAShapeLayer *refreshWhiteLayer;
@property (nonatomic, strong)CAKeyframeAnimation *refreshAnimation;
@property (nonatomic, strong)CAKeyframeAnimation *refreshTransAnimation;
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
        self.refreshTransLayer.strokeColor = color.CGColor;
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
        
        CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotation.duration = 2;
        rotation.fromValue = @(0);
        rotation.toValue = @(M_PI * 2);
        rotation.repeatCount = MAXFLOAT;
        [layer addAnimation:rotation forKey:@"transform.rotation.z"];
    }
    return _refreshLayer;
}

- (CAShapeLayer *)refreshTransLayer {
    if (!_refreshTransLayer) {
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = self.bounds;
        [self.refreshLayer addSublayer:layer];
        _refreshTransLayer = layer;
        layer.lineWidth = _lineWidth;
        layer.strokeColor = self.color.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
    }
    return _refreshTransLayer;
}

- (CAShapeLayer *)refreshWhiteLayer {
    if (!_refreshWhiteLayer) {
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.frame = self.bounds;
        [self.refreshLayer addSublayer:layer];
        _refreshWhiteLayer = layer;
        layer.lineWidth = _lineWidth + 1;
        layer.strokeColor = [MDColor whiteColor].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
    }
    return _refreshWhiteLayer;
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
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:_radius
                                                    startAngle:_startAngle * M_PI
                                                      endAngle:(_startAngle + 2) * M_PI
                                                     clockwise:YES];
    _startAngle -= 0.4;
    _startAngle = _startAngle <= 0 ? _startAngle + 2 : _startAngle;
    self.refreshLayer.path = path.CGPath;
    self.refreshWhiteLayer.path = path.CGPath;
    [self.refreshLayer addAnimation:self.refreshAnimation forKey:@"strokeEnd"];
    [self.refreshWhiteLayer addAnimation:self.endRefreshAnimation forKey:@"strokeEnd"];
    
    [self performSelector:@selector(startTransAnimation) withObject:nil afterDelay:0.5];
}

- (void)startTransAnimation {
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    UIBezierPath *transPath = [UIBezierPath bezierPathWithArcCenter:center
                                                             radius:_radius
                                                         startAngle:_startAngle * M_PI
                                                           endAngle:(_startAngle + 2) * M_PI
                                                          clockwise:YES];
    self.refreshTransLayer.path = transPath.CGPath;
    [self.refreshTransLayer addAnimation:self.refreshTransAnimation forKey:@"strokeEnd"];
}

- (CAKeyframeAnimation *)refreshAnimation {
    if (!_refreshAnimation) {
        CAKeyframeAnimation *refresh = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        refresh.duration = 2;
        refresh.values = @[@(0.1), @(0.9), @(0.9)];
        _refreshAnimation = refresh;
    }
    return _refreshAnimation;
}

- (CAKeyframeAnimation *)refreshTransAnimation {
    if (!_refreshTransAnimation) {
        CAKeyframeAnimation *refresh = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        refresh.duration = 2;
        refresh.values = @[@(0), @(0), @(0), @(0.1), @(0.1)];
        refresh.repeatCount = MAXFLOAT;
        _refreshTransAnimation = refresh;
    }
    return _refreshTransAnimation;
}

- (CAKeyframeAnimation *)endRefreshAnimation {
    if (!_endRefreshAnimation) {
        CAKeyframeAnimation *endRefresh = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
        endRefresh.duration = 2;
        endRefresh.values = @[@(0.0), @(0.0), @(0.8)];
        endRefresh.delegate = self;
        _endRefreshAnimation = endRefresh;
    }
    return _endRefreshAnimation;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self startAnimate];
    }
}

@end
