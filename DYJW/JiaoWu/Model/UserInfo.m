//
//  UserInfo.m
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *user;
@implementation UserInfo
+ (instancetype)userInfo {
    if (!user) {
        user = [[self alloc] init];
    }
    return user;
}

+ (void)saveUsername:(NSString *)username andPassword:(NSString *)password andLoginTime:(double)logintime {
    NSDictionary *userInfo = @{
                               @"USERNAME" : username,
                               @"PASSWORD" : password,
                               @"LOGINTIME" : @(logintime)
                               };
    NSString *loginUserPath = [NSString stringWithFormat:@"%@/Documents/loginUser.plist", NSHomeDirectory()];
    [userInfo writeToFile:loginUserPath atomically:YES];
    if (user) {
        user.username = username;
        user.password = password;
        user.logintime = logintime;
    }
}

+ (void)updateLoginTime:(double)loginTime {
    NSString *loginUserPath = [NSString stringWithFormat:@"%@/Documents/loginUser.plist", NSHomeDirectory()];
    NSMutableDictionary *loginUser = [[NSMutableDictionary alloc] initWithContentsOfFile:loginUserPath];
    [loginUser setValue:@(loginTime) forKey:@"LOGINTIME"];
    [loginUser writeToFile:loginUserPath atomically:YES];
    if (user) {
        user.logintime = loginTime;
    }
}

+ (void)saveCookieWithUrl:(NSString *)url {
    NSString *cookiePath = [NSString stringWithFormat:@"%@/Documents/cookie.plist", NSHomeDirectory()];
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.name isEqualToString:@"JSESSIONID"]) {
            NSDictionary *cookieDict = @{@"JSESSIONID" : cookie.value};
            [cookieDict writeToFile:cookiePath atomically:YES];
        }
    }
}

+ (void)saveName:(NSString *)name {
    NSString *loginUserPath = [NSString stringWithFormat:@"%@/Documents/loginUser.plist", NSHomeDirectory()];
    NSMutableDictionary *loginUser = [[NSMutableDictionary alloc] initWithContentsOfFile:loginUserPath];
    [loginUser setValue:name forKey:@"NAME"];
    [loginUser writeToFile:loginUserPath atomically:YES];
    if (user) {
        user.name = name;
    }
}

+ (NSHTTPCookie *)cookie {
    NSString *cookiePath = [NSString stringWithFormat:@"%@/Documents/cookie.plist", NSHomeDirectory()];
    NSDictionary *cookieDict = [NSDictionary dictionaryWithContentsOfFile:cookiePath];
    if (!cookieDict) {
        return nil;
    }
    NSDictionary *cookieProperties = @{NSHTTPCookieName : @"JSESSIONID", NSHTTPCookieValue : cookieDict[@"JSESSIONID"], NSHTTPCookieDomain : @"jwgl.nepu.edu.cn", NSHTTPCookiePath : @"/"};
    return [NSHTTPCookie cookieWithProperties:cookieProperties];
}

+ (void)clearUserInfo {
    NSString *loginUserPath = [NSString stringWithFormat:@"%@/Documents/loginUser.plist", NSHomeDirectory()];
    [[NSFileManager defaultManager] removeItemAtPath:loginUserPath error:nil];
    user = nil;
}
+ (void)clearCookies {
    NSString *cookiePath = [NSString stringWithFormat:@"%@/Documents/cookie.plist", NSHomeDirectory()];
    [[NSFileManager defaultManager] removeItemAtPath:cookiePath error:nil];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] removeCookiesSinceDate:[NSDate dateWithTimeIntervalSince1970:0]];
}

- (id)init {
    if (self = [super init]) {
        NSString *loginUserPath = [NSString stringWithFormat:@"%@/Documents/loginUser.plist", NSHomeDirectory()];
        NSDictionary *loginUser = [[NSDictionary alloc] initWithContentsOfFile:loginUserPath];
        self.username = loginUser[@"USERNAME"];
        self.password = loginUser[@"PASSWORD"];
        self.name = loginUser[@"NAME"];
        self.logintime = ((NSNumber *) loginUser[@"LOGINTIME"]).doubleValue;
    }
    return self;
}
@end
