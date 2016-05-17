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
                        [self loginToServer];
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

- (void)loginToServer {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *param = @{
                            @"username" : self.user.username,
                            @"last_jid" : [UserInfo cookie].value,
                            @"versioncode" : @1
                            };
    [manager POST:@"http://dyjw.fly-kite.com/app/login.aspx" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
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

// MARK::获取重修列表
- (void)getChongXiuList:(void(^)(NSString *, NSArray *))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = @"http://jwgl.nepu.edu.cn/zxglAction.do?method=xszxbmList";
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        NSString *bmsj = doc.Query(@"#tbTable").first().Query(@"td").get(0).text();
        if ([bmsj containsString:@"\n"]) {
            bmsj = [bmsj substringToIndex:[bmsj rangeOfString:@"\n"].location];
        }
        NSMutableArray *chongxiuArray = [[NSMutableArray alloc] init];
        OCQueryObject *rows = doc.Query(@"#mxh").first().Query(@"tr");
        BOOL sfkbm = [html containsString:@"var sfkbm = \"true\""];
        for (OCGumboNode *row in rows) {
            OCQueryObject *cols = row.Query(@"td");
            ChongXiuBuKao *model = [[ChongXiuBuKao alloc] init];
            NSMutableString *chongxiuInfo = [[NSMutableString alloc] init];
            [chongxiuInfo appendFormat:@"是否报名：%@\n", cols.get(0).text()];
            [chongxiuInfo appendFormat:@"上课院审：%@\n", cols.get(1).text()];
            [chongxiuInfo appendFormat:@"开课院审：%@\n", cols.get(2).text()];
            [chongxiuInfo appendFormat:@"取得资格：%@\n", cols.get(3).text()];
            [chongxiuInfo appendFormat:@"学年学期：%@\n", cols.get(4).text()];
            model.courseName = cols.get(5).text();
            [chongxiuInfo appendFormat:@"课程编号：%@\n", cols.get(6).text()];
            [chongxiuInfo appendFormat:@"考试性质：%@\n", cols.get(7).text()];
            [chongxiuInfo appendFormat:@"课程属性：%@\n", cols.get(8).text()];
            [chongxiuInfo appendFormat:@"课程性质：%@\n", cols.get(9).text()];
            [chongxiuInfo appendFormat:@"学时：%@\n", cols.get(10).text()];
            [chongxiuInfo appendFormat:@"学分：%@\n", cols.get(11).text()];
            [chongxiuInfo appendFormat:@"是否选课：%@\n", cols.get(17).text()];
            [chongxiuInfo appendFormat:@"是否缴费：%@\n", cols.get(18).text()];
            [chongxiuInfo appendFormat:@"性质：%@", cols.get(19).text()];
            model.info = chongxiuInfo;
            
            NSString *baomingUrl = cols.get(20).Query(@"a").get(0).attr(@"onclick");
            NSInteger start = [baomingUrl rangeOfString:@"('"].location + 2;
            NSInteger end = [baomingUrl rangeOfString:@"')"].location;
            baomingUrl = [baomingUrl substringWithRange:NSMakeRange(start, end - start)];
            baomingUrl = [NSString stringWithFormat:@"http://jwgl.nepu.edu.cn%@", baomingUrl];
            model.baomingUrl = baomingUrl;
            
            NSString *quxiaoUrl = cols.get(21).Query(@"a").get(0).attr(@"onclick");
            start = [quxiaoUrl rangeOfString:@"('"].location + 2;
            end = [quxiaoUrl rangeOfString:@"')"].location;
            quxiaoUrl = [quxiaoUrl substringWithRange:NSMakeRange(start, end - start)];
            quxiaoUrl = [NSString stringWithFormat:@"http://jwgl.nepu.edu.cn%@", quxiaoUrl];
            model.quxiaoUrl = quxiaoUrl;
            
            if (sfkbm) {
                if ([cols.get(0).text() isEqualToString:@"√"]) {
                    if ([cols.get(2).text() isEqualToString:@"√"]) {
                        model.status = @"审核时不可取消";
                    } else {
                        model.status = @"取消报名";
                    }
                } else {
                    model.status = @"报名";
                }
            } else {
                model.status = @"不可操作";
            }
            if ([cols.get(18).text() isEqualToString:@"√"]) {
                model.status = @"已缴费不可取消";
            }
            [chongxiuArray addObject:model];
        }
        if (success) {
            success(bmsj, [chongxiuArray copy]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil, nil);
    }];
}

