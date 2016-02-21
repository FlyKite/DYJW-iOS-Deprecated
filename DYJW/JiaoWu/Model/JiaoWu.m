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
#import "ChengJi.h"
#import "Course.h"

@interface JiaoWu ()
@property (nonatomic)UserInfo *user;
@end

@implementation JiaoWu
+ (id)jiaowu {
    NSHTTPCookie *cookie = [UserInfo cookie];
    if (cookie) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    return [[self alloc] init];
}

// MARK::登录
- (BOOL)loginWithVerifycode:(NSString *)verifycode success:(void(^)(void))success failure:(void(^)(NSString *))failure {
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
                        if (success) {
                            success();
                        } else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"SUCCESS"];
                        }
                    } failure:nil];
                } failure:nil];
            } failure:nil];
        } else {
            // 账号密码错误
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            NSString *error = doc.Query(@"span#errorinfo").text();
            NSLog(@"该账号不存在或密码错误：%@", error);
            if (failure) {
                failure(error);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:error];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 网络连接失败
        NSLog(@"%@", error);
        if (failure) {
            failure(@"网络异常");
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"NET_ERROR"];
        }
    }];
    return true;
}

// MARK::获取学期列表
- (void)getXueqiList:(void (^)(NSArray *, NSString *))success addAllXueqi:(BOOL)allXueqi {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://jwgl.nepu.edu.cn/tkglAction.do?method=kbxxXs" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        NSArray *elms = doc.Query(@"#xnxqh").first().Query(@"option");
        NSMutableArray *xueqiArray = [[NSMutableArray alloc] init];
        for (OCGumboNode *node in elms) {
            NSString *text = node.text();
            [xueqiArray addObject:text];
            if ([text isEqualToString:@"---请选择---"] && allXueqi) {
                [xueqiArray addObject:@"全部学期"];
            }
        }
        if (success) {
            success(xueqiArray, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil, nil);
    }];
}

// MARK::获取某学期成绩
- (void)getChengJiWithKKXQ:(NSString *)kkxq success:(void (^)(NSArray *, NSString *, NSString *))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *params = @{
                             @"kksj" : kkxq,
                             @"kcxz" : @"",
                             @"kcmc" : @"",
                             @"xsfs" : @""
                             };
    [manager POST:@"http://jwgl.nepu.edu.cn/xszqcjglAction.do?method=queryxscj" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        // 获取绩点
        OCGumboNode *jd = doc.Query(@"#tblBm").first().Query(@"td").first();
        NSString *xuefen = jd.Query(@"span").get(1).text();
        NSString *jidian = jd.Query(@"span").get(3).text();
        // 成绩表格,每行为一条记录
        OCGumboNode *table = doc.Query(@"#mxh").first();
        NSMutableArray *chengjiArray = [[NSMutableArray alloc] init];
        for (OCGumboNode *row in table.Query(@"tr")) {
            OCQueryObject *cols = row.Query(@"td");
            ChengJi *model = [[ChengJi alloc] init];
            
            // 总成绩以及是否及格
            OCGumboElement *chengji = (OCGumboElement *)cols.get(5).Query(@"a").first();
            NSString *chengjiText = chengji.text();
            NSString *flag;
            if ([self isNumber:chengjiText]) {
                NSInteger score = [chengjiText integerValue];
                flag = score >= 60 ? @"√" : @"×";
            } else {
                flag = [chengjiText substringToIndex:1];
            }
            model.zongchengji = chengjiText;
            model.flag = flag;
            
            // 成绩信息
            if (cols.count > 4) model.courseName = cols.get(4).text();
            if (cols.count > 6) model.chengjibiaozhi = cols.get(6).text();
            if (cols.count > 7) model.kechengxingzhi = cols.get(7).text();
            if (cols.count > 8) model.kechengleibie = cols.get(8).text();
            if (cols.count > 9) model.xueshi = cols.get(9).text();
            if (cols.count > 10) model.xuefen = cols.get(10).text();
            if (cols.count > 11) model.kaoshixingzhi = cols.get(11).text();
            if (cols.count > 12) model.buchongxueqi = cols.get(12).text();
            
            // 成绩详情URL
            NSString *detailURL = [chengji getAttribute:@"onclick"];
            NSInteger start = [detailURL rangeOfString:@"/"].location;
            NSInteger end = [detailURL rangeOfString:@"'" options:NSBackwardsSearch].location;
            detailURL = [detailURL substringWithRange:NSMakeRange(start, end - start)];
            model.detailURL = detailURL;
            
            [model initLeftAndRightString];
            [chengjiArray addObject:model];
        }
        if (success) {
            success([chengjiArray copy], xuefen, jidian);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil, nil, nil);
    }];
}

