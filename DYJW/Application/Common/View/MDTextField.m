//
//  MDTextField.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDTextField.h"
#import "MDColor.h"

@interface MDTextField ()
@property (nonatomic)CATextLayer *placeholderLayer;
@property (nonatomic, assign)BOOL placeholderUp;
@property (nonatomic)CAShapeLayer *underlineGrayLayer;
@property (nonatomic)CAShapeLayer *underlineLayer;
@end

@implementation MDTextField
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        frame.size.height = 48;
        [self setFont:[UIFont systemFontOfSize:16]];
        self.frame = frame;
        [self addTarget:self action:@selector(beginEditingAnimation) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(endEditingAnimation) forControlEvents:UIControlEventEditingDidEnd];
    }
    return self;
}

- (CATextLayer *)placeholderLayer {
    if (!_placeholderLayer) {
        _placeholderLayer = [[CATextLayer alloc] init];
        _placeholderLayer.frame = CGRectMake(self.hasPadding ? 16 : 0, ViewHeight(self) / 2 - 7, ViewWidth(self), 14);
        _placeholderLayer.foregroundColor = [MDColor grey500].CGColor;
//        _placeholderLayer.alignmentMode = kCAAlignmentJustified;
        _placeholderLayer.wrapped = YES;
        _placeholderLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        UIFont *font = [UIFont systemFontOfSize:12];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _placeholderLayer.font = fontRef;
        _placeholderLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        [self.layer addSublayer:_placeholderLayer];
    }
    return _placeholderLayer;
}

- (CAShapeLayer *)underlineGrayLayer {
    if (!_underlineGrayLayer) {
        _underlineGrayLayer = [[CAShapeLayer alloc] init];
        _underlineGrayLayer.backgroundColor = [MDColor grey300].CGColor;
        [self.layer addSublayer:_underlineGrayLayer];
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pathAnimation.duration = 0;
        pathAnimation.fromValue = @(1);
        pathAnimation.toValue = @(0);
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        [self.underlineLayer addAnimation:pathAnimation forKey:@"transform"];
    }
    return _underlineGrayLayer;
}

- (CAShapeLayer *)underlineLayer {
    if (!_underlineLayer) {
        _underlineLayer = [[CAShapeLayer alloc] init];
        _underlineLayer.backgroundColor = [MDColor lightBlue500].CGColor;
        [self.layer addSublayer:_underlineLayer];
    }
    return _underlineLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.placeholderLayer.frame = CGRectMake(self.hasPadding ? 16 : 0, ViewHeight(self) / 2 - 7, frame.size.width, 14);
    self.underlineGrayLayer.frame = CGRectMake(0, frame.size.height - (self.hasPadding ? 0 : 9), frame.size.width, 1);
    self.underlineLayer.frame = CGRectMake(0, frame.size.height - (self.hasPadding ? 0 : 9), frame.size.width, 1);
}
//控制 placeHolder 的位置，左右缩 20
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , self.hasPadding ? 16 : 0, 0);
}

// 控制文本的位置，左右缩 20
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.hasPadding ? 16 : 0, 0);
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLayer.string = placeholder;
}

- (void)setUnderlineColorOnFocus:(UIColor *)color {
    self.underlineLayer.backgroundColor = color.CGColor;
}

- (void)setText:(NSString *)text {
    if (!self.placeholderUp) {
        [self beginEditingAnimation];
        [super setText:text];
        [self endEditingAnimation];
    } else {
        [super setText:text];
    }
}

- (void)setHasPadding:(BOOL)hasPadding {
    _hasPadding = hasPadding;
    self.placeholderLayer.frame = CGRectMake(self.hasPadding ? 16 : 0, ViewHeight(self) / 2 - 7, ViewWidth(self) - 32, 14);
    self.underlineGrayLayer.frame = CGRectMake(0, ViewHeight(self) - (self.hasPadding ? 1 : 9), ViewWidth(self), 1);
    self.underlineLayer.frame = CGRectMake(0, ViewHeight(self) - (self.hasPadding ? 1 : 9), ViewWidth(self), 1);
}

- (void)editingAnimation:(BOOL)begin {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat duration = 0.3;
    
    if (self.text.length == 0) {
        CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        
        moveAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(width / 2, height / 2 + (begin ? 0 : -18))];
        moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(width / 2, height / 2 + (begin ? -18 : 0))];
        moveAnimation.duration = duration;
        moveAnimation.fillMode = kCAFillModeForwards;
        moveAnimation.removedOnCompletion = NO;
        [self.placeholderLayer addAnimation:moveAnimation forKey:@"position"];
        self.placeholderUp = YES;
    }
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pathAnimation.duration = duration;
    pathAnimation.fromValue = @(begin ? 0 : 1);
    pathAnimation.toValue = @(begin ? 1 : 0);
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    [self.underlineLayer addAnimation:pathAnimation forKey:@"transform"];
}

- (void)beginEditingAnimation {
    [self editingAnimation:YES];
}

- (void)endEditingAnimation {
    [self editingAnimation:NO];
}
@end
