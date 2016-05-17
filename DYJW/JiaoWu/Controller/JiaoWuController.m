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
#import "ChengJiController.h"
#import "KeBiaoController.h"
#import "ChongXiuController.h"
#import "BuKaoController.h"
#import "JiHuaController.h"
#import "MDAlertView.h"
#import "VerifyAlertCustomView.h"
#import "JiaoWu.h"

@interface JiaoWuController () <SystemPanelDelegate>
@property (nonatomic, weak)LoginView *loginView;
@property (nonatomic, weak)SystemPanel *systemPanel;
@end

@implementation JiaoWuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkAccount];
    self.view.backgroundColor = [MDColor grey50];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"LOGIN" object:nil];
}

- (void)loginSuccess:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"SUCCESS"]) {
        [self.loginView hide];
        [self.systemPanel show];
    } else if ([notification.object isEqualToString:@"NET_ERROR"]) {
        self.loginView.errorMsg = @"登录失败，请重试";
    } else if ([notification.object isEqualToString:@"LOGOUT"]) {
        [self.loginView show];
        [self.systemPanel hide];
    } else if ([notification.object isEqualToString:@"RELOGIN"]) {
        
    } else {
        self.loginView.errorMsg = notification.object;
    }
}

- (void)checkAccount {
    UserInfo *loginUser = [UserInfo userInfo];
    if (loginUser.name) {
        // 已经登录过
        self.loginView.hidden = YES;
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
        systemPanel.delegate = self;
        [self.view addSubview:systemPanel];
        self.systemPanel = systemPanel;
    }
    return _systemPanel;
}

- (void)systemPanelButtonClick:(NSInteger)position {
    // 进入前先检查登录状态
    UserInfo *loginUser = [UserInfo userInfo];
    NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSince1970] - loginUser.logintime;
    if (timeElapsed > 20 * 60) {
        [self inputVerifyCode:nil withActionPosition:position];
        return;
    }
    // 进入相应功能模块
    UIViewController *vc;
    switch (position) {
        case 0:
            vc = [[ChengJiController alloc] init];
            break;
        case 1:
            vc = [[KeBiaoController alloc] init];
            break;
        case 2:
            vc = [[ChongXiuController alloc] init];
            break;
        case 3:
            vc = [[BuKaoController alloc] init];
            break;
        case 4:
            vc = [[JiHuaController alloc] init];
            break;
        default:
            return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)inputVerifyCode:(NSString *)msg withActionPosition:(NSInteger)position {
    [UserInfo clearCookies];
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleCustom];
    alertView.title = @"请输入验证码";
    VerifyAlertCustomView *customView = [VerifyAlertCustomView viewWithMessage:msg];
    alertView.customView = customView;
    alertView.canCancelTouchOutside = NO;
    [alertView setPositiveButton:@"登录" andAction:^{
        NSString *vcd = customView.verifycodeField.text;
        if (vcd.length != 4) {
            [self inputVerifyCode:@"请输入验证码" withActionPosition:position];
        } else {
            JiaoWu *jiaowu = [JiaoWu jiaowu];
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
            alertView.message = @"正在登录...";
            [alertView show];
            [jiaowu loginWithVerifycode:vcd success:^{
                [alertView dismiss];
                [self systemPanelButtonClick:position];
            } failure:^(NSString *error) {
                [alertView dismiss];
                [self inputVerifyCode:error withActionPosition:position];
            }];
        }
    }];
    [alertView setNegativeButton:@"取消" andAction:nil];
    [alertView show];
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