// MARK::获取教学计划
- (void)getJiHuaList:(void(^)(NSArray *jihuaArray))success {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = @"http://jwgl.nepu.edu.cn/pyfajhgl.do?method=toViewJxjhXs";
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        OCQueryObject *rows = doc.Query(@"#mxh").first().Query(@"tr");
        NSUInteger duoyu = rows.get(0).Query(@"td").count - 11;
        NSMutableArray *jihuaArray = [NSMutableArray array];
        for (OCGumboNode *row in rows) {
            OCQueryObject *cols = row.Query(@"td");
            JiHua *jihua = [[JiHua alloc] init];
            jihua.courseName = cols.get(3).text();
            jihua.kaikexueqi = cols.get(1).text();
            jihua.kechengbianma = cols.get(2).text();
            jihua.zongxueshi = cols.get(4).text();
            jihua.xuefen = cols.get(5).text();
            jihua.kechengtixi = cols.get(6).text();
            jihua.kechengshuxing = cols.get(7).text();
            jihua.kaikedanwei = cols.get(10 + duoyu).text();
            jihua.kaohefangshi = cols.get(9 + duoyu).text();
            [jihua initLeftAndRightString];
            [jihuaArray addObject:jihua];
        }
        [jihuaArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            JiHua *j1 = obj1;
            JiHua *j2 = obj2;
            NSComparisonResult result = [j1.kaikexueqi compare:j2.kaikexueqi];
            if (result == NSOrderedSame) {
                result = -[j1.kaohefangshi compare:j2.kaohefangshi];
            }
            if (result == NSOrderedSame) {
                result = [j1.courseName compare:j2.courseName];
            }
            return result;
        }];
        success(jihuaArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil);
    }];
}

- (void)getBuKaoList:(void (^)(NSArray *, NSArray *, NSString *))success {
    [self getBuKaoList:success withKebaoOrYibao:YES];
    [self getBuKaoList:success withKebaoOrYibao:NO];
}

- (void)getBuKaoList:(void (^)(NSArray *, NSArray *, NSString *))success withKebaoOrYibao:(BOOL)kebaoOrYibao {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"http://jwgl.nepu.edu.cn/bkglAction.do?method=bkbmList&operate=%@", kebaoOrYibao ? @"kbkc" : @"ybkc"];
    [manager POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
        NSString *title = doc.Query(@"#tbTable").get(0).Query(@"td").get(0).text();
        BOOL sfkbm = [html containsString:@"var sfkbm = \"1\""];
        OCQueryObject *rows = doc.Query(@"#mxh").first().Query(@"tr");
        NSMutableArray *array = [NSMutableArray array];
        for (OCGumboNode *row in rows) {
            OCQueryObject *cols = row.Query(@"td");
            
            ChongXiuBuKao *model = [[ChongXiuBuKao alloc] init];
            NSMutableString *bukaoInfo = [[NSMutableString alloc] init];
            [bukaoInfo appendFormat:@"开课学期：%@\n", cols.get(0).text()];
            model.courseName = cols.get(1).text();
            [bukaoInfo appendFormat:@"课程编号：%@\n", cols.get(2).text()];
            [bukaoInfo appendFormat:@"考试性质：%@\n", cols.get(3).text()];
            [bukaoInfo appendFormat:@"课程属性：%@\n", cols.get(4).text()];
            [bukaoInfo appendFormat:@"课程性质：%@\n", cols.get(5).text()];
            [bukaoInfo appendFormat:@"学时：%@\n", cols.get(6).text()];
            [bukaoInfo appendFormat:@"学分：%@\n", cols.get(7).text()];
            [bukaoInfo appendFormat:@"总成绩：%@", cols.get(8).text()];
            if (!kebaoOrYibao) {
                [bukaoInfo appendFormat:@"\n是否缴费：%@", cols.get(9).text()];
            }
            model.info = bukaoInfo;
            
            NSString *bmid = cols.get(9 + (kebaoOrYibao ? 0 : 1)).Query(@"a").get(0).attr(@"onclick");
            NSInteger start = [bmid rangeOfString:@"('"].location + 2;
            NSInteger end = [bmid rangeOfString:@"')"].location;
            bmid = [bmid substringWithRange:NSMakeRange(start, end - start)];
            model.bmid = bmid;
            
            model.baomingUrl = url;
            model.quxiaoUrl = url;
            
            if (sfkbm) {
                if (kebaoOrYibao) {
                    model.status = @"报名";
                } else {
                    model.status = @"取消报名";
                }
            } else {
                model.status = @"不可操作";
            }
            if (!kebaoOrYibao && [cols.get(9).text() isEqualToString:@"是"]) {
                model.status = @"已缴费不可取消";
            }
            [array addObject:model];
        }
        if (kebaoOrYibao) {
            success(array, nil, title);
        } else {
            success(nil, array, title);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success(nil, nil, kebaoOrYibao ? @"可报课程" : @"已报课程");
    }];
}

