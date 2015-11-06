//
//  JiaoWu.m
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "JiaoWu.h"
#import "AFNetworking.h"
#import "UserInfo.h"
#import "OCGumbo+Query.h"

@interface JiaoWu ()
@property (nonatomic)UserInfo *user;
@end

@implementation JiaoWu
+ (id)jiaowu {
    return [[self alloc] init];
}
- (BOOL)loginWithVerifycode:(NSString *)verifycode {
    NSDictionary *params = @{
                             @"USERNAME" : self.user.username,
                             @"PASSWORD" : self.user.password,
                             @"RANDOMCODE" : verifycode
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://jwgl.nepu.edu.cn/Logon.do?method=logon" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([html rangeOfString:@"window.location.href='http://jwgl.nepu.edu.cn/framework/main.jsp'"].location != NSNotFound) {
            // 登陆成功
            // 保存Cookie及登录时间
            [UserInfo saveCookieWithUrl:@"http://jwgl.nepu.edu.cn/Logon.do?method=logon"];
            [UserInfo updateLoginTime:[[NSDate date] timeIntervalSince1970]];
            
            // 获取姓名
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            [manager POST:@"http://jwgl.nepu.edu.cn/framework/main.jsp" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
                NSString *title = doc.Query(@"title").text();
                NSString *name = [title substringToIndex:[title rangeOfString:@"["].location];
                [UserInfo saveName:name];
                
                // logonBySSO
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager POST:@"http://jwgl.nepu.edu.cn/Logon.do?method=logonBySSO" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    // 修改数据条目为200条
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    NSDictionary *param = @{
                                             @"account" : self.user.username,
                                             @"realName" : self.user.name,
                                             @"pwdQuestion1" : @"",
                                             @"pwdAnswer1" : @"",
                                             @"pwdQuestion2" : @"",
                                             @"pwdAnswer2" : @"",
                                             @"pageSize" : @"200",
                                             @"zjftxt" : @"",
                                             @"kyjftxt" : @""
                                             };
                    [manager POST:@"http://jwgl.nepu.edu.cn/yhxigl.do?method=editUserInfo" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                        // 登录成功，发出通知
                        NSLog(@"登录成功");
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"SUCCESS"];
                    } failure:nil];
                } failure:nil];
            } failure:nil];
        } else {
            // 账号密码错误
            NSLog(@"该账号不存在或密码错误！");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"ACCOUNT_ERROR"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 网络连接失败
        NSLog(@"%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"NET_ERROR"];
    }];
    return true;
}

- (UserInfo *)user {
    if (!_user) {
        _user = [UserInfo userInfo];
    }
    return _user;
}
@end
