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
            OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
            NSString *error = doc.Query(@"span#errorinfo").text();
            NSLog(@"该账号不存在或密码错误：%@", error);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:error];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 网络连接失败
        NSLog(@"%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN" object:@"NET_ERROR"];
    }];
    return true;
}

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
//    public ArrayList<String> getXueqiList(boolean allXueqi) {
//        log.appendLog("&#tstart;--------------获取学期列表及bjbh--------------&#tend;");
//        try {
//            con = Jsoup.connect("http://jwgl.nepu.edu.cn/tkglAction.do?method=kbxxXs")
//            .timeout(6000).cookie("JSESSIONID", JSESSIONID);
//            Document doc = con.get();
//            log.appendLog(doc.select("body").toString());
//            bjbh = doc.getElementsByAttributeValue("name", "bjbh").val();
//            Element elm = doc.getElementById("xnxqh");
//            ArrayList<String> ar = new ArrayList<>();
//            for(Element el: elm.select("option")) {
//                ar.add(el.html());
//                if(el.html().equals("---请选择---") && allXueqi) {
//                    ar.add("全部学期");
//                }
//            }
//            return ar;
//        } catch (Exception e) {
//            e.printStackTrace();
//            log.appendLog("&#estart;===========================================");
//            log.appendLog(e);
//            return null;
//        } finally {
//            log.appendLog("&#cend;");
//        }
//    }
}

- (UserInfo *)user {
    if (!_user) {
        _user = [UserInfo userInfo];
    }
    return _user;
}
@end