//log.appendLog("&#tstart;--------------获取补考可报列表--------------&#tend;");
//try {
//    con = Jsoup.connect("http://jwgl.nepu.edu.cn/bkglAction.do?method=bkbmList&operate="
//                        + (kebaoOrYibao ? "kbkc" : "ybkc"))
//    .timeout(6000)
//    .cookie("JSESSIONID", JSESSIONID);
//    Document doc = con.post();
//    log.appendLog(doc.select("body").toString());
//    List<Map<String, String>> al = new ArrayList<>();
//    // 标题及报名时间
//    String title = doc.select("#tbTable td").get(0).text();
//    HashMap<String, String> time = new HashMap<>();
//    time.put(kebaoOrYibao ? "kbkc" : "ybkc", title);
//    al.add(time);
//    // 是否可报名
//    boolean sfkbm = doc.toString().contains("var sfkbm = \"1\"");
//    // 补考课程
//    Elements els = doc.select("#mxh tr");
//    for(Element e : els) {
//        HashMap<String, String> hashMap = new HashMap<>();
//        Elements infos = e.select("td");
//        hashMap.put("bk_kaikexueqi", "开课学期：" + infos.get(0).text());
//        hashMap.put("bk_kechengmingcheng", infos.get(1).text());
//        hashMap.put("bk_kechengbianhao", "课程编号：" + infos.get(2).text());
//        hashMap.put("bk_kaoshixingzhi", "考试性质：" + infos.get(3).text());
//        hashMap.put("bk_kechengshuxing", "课程属性：" + infos.get(4).text());
//        hashMap.put("bk_kechengxingzhi", "课程性质：" + infos.get(5).text());
//        hashMap.put("bk_xueshi", "学时：" + infos.get(6).text());
//        hashMap.put("bk_xuefen", "学分：" + infos.get(7).text());
//        hashMap.put("bk_zongchengji", "总成绩：" + infos.get(8).text());
//        if (!kebaoOrYibao)  hashMap.put("bk_shifoujiaofei", "是否缴费：" + infos.get(9).text());
//        else  hashMap.put("bk_shifoujiaofei", "");
//        String bmid = infos.get(9 + (kebaoOrYibao ? 0 : 1)).select("a").get(0).attr("onclick");
//        bmid = bmid.substring(bmid.indexOf("('") + 2, bmid.indexOf("')"));
//        hashMap.put("bmid", bmid);
//        if(sfkbm) {
//            if(kebaoOrYibao) {
//                hashMap.put("status", "报名");
//            } else {
//                hashMap.put("status", "取消报名");
//            }
//        } else {
//            hashMap.put("status", "不可操作");
//        }
//        if(!kebaoOrYibao &&  infos.get(9).text().equals("是")) {
//            hashMap.put("status", "已缴费不可取消");
//        }
//        al.add(hashMap);
//    }
//    return al;
//} catch (Exception e) {
//    e.printStackTrace();
//    log.appendLog("&#estart;===========================================");
//    log.appendLog(e);
//    return null;
//} finally {
//    log.appendLog("&#cend;");
//}

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
