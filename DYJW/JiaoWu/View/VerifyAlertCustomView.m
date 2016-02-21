//
//  VerifyAlertCustomView.m
//  DYJW
//
//  Created by 风筝 on 16/2/3.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "VerifyAlertCustomView.h"
#import "VerifyCode.h"

#define Padding 16

@interface VerifyAlertCustomView ()
@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, weak)UILabel *messageLabel;
@end

@implementation VerifyAlertCustomView
+ (instancetype)viewWithMessage:(NSString *)message {
    return [[self alloc] initWithMessage:message];
}

- (id)initWithMessage:(NSString *)message {
    self.message = message;
    self = [super init];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    frame.size.height = 48;
    frame.size.width = ScreenWidth - 24 * 4;
    if (self.message) {
        frame.size.height += 36;
    }
    if (self = [super initWithFrame:frame]) {
        [self verifycodeField];
        [self verifycodeImage];
        [self loadVerifyCode];
        if (self.message) {
            self.messageLabel.text = self.message;
        }
    }
    return self;
}

- (void)loadVerifyCode {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    VerifyCode *vc = [[VerifyCode alloc] init];
    [vc loadVerifyCodeImageSuccess:^(UIImage *verifycodeImage, NSString *recognizedCode) {
        [self performSelectorOnMainThread:@selector(setVCImage:) withObject:verifycodeImage waitUntilDone:YES];
        [self performSelectorOnMainThread:@selector(setVCStr:) withObject:recognizedCode waitUntilDone:YES];
    } failure:^{
        NSLog(@"加载失败");
        UIImage *image = [UIImage imageNamed:@"click_to_refresh"];
        [self performSelectorOnMainThread:@selector(setVCImage:) withObject:image waitUntilDone:YES];
    }];
}

- (void)setVCImage:(UIImage *)image {
    self.verifycodeImage.image = image;
    self.isLoading = NO;
}

- (void)setVCStr:(NSString *)code {
    self.verifycodeField.text = code;
}

- (MDTextField *)verifycodeField {
    if (!_verifycodeField) {
        MDTextField *field = [[MDTextField alloc] initWithFrame:CGRectMake(0, 0, (ViewWidth(self) - Padding) / 2, 48)];
        field.placeholder = @"验证码";
        [self addSubview:field];
        _verifycodeField = field;
    }
    return _verifycodeField;
}

- (UIImageView *)verifycodeImage {
    if (!_verifycodeImage) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 90, 32)];
        CGPoint center = image.center;
        center.x = ViewWidth(self) / 4 * 3;
        image.center = center;
        image.backgroundColor = [MDColor grey500];
        image.image = [UIImage imageNamed:@"click_to_refresh"];
        image.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadVerifyCode)];
        [image addGestureRecognizer:tap];
        [self addSubview:image];
        _verifycodeImage = image;
    }
    return _verifycodeImage;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, ViewWidth(self), 36)];
        label.textColor = [MDColor red500];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 1;
        [self addSubview:label];
        _messageLabel = label;
    }
    return _messageLabel;
}
@end