// MARK::获取成绩详情
- (void)getChengJiDetail:(NSString *)url success:(void (^)(NSString *))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        OCQueryObject *tabs = doc.Query(@"#tblHead").first().Query(@"th");
        OCQueryObject *items = doc.Query(@"#mxh").first().Query(@"td");
        NSMutableString *detail = [[NSMutableString alloc] init];
        for (int i = 0; i < tabs.count && i < items.count; i++) {
            [detail appendFormat:@"%@：%@\n", tabs.get(i).text(), items.get(i).text()];
        }
        NSString *result = detail.length > 0 ? [detail substringToIndex:detail.length - 1] : @"未查询到成绩详情";
        if (success) {
            success(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil);
    }];
}

// MARK::获取课表
- (void)getKeBiaoWithKKXQ:(NSString *)kkxq andBJBH:(NSString *)bjbh success:(void (^)(NSArray *))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    UserInfo *user = [UserInfo userInfo];
    NSDictionary *params = @{
                             @"method" : @"goListKbByXs",
                             @"sql" : @"",
                             @"xnxqh" : kkxq,
                             @"zc" : @"",
                             @"xs0101id": user.username
                             };
    [manager POST:@"http://jwgl.nepu.edu.cn/tkglAction.do" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        OCQueryObject *tb = doc.Query(@"#kbtable");
        if (tb.count == 0) {
            [self getNewKeBiaoWithKKXQ:kkxq andBJBH:bjbh success:success];
            return;
        }
        OCQueryObject *rows = tb.first().Query(@"tr");
        NSMutableArray *courses = [[NSMutableArray alloc] init];
        for (int i = 1; i < 7; i++) {
            OCQueryObject *cols = rows.get(i).Query(@"td");
            for (int j = 1; j < 8; j++) {
                Course *course = [[Course alloc] init];
                NSMutableString *html = [cols.get(j).Query(@"div").get(1).html() mutableCopy];
                [html replaceOccurrencesOfString:@"\n" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                [html replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                [html replaceOccurrencesOfString:@"<nobr>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                [html replaceOccurrencesOfString:@"</nobr>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                if (html.length > 5) {
                    [html deleteCharactersInRange:NSMakeRange(html.length - 4, 4)];
                    [html replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                    [html replaceOccurrencesOfString:@"<br/>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                }
                course.rawText = [html copy];
                [courses addObject:course];
            }
        }
        if (success) {
            success([courses copy]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil);
    }];
}

- (void)getNewKeBiaoWithKKXQ:(NSString *)kkxq andBJBH:(NSString *)bjbh success:(void (^)(NSArray *))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    UserInfo *user = [UserInfo userInfo];
    NSString *url = [NSString stringWithFormat:@"http://jwgl.nepu.edu.cn/tkglAction.do?method=printExcel&sql=&type=xsdy&bjbh=%@&xnxqh=%@&xsid=%@&excelFs=server", bjbh, kkxq, user.username];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSInteger bodyStart = [html rangeOfString:@"<body"].location;
        html = [html substringWithRange:NSMakeRange(bodyStart, [html rangeOfString:@"body>"].location - bodyStart + 5)];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        OCQueryObject *rows = doc.Query(@"tr");
        NSMutableArray *courses = [[NSMutableArray alloc] init];
        for(int i = 3; i < 9; i++) {
            OCQueryObject *cols = rows.get(i).Query(@"td");
            for(int j = 1; j < 8; j++) {
                Course *course = [[Course alloc] init];
                NSMutableString *html = [cols.get(j).html() mutableCopy];
                [html replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                [html replaceOccurrencesOfString:@"<br>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                [html replaceOccurrencesOfString:@"</br>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, html.length)];
                course.rawText = [html copy];
                [courses addObject:course];
            }
        }
        if (success) {
            success([courses copy]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil);
    }];
}

// MARK::判断字符串是否为数字
- (BOOL)isNumber:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

- (UserInfo *)user {
    if (!_user) {
        _user = [UserInfo userInfo];
    }
    return _user;
}
@end
