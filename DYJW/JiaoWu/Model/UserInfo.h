//
//  UserInfo.h
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
+ (id)userInfo;
+ (void)saveUsername:(NSString *)username andPassword:(NSString *)password andLoginTime:(NSTimeInterval)logintime;
+ (void)updateLoginTime:(NSTimeInterval)loginTime;
+ (void)saveCookieWithUrl:(NSString *)url;
+ (void)saveName:(NSString *)name;
+ (NSHTTPCookie *)cookie;
+ (void)clearUserInfo;
+ (void)clearCookies;
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *password;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)NSTimeInterval logintime;
@end
