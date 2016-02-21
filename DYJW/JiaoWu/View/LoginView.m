//
//  LoginView.m
//  DYJW
//
//  Created by 风筝 on 15/10/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "LoginView.h"
#import "MDColor.h"
#import "VerifyCode.h"
#import "JiaoWu.h"
#import "UserInfo.h"
#import "MDProgressView.h"

#define Padding 16
#define Duration 0.5

@interface LoginView ()
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, assign)BOOL isLoading;
@property (nonatomic, weak)MDProgressView *imageLoadingView;
@property (nonatomic, weak)MDProgressView *loginLoadingView;
@property (nonatomic, weak)UILabel *errorLabel;
@end

@implementation LoginView
- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = CGRectMake(Padding, Padding, ViewWidth(newSuperview) - 2 * Padding, 48 * 4 + 36 + Padding * 3);
    self.layer.cornerRadius = 2;
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [MDColor grey500].CGColor;
    self.layer.shadowOpacity = 0.75;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.backgroundColor = [MDColor whiteColor];
    
    self.titleLabel.text = @"登录教务管理系统";
    [self usernameField];
    [self passwordField];
    [self verifycodeField];
    [self loginButton];
    [self verifycodeImage];
    self.isLoading = NO;
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

- (void)show {
    [self loadVerifyCode];
    self.loginButton.enabled = YES;
    self.loginLoadingView.hidden = YES;
    self.errorMsg = @"";
    CGRect frame = self.frame;
    frame.origin.y = -frame.size.height;
    self.frame = frame;
    self.alpha = 0;
    self.hidden = NO;
    [UIView animateWithDuration:Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.frame;
        frame.origin.y = Padding;
        self.frame = frame;
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hide {
    CGRect frame = self.frame;
    frame.origin.y = Padding;
    self.frame = frame;
    self.alpha = 1;
    [self.usernameField endEditing:YES];
    [self.passwordField endEditing:YES];
    [self.verifycodeField endEditing:YES];
    [UIView animateWithDuration:Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.frame;
        frame.origin.y = frame.size.height;
        self.frame = frame;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)logout {
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    self.verifycodeField.text = @"";
    [self loadVerifyCode];
}

#pragma mark - Setters
- (void)setVCImage:(UIImage *)image {
    self.verifycodeImage.image = image;
    self.isLoading = NO;
}

- (void)setVCStr:(NSString *)code {
    self.verifycodeField.text = code;
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    self.verifycodeImage.hidden = isLoading;
    self.imageLoadingView.hidden = !isLoading;
}

- (void)setErrorMsg:(NSString *)errorMsg {
    _errorMsg = errorMsg;
    self.errorLabel.text = errorMsg;
    self.loginButton.enabled = YES;
    self.loginLoadingView.hidden = YES;
    [self loadVerifyCode];
}

#pragma mark - Getters
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Padding, 0, ViewWidth(self) - Padding * 2, 48)];
        label.textColor = [MDColor grey700];
        label.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (MDTextField *)usernameField {
    if (!_usernameField) {
        MDTextField *field = [[MDTextField alloc] initWithFrame:CGRectMake(Padding, 48, ViewWidth(self) - Padding * 2, 48)];
        field.placeholder = @"用户名";
        [self addSubview:field];
        _usernameField = field;
    }
    return _usernameField;
}

- (MDTextField *)passwordField {
    if (!_passwordField) {
        MDTextField *field = [[MDTextField alloc] initWithFrame:CGRectMake(Padding, 48 * 2, ViewWidth(self) - Padding * 2, 48)];
        field.placeholder = @"密码";
        field.secureTextEntry = YES;
        [self addSubview:field];
        _passwordField = field;
    }
    return _passwordField;
}

- (MDTextField *)verifycodeField {
    if (!_verifycodeField) {
        MDTextField *field = [[MDTextField alloc] initWithFrame:CGRectMake(Padding, 48 * 3, (ViewWidth(self) - Padding * 2) / 2, 48)];
        field.placeholder = @"验证码";
//        field.
        [self addSubview:field];
        _verifycodeField = field;
    }
    return _verifycodeField;
}

- (UIImageView *)verifycodeImage {
    if (!_verifycodeImage) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 48 * 3 + 8, 90, 32)];
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

- (MDProgressView *)imageLoadingView {
    if (!_imageLoadingView) {
        MDProgressView *progress = [MDProgressView progressViewWithStyle:MDProgressViewStyleLoadingSmall];
        CGPoint center = self.verifycodeImage.center;
        center.x -= 50;
        progress.center = center;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ViewWidth(progress), 0, 100, ViewHeight(progress))];
        label.text = @"正在加载...";
        label.textColor = [MDColor grey500];
        label.textAlignment = NSTextAlignmentCenter;
        [progress addSubview:label];
        [self addSubview:progress];
        _imageLoadingView = progress;
    }
    return _imageLoadingView;
}

- (MDProgressView *)loginLoadingView {
    if (!_loginLoadingView) {
        MDProgressView *progress = [MDProgressView progressViewWithStyle:MDProgressViewStyleLoadingSmall];
        CGPoint center = self.loginButton.center;
        center.x -= ViewWidth(self.loginButton) / 2 + ViewWidth(progress) / 2;
        progress.center = center;
        [self addSubview:progress];
        _loginLoadingView = progress;
    }
    return _loginLoadingView;
}

- (MDFlatButton *)loginButton {
    if (!_loginButton) {
        MDFlatButton *button = [MDFlatButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitle:@"正在登录" forState:UIControlStateDisabled];
        [button setTitleColor:[MDColor grey500] forState:UIControlStateDisabled];
        CGRect frame = button.frame;
        frame.origin.x = ViewWidth(self) - Padding - frame.size.width;
        frame.origin.y = 48 * 4 + Padding * 2;
        button.frame = frame;
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _loginButton = button;
    }
    return _loginButton;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(Padding, ViewY(self.loginButton), ViewY(self.loginButton) - 2 * Padding, 36)];
        label.textColor = [MDColor red500];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 2;
        [self addSubview:label];
        _errorLabel = label;
    }
    return _errorLabel;
}

#pragma  mark - Login button click
- (void)loginClick {
    [self saveUser];
    JiaoWu *jiaowu = [[JiaoWu alloc] init];
    [jiaowu loginWithVerifycode:self.verifycodeField.text success:nil failure:nil];
    self.loginButton.enabled = NO;
    self.loginLoadingView.hidden = NO;
    _errorMsg = @"";
    self.errorLabel.text = @"";
}

- (void)saveUser {
    [UserInfo saveUsername:self.usernameField.text andPassword:self.passwordField.text andLoginTime:0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
