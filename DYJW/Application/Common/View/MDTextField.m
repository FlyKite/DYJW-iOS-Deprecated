//
//  MDTextField.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDTextField.h"
#import "MDColor.h"

@interface MDTextField () <UITextFieldDelegate> {
    UIView *underlineGray;
    UIView *underline;
    int labelTextSize;
}
@end

@implementation MDTextField
- (id) initWithFrame:(CGRect)frame {
    frame.size.height = 48;
    if (self = [super initWithFrame:frame]) {
        [self setFont:[UIFont systemFontOfSize:16]];
        
        labelTextSize = 12;
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont systemFontOfSize:labelTextSize]];
        _label.textColor = [MDColor grey500];
        [self addSubview:_label];
        
        underlineGray = [[UIView alloc] init];
        underlineGray.backgroundColor = [MDColor grey300];
        [self addSubview:underlineGray];
        
        underline = [[UIView alloc] init];
        underline.backgroundColor = [MDColor lightBlue500];
        [self addSubview:underline];
        
        self.delegate = self;
        self.frame = frame;
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    _label.frame = CGRectMake(0, 18, frame.size.width, 12);
    underlineGray.frame = CGRectMake(0, frame.size.height - 9, frame.size.width, 1);
    underline.frame = CGRectMake(0, frame.size.height - 1, 0, 2);
    underline.center = CGPointMake(frame.size.width / 2, frame.size.height - 9);
}

- (void) setLabelText:(NSString *)string {
    _label.text = string;
}

- (void) setUnderlineColorOnFocus:(UIColor *)color {
    underline.backgroundColor = color;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        underline.frame = CGRectMake(0, 0, self.frame.size.width, 2);
        underline.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 9);
        _label.frame = CGRectMake(0, 0, self.frame.size.width, 12);
    } completion:nil];
    return YES;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textFieldShouldBeginEditing:self];
    [self textFieldDidEndEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        underline.frame = CGRectMake(0, 0, 0, 2);
        underline.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 9);
        if ([self.text length] == 0) {
            _label.frame = CGRectMake(0, 18, self.frame.size.width, 12);
        }
    }];
}
@end
