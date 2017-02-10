//
//  BasicJiaoWuController.m
//  DYJW
//
//  Created by 风筝 on 16/2/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "BasicJiaoWuController.h"
#import "UserInfo.h"
#import "MDAlertView.h"
#import "VerifyAlertCustomView.h"
#import "JiaoWu.h"

@interface BasicJiaoWuController ()

@end

@implementation BasicJiaoWuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [MDColor grey50];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 检查登录状态
    UserInfo *loginUser = [UserInfo userInfo];
    NSTimeInterval timeElapsed = [[NSDate date] timeIntervalSince1970] - loginUser.logintime;
    if (timeElapsed > 20 * 60) {
        [self inputVerifyCode:@""];
        return;
    }
}

- (void)inputVerifyCode:(NSString *)msg {
    [UserInfo clearCookies];
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleCustom];
    alertView.title = @"请输入验证码";
    VerifyAlertCustomView *customView = [VerifyAlertCustomView viewWithMessage:msg];
    alertView.customView = customView;
    alertView.canCancelTouchOutside = NO;
    [alertView setPositiveButton:@"登录" andAction:^{
        NSString *vcd = customView.verifycodeField.text;
        if (vcd.length != 4) {
            [self inputVerifyCode:@"请输入验证码"];
        } else {
            JiaoWu *jiaowu = [JiaoWu jiaowu];
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
            alertView.message = @"正在登录...";
            [alertView show];
            [jiaowu loginWithVerifycode:vcd success:^{
                [alertView dismiss];
            } failure:^(NSString *error) {
                [alertView dismiss];
                [self inputVerifyCode:error];
            }];
        }
    }];
    [alertView setNegativeButton:@"取消" andAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
