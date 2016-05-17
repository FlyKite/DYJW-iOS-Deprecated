//
//  UIView+RippleView.m
//  DYJW
//
//  Created by 风筝 on 16/1/4.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "UIView+MDRippleView.h"
#import <objc/runtime.h>
#import "MDColor.h"

@interface UIView ()
@property (nonatomic)CAShapeLayer *rippleLayer;
@property (nonatomic)CAAnimationGroup *groupAnimation;
@property (nonatomic, assign)CGPoint startPoint;
@property (nonatomic, assign)BOOL ripple;
@property (nonatomic, assign)BOOL cancelRipple;
@property (nonatomic, assign)UIColor *color;
@property (nonatomic)CALayer *clipLayer;
@end

static char rippleLayerKey;
static char groupAnimationKey;
static char startPointXKey;
static char startPointYKey;
static char rippleKey;
static char cancelRippleKey;
static char colorKey;
static char clipLayerKey;

static char rippleFinishActionKey;

@implementation UIView (MDRippleView)
- (void)createRippleView {
    [self createRippleViewWithColor:[[MDColor grey300] colorWithAlphaComponent:0.5]];
}
- (void)createRippleViewWithColor:(UIColor *)color {
    if (!self.ripple) {
        self.color = color;
        self.ripple = YES;
        self.cancelRipple = NO;
    }
}
- (void)createRippleViewWithColor:(UIColor *)color andAlpha:(CGFloat)alpha {
    [self createRippleViewWithColor:[color colorWithAlphaComponent:alpha]];
}

- (CAShapeLayer *)rippleLayer {
    CAShapeLayer *_rippleLayer = objc_getAssociatedObject(self, &rippleLayerKey);
    if (!_rippleLayer) {
        CALayer *layer = [CALayer layer];
        layer.cornerRadius = self.layer.cornerRadius;
        layer.masksToBounds = YES;
        self.clipLayer = layer;
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.geometryFlipped = YES;
        pathLayer.lineWidth = 0;
        pathLayer.fillColor = self.color.CGColor;
        pathLayer.lineJoin = kCALineJoinBevel;
        [layer addSublayer:pathLayer];
        _rippleLayer = pathLayer;
        self.rippleLayer = pathLayer;
        [self.layer addSublayer:layer];
    }
    self.clipLayer.frame = self.bounds;
    _rippleLayer.frame = self.layer.bounds;
    return _rippleLayer;
}

- (CAAnimationGroup *)groupAnimation {
    return objc_getAssociatedObject(self, &groupAnimationKey);
}

- (CGPoint)startPoint {
    NSNumber *x = objc_getAssociatedObject(self, &startPointXKey);
    NSNumber *y = objc_getAssociatedObject(self, &startPointYKey);
    return CGPointMake([x floatValue], [y floatValue]);
}

- (BOOL)ripple {
    NSNumber *ripple = objc_getAssociatedObject(self, &rippleKey);
    return [ripple boolValue];
}

- (BOOL)cancelRipple {
    NSNumber *cancelRipple = objc_getAssociatedObject(self, &cancelRippleKey);
    return [cancelRipple boolValue];
}

- (UIColor *)color {
    return objc_getAssociatedObject(self, &colorKey);
}

- (CALayer *)clipLayer {
    return objc_getAssociatedObject(self, &clipLayerKey);
}

- (void(^)(void))rippleFinishAction {
    return objc_getAssociatedObject(self, &rippleFinishActionKey);
}

- (void)setRippleLayer:(CAShapeLayer *)rippleLayer {
    objc_setAssociatedObject(self, &rippleLayerKey, rippleLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setGroupAnimation:(CAAnimationGroup *)groupAnimation {
    objc_setAssociatedObject(self, &groupAnimationKey, groupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setStartPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, &startPointXKey, @(startPoint.x), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &startPointYKey, @(startPoint.y), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRipple:(BOOL)ripple {
    objc_setAssociatedObject(self, &rippleKey, @(ripple), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCancelRipple:(BOOL)cancelRipple {
    objc_setAssociatedObject(self, &cancelRippleKey, @(cancelRipple), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setColor:(UIColor *)color {
    objc_setAssociatedObject(self, &colorKey, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setClipLayer:(CALayer *)clipLayer {
    objc_setAssociatedObject(self, &clipLayerKey, clipLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRippleFinishAction:(void (^)(void))rippleFinishAction {
    objc_setAssociatedObject(self, &rippleFinishActionKey, rippleFinishAction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.cancelRipple = NO;
    [self performSelector:@selector(startRipple:) withObject:touches afterDelay:0.1];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.cancelRipple = NO;
    [self performSelector:@selector(endRipple) withObject:nil afterDelay:0.1];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.cancelRipple = YES;
    [self performSelector:@selector(endRipple) withObject:nil afterDelay:0.1];
}

- (void)startRipple:(NSSet<UITouch *> *)touches {
    if (!self.ripple || self.cancelRipple) {
        return;
    }
    NSArray *array = [touches allObjects];
    UITouch *touch = array[0];
    CGPoint point = [touch locationInView:self];
    self.startPoint = point;
    self.rippleLayer.timeOffset = [self.rippleLayer convertTime:CACurrentMediaTime() fromLayer:self.rippleLayer];
    [self rippleStartWithPoint:point andOffset:0 andSpeed:1];
}

- (void)endRipple{
    if (!self.ripple) {
        return;
    }
    self.clipLayer.frame = self.bounds;
    CGPoint point = self.startPoint;
    CFTimeInterval startTime = self.rippleLayer.timeOffset;
    CFTimeInterval timeSinceBegan = [self.rippleLayer convertTime:CACurrentMediaTime() fromLayer:self.rippleLayer] - startTime;
    [self rippleStartWithPoint:point andOffset:timeSinceBegan andSpeed:12];
}

- (void)rippleStartWithPoint:(CGPoint)point andOffset:(CFTimeInterval)offset andSpeed:(float)speed {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = sqrt(width * width + height * height) / 2;
    CGFloat duration = 3;
    
    UIBezierPath *circle = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.rippleLayer.path = circle.CGPath;
    
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGFloat fromValue = duration - offset > 0 ? (duration - offset) / duration : 0;
    fromValue = 1 - fromValue;
    CGPoint fromPoint = CGPointMake((width / 2 - point.x) * fromValue + point.x, (height / 2 - point.y) * fromValue + point.y);
    moveAnimation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(width / 2, height / 2)];
    moveAnimation.duration = duration - offset > 0 ? duration - offset : 0;;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pathAnimation.duration = duration - offset > 0 ? duration - offset : 0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fromValue = offset > duration ? (duration * 2 - offset) / duration : 1.0;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    alphaAnimation.duration = offset > duration ? duration * 2 - offset : duration;
    alphaAnimation.beginTime = offset > duration ? 0 : duration - offset;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = duration * 2 - offset;
    groupAnimation.animations = @[moveAnimation, pathAnimation, alphaAnimation];
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.delegate = self;
    groupAnimation.speed = speed;
    self.groupAnimation = groupAnimation;
    
    [self.rippleLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([self respondsToSelector:@selector(rippleFinished)] && !flag) {
        [self performSelector:@selector(rippleFinished) withObject:nil afterDelay:0.3];
    } else if(self.rippleFinishAction && !flag) {
        self.rippleFinishAction();
    }
}
@end

@implementation UIButton (MDRippleView)
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self startRipple:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self endRipple];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self endRipple];
}
@end