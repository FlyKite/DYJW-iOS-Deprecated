//
//  JiaoWuController.m
//  DYJW
//
//  Created by 风筝 on 15/10/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "JiaoWuController.h"
#import "LoginView.h"
#import "MDColor.h"
#import "UserInfo.h"
#import "SystemPanel.h"
#import <iAd/iAd.h>

@interface JiaoWuController () <ADBannerViewDelegate>
@property (nonatomic, weak)LoginView *loginView;
@property (nonatomic, strong)ADBannerView *bannerView;
@property (nonatomic, weak)SystemPanel *systemPanel;
@end

@implementation JiaoWuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkAccount];
    self.view.backgroundColor = [MDColor grey50];
//    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
//        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//    }
//    else {
//        _bannerView = [[ADBannerView alloc] init];
//    }
//    self.bannerView.delegate = self;
//    CGRect frame = self.bannerView.frame;
//    frame.origin.y = self.view.frame.size.height - frame.size.height - 76;
//    self.bannerView.frame = frame;
//    [self.view addSubview:self.bannerView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"LOGIN" object:nil];
}

- (void)loginSuccess:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"SUCCESS"]) {
        [self.loginView hide];
        [self.systemPanel show];
    } else if ([notification.object isEqualToString:@"ACCOUNT_ERROR"]) {
        
    } else if ([notification.object isEqualToString:@"NET_ERROR"]) {
        
    } else if ([notification.object isEqualToString:@"LOGOUT"]) {
        [self.loginView show];
        [self.systemPanel hide];
    }
}

- (void)checkAccount {
    UserInfo *loginUser = [UserInfo userInfo];
    if (loginUser.username) {
        // 已经登录过
        [self.systemPanel show];
//        NSNumber *loginTime = loginUser[@"LOGINTIME"];
    } else {
        // 尚未登录
        [self.loginView show];
//        self.loginView.usernameField.text = @"121501140113";
//        self.loginView.passwordField.text = @"121501140113";
    }
}

- (LoginView *)loginView {
    if (!_loginView) {
        LoginView *loginView = [[LoginView alloc] init];
        [self.view addSubview:loginView];
        self.loginView = loginView;
    }
    return _loginView;
}

- (SystemPanel *)systemPanel {
    if (!_systemPanel) {
        SystemPanel *systemPanel = [[SystemPanel alloc] init];
        [self.view addSubview:systemPanel];
        self.systemPanel = systemPanel;
    }
    return _systemPanel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
