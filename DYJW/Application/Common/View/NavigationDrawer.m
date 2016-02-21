//
//  NavigationDrawer.m
//  DYJW
//
//  Created by 风筝 on 15/10/19.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "NavigationDrawer.h"
#import "MDColor.h"
#import "FunctionCell.h"
#import "UserInfo.h"
#import "MDAlertView.h"

#define StatusBarHeight 20
#define ToolbarHeight 56
#define AnimationDuration 0.3
#define Padding 8

@interface NavigationDrawer () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak)UIView *mask;
@property (nonatomic, weak)UIView *drawer;
@end

@implementation NavigationDrawer
+ (id)drawer {
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame {
    CGSize size = [UIScreen mainScreen].bounds.size;
    frame.origin.x = -size.width;
    frame.origin.y = ToolbarHeight + StatusBarHeight;
    frame.size.width = size.width;
    frame.size.height = size.height - ToolbarHeight - StatusBarHeight;
    if (self = [super initWithFrame:frame]) {
        self.mask.alpha = 0;
        
        self.userIconView.image = [UIImage imageNamed:@"default_user"];
        UserInfo *user = [UserInfo userInfo];
        if (user.name) {
            self.usernameLabel.text = user.name;
            [self.loginButton setTitle:@"注销" forState:UIControlStateNormal];
        } else {
            self.usernameLabel.text = @"请登录教务管理系统";
            [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        }
        [self.functionList selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:@"LOGIN" object:nil];
    }
    return self;
}

- (void)loginSuccess:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"SUCCESS"]) {
        UserInfo *user = [UserInfo userInfo];
        self.usernameLabel.text = user.name;
        [self.loginButton setTitle:@"注销" forState:UIControlStateNormal];
    }
}

- (UIView *)mask {
    if (!_mask) {
        UIView *mask = [[UIView alloc] initWithFrame:self.bounds];
        mask.backgroundColor = [MDColor grey900];
        [self addSubview:mask];
        _mask = mask;
    }
    return _mask;
}

- (UIView *)drawer {
    if (!_drawer) {
        CGSize size = self.frame.size;
        CGRect frame = self.bounds;
        frame.size.width = size.width / 3 * 2;
        frame.origin.x = -size.width;
        UIView *drawer = [[UIView alloc] initWithFrame:frame];
        drawer.backgroundColor = [MDColor whiteColor];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:drawer.bounds];
        drawer.layer.masksToBounds = NO;
        drawer.layer.shadowColor = [MDColor grey900].CGColor;
        drawer.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        drawer.layer.shadowOpacity = 0.8f;
        drawer.layer.shadowPath = shadowPath.CGPath;
        [self addSubview:drawer];
        _drawer = drawer;
    }
    return _drawer;
}

- (void)setStateValue:(CGFloat)stateValue {
    stateValue = stateValue > 1 ? 1 : (stateValue < 0 ? 0 : stateValue);
//    CGFloat duration = ((stateValue - 1) * self.frame.size.width * 2 / 3 - self.drawer.frame.origin.x) / self.frame.size.width * 2 / 3;
    CGFloat duration = ((stateValue - 1) * self.drawer.frame.size.width - self.drawer.frame.origin.x) / self.drawer.frame.size.width * AnimationDuration;
    duration = duration > 0 ? duration : -duration;
    if (stateValue != 0) {
        CGRect frame = self.frame;
        frame.origin.x = 0;
        self.frame = frame;
    }
    [UIView animateWithDuration:duration animations:^{
        self.mask.alpha = stateValue / 2;
        
        CGRect frame = self.drawer.frame;
        frame.origin.x = (stateValue - 1) * self.frame.size.width * 2 / 3;
        self.drawer.frame = frame;
    } completion:^(BOOL finished) {
        if (stateValue == 0) {
            CGRect frame = self.frame;
            frame.origin.x = -self.frame.size.width;
            self.frame = frame;
        }
        _stateValue = stateValue;
    }];
}

- (UIImageView *)userIconView {
    if (!_userIconView) {
        UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.drawer.frame.size.width / 2 - 40, Padding * 1.5, 80, 80)];
        userIcon.layer.cornerRadius = 40;
        userIcon.clipsToBounds = YES;
        [self.headView addSubview:userIcon];
        _userIconView = userIcon;
    }
    return _userIconView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(0, 80 + Padding * 2.5, self.drawer.frame.size.width, 18)];
        username.textColor = [MDColor whiteColor];
        username.textAlignment = NSTextAlignmentCenter;
        [self.headView addSubview:username];
        _usernameLabel = username;
    }
    return _usernameLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 86, 24);
        btn.center = CGPointMake(self.drawer.frame.size.width / 2, 80 + 18 + 12 + Padding * 3.5);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [[MDColor whiteColor] CGColor];
        btn.layer.cornerRadius = 6;
        btn.clipsToBounds = YES;
        [btn setBackgroundImage:[MDColor pureColorImageWithColor:[MDColor lightBlue500] andSize:CGSizeMake(86, 24)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[MDColor pureColorImageWithColor:[MDColor lightBlue300] andSize:CGSizeMake(86, 24)] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:btn];
        _loginButton = btn;
    }
    return _loginButton;
}

- (void)loginButtonClick {
    if ([self.loginButton.titleLabel.text isEqualToString:@"登录"]) {
        [self.functionList selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self.delegate changeFunction:2];
    } else {
        MDAlertView *alertView  = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
        alertView.title = @"注销";
        alertView.message = @"确认注销当前账号？";
        [alertView setPositiveButton:@"确定" andAction:^{
            [UserInfo clearUserInfo];
            [UserInfo clearCookies];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"LOGOUT"];
            [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
            self.usernameLabel.text = @"请登录教务管理系统";
        }];
        [alertView setNegativeButton:@"取消" andAction:nil];
        [alertView show];
    }
}

- (UIView *)headView {
    if (!_headView) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.drawer.frame.size.width, 80 + 18 + 24 + Padding * 5)];
        headView.backgroundColor = [MDColor lightBlue500];
        [self.drawer addSubview:headView];
        _headView = headView;
    }
    return _headView;
}

- (UITableView *)functionList {
    if (!_functionList) {
        UITableView *list = [[UITableView alloc]initWithFrame:CGRectMake(0, self.headView.frame.size.height, self.drawer.frame.size.width, self.frame.size.height - self.headView.frame.size.height) style:UITableViewStylePlain];
        list.separatorStyle = UITableViewCellSeparatorStyleNone;
        list.bounces = NO;
        list.showsVerticalScrollIndicator = NO;
        list.dataSource = self;
        list.delegate = self;
        [self.drawer addSubview:list];
        _functionList = list;
    }
    return _functionList;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FunctionCell *cell = [FunctionCell cellWithTableView:tableView];
    NSArray *functionArray = @[@"我的课表", @"黎明湖畔", @"教务系统", @"东油新闻", @"教务通知"];
    NSArray *iconArray = @[@"course_blue", @"market_blue", @"jiaowu_blue", @"news_blue", @"notice_blue"];
    cell.titleLabel.text = functionArray[indexPath.row];
    cell.functionImage.image = [UIImage imageNamed:iconArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate changeFunction:indexPath.row];
}

@end
