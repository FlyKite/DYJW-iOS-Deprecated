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
    CALayer *_clipLayer;
}
@property (nonatomic)CAShapeLayer *rippleLayer;
@property (nonatomic)CAAnimationGroup *groupAnimation;
@property (nonatomic, assign)CGPoint startPoint;
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

#pragma mark - 涟漪效果
- (CAShapeLayer *)rippleLayer {
    if (!_rippleLayer) {
        CALayer *layer = [CALayer layer];
        layer.frame = self.bounds;
        layer.masksToBounds = YES;
        _clipLayer = layer;
        
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.layer.bounds;
        pathLayer.geometryFlipped = YES;
        pathLayer.fillColor = [[MDColor grey300] colorWithAlphaComponent:0.5].CGColor;
        pathLayer.lineWidth = 0;
        pathLayer.lineJoin = kCALineJoinBevel;
        [layer addSublayer:pathLayer];
        _rippleLayer = pathLayer;
        [self.layer addSublayer:_clipLayer];
    }
    return _rippleLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSArray *array = [touches allObjects];
    UITouch *touch = array[0];
    CGPoint point = [touch locationInView:self];
    _startPoint = point;
    self.rippleLayer.timeOffset = [self.rippleLayer convertTime:CACurrentMediaTime() fromLayer:self.rippleLayer];
    [self rippleStartWithPoint:point andOffset:0 andSpeed:1];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = _startPoint;
    CFTimeInterval startTime = self.rippleLayer.timeOffset;
    CFTimeInterval timeSinceBegan = [self.rippleLayer convertTime:CACurrentMediaTime() fromLayer:self.rippleLayer] - startTime;
    [self rippleStartWithPoint:point andOffset:timeSinceBegan andSpeed:12];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    CGPoint point = _startPoint;
    CFTimeInterval startTime = self.rippleLayer.timeOffset;
    CFTimeInterval timeSinceBegan = [self.rippleLayer convertTime:CACurrentMediaTime() fromLayer:self.rippleLayer] - startTime;
    [self rippleStartWithPoint:point andOffset:timeSinceBegan andSpeed:12];
}

- (void)rippleStartWithPoint:(CGPoint)point andOffset:(CFTimeInterval)offset andSpeed:(float)speed {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat radius = sqrt(width * width + height * height) / 2 + 10;
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
    pathAnimation.delegate = self;
    
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
    groupAnimation.speed = speed;
    self.groupAnimation = groupAnimation;
    
    [self.rippleLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
}
@end
