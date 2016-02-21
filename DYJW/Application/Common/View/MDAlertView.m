//
//  MDAlertView.m
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "MDAlertView.h"
#import "NSString+Height.h"
#import "MDFlatButton.h"
#import "MDProgressView.h"

@interface MDAlertView ()
@property (nonatomic, weak)UIView *maskView;
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *contentLabel;
@property (nonatomic, weak)MDProgressView *loadingView;
@property (nonatomic, weak)MDProgressView *progressView;
@property (nonatomic, weak)MDFlatButton *positiveButton;
@property (nonatomic, weak)MDFlatButton *negativeButton;
@property (nonatomic, copy)void(^positiveAction)();
@property (nonatomic, copy)void(^negativeAction)();
@property (nonatomic, assign)BOOL shown;
@end

@implementation MDAlertView
+ (instancetype)alertViewWithStyle:(MDAlertViewStyle)style {
    MDAlertView *alertView = [[self alloc] initWithViewStyle:style];
    return alertView;
}

- (id)initWithViewStyle:(MDAlertViewStyle)style {
    _style = style;
    if (self = [super initWithFrame:ScreenBounds]) {
        self.alpha = 0;
        self.canCancelTouchOutside = YES;
        [self maskView];
    }
    return self;
}

- (UIView *)maskView {
    if (!_maskView) {
        UIView *view = [[UIView alloc] initWithFrame:ScreenBounds];
        view.backgroundColor = [[MDColor grey900] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        _maskView = view;
    }
    return _maskView;
}

- (void)touchOutside {
    if (self.canCancelTouchOutside) {
        [self dismiss];
    }
}

#pragma mark - Setters
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
    [self calcViewFrames];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.contentLabel.text = message;
    [self calcViewFrames];
}

- (void)setCustomView:(UIView *)customView {
    if (_customView != customView) {
        [_customView removeFromSuperview];
    }
    _customView = customView;
    [self.contentView addSubview:customView];
    [self calcViewFrames];
}

- (void)setPositiveButton:(NSString *)text andAction:(void (^)(void))positiveAction {
    self.positiveAction = positiveAction;
    [self.positiveButton setTitle:text forState:UIControlStateNormal];
    [self calcViewFrames];
}

- (void)setNegativeButton:(NSString *)text andAction:(void (^)(void))negativeAction {
    self.negativeAction = negativeAction;
    [self.negativeButton setTitle:text forState:UIControlStateNormal];
    [self calcViewFrames];
}

- (void)buttonClick:(MDFlatButton *)button {
    if (button == self.positiveButton && self.positiveAction) {
        self.positiveAction();
    } else if (button == self.negativeButton && self.negativeAction) {
        self.negativeAction();
    }
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.2];
}

#pragma mark - Getters
- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [MDColor grey900].CGColor;
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowOffset = CGSizeMake(0, 15);
        view.layer.shadowRadius = 20;
        [self addSubview:view];
        _contentView = view;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [MDColor grey800];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [MDColor grey800];
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
        _contentLabel = label;
    }
    return _contentLabel;
}

- (MDProgressView *)loadingView {
    if (!_loadingView) {
        MDProgressView *loadingView = [MDProgressView progressViewWithStyle:MDProgressViewStyleLoadingMedium];
        [self.contentView addSubview:loadingView];
        _loadingView = loadingView;
    }
    return _loadingView;
}

- (MDFlatButton *)positiveButton {
    if (!_positiveButton) {
        MDFlatButton *button = [MDFlatButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:button];
        _positiveButton = button;
    }
    return _positiveButton;
}

- (MDFlatButton *)negativeButton {
    if (!_negativeButton) {
        MDFlatButton *button = [MDFlatButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [button setTitleColor:[MDColor grey900] forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        _negativeButton = button;
    }
    return _negativeButton;
}

#pragma mark - Show and dismiss
- (void)show {
    self.shown = YES;
    [Window addSubview:self];
    [self calcViewFrames];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)calcViewFrames {
    if (!self.shown) {
        return;
    }
    CGFloat contentViewWidth = ScreenWidth - 24 * 2;
    CGFloat labelWidth = contentViewWidth - 24 * 2;
    CGFloat labelX = 24;
    
    CGFloat titleY = 24;
    CGFloat titleHeight = [self.title heightWithFont:self.titleLabel.font withinWidth:labelWidth];
    self.titleLabel.frame = CGRectMake(labelX, titleY, labelWidth, titleHeight);
    
    CGFloat contentY = titleY + titleHeight + (titleHeight == 0 ? 0 : 18);
    CGFloat contentHeight;
    if (self.style == MDAlertViewStyleCustom) {
        contentHeight = self.customView.frame.size.height;
        self.customView.frame = CGRectMake(labelX, contentY, self.customView.frame.size.width, contentHeight);
        if (self.message) {
            contentY += contentHeight;
            contentHeight = [self.message heightWithFont:self.contentLabel.font withinWidth:labelWidth];
            self.contentLabel.frame = CGRectMake(labelX, contentY, labelWidth, contentHeight);
        }
    } else {
        if (self.style == MDAlertViewStyleLoading) {
            contentHeight = [self.message heightWithFont:self.contentLabel.font withinWidth:labelWidth - 56];
            self.contentLabel.frame = CGRectMake(64, contentY, labelWidth - 64, contentHeight);
            CGRect f = CGRectMake(8, contentY + (contentHeight / 2 - 24), 0, 0);
            self.loadingView.frame = f;
        } else {
            contentHeight = [self.message heightWithFont:self.contentLabel.font withinWidth:labelWidth];
            self.contentLabel.frame = CGRectMake(labelX, contentY, labelWidth, contentHeight);
        }
    }
    
    CGFloat buttonY = contentY + contentHeight + 24;
    CGFloat buttonHeight = 36;
    CGFloat positiveWidth = ViewWidth(self.positiveButton);
    CGFloat positiveX = contentViewWidth - 16 - positiveWidth;
    self.positiveButton.frame = CGRectMake(positiveX, buttonY, positiveWidth, buttonHeight);
    
    CGFloat negativeWidth = ViewWidth(self.negativeButton);
    CGFloat negativeX = contentViewWidth - 16 - positiveWidth - negativeWidth;
    self.negativeButton.frame = CGRectMake(negativeX, buttonY, negativeWidth, buttonHeight);
    
    CGFloat buttonShowHeight = buttonHeight + 16;
    if (self.positiveButton.titleLabel.text.length == 0
        && self.negativeButton.titleLabel.text.length == 0) {
        buttonShowHeight = 0;
    }
    CGFloat contentViewHeight = buttonY + buttonShowHeight;
    self.contentView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight);
    self.contentView.center = ViewCenter(self);
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
    self.contentView.layer.shadowPath = shadowPath.CGPath;
}
@end
