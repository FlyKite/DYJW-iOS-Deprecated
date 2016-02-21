//
//  JiaoWu.h
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiaoWu : NSObject
+ (id)jiaowu;
- (BOOL)loginWithVerifycode:(NSString *)verifycode success:(void(^)(void))success failure:(void(^)(NSString *error))failure;
- (void)getXueqiList:(void(^)(NSArray *xueqiArray, NSString *bjbh))success addAllXueqi:(BOOL)allXueqi;
- (void)getChengJiWithKKXQ:(NSString *)kkxq success:(void(^)(NSArray *chengjiArray, NSString *xuefen, NSString *jidian))success;
- (void)getChengJiDetail:(NSString *)url success:(void(^)(NSString *detail))success;
- (void)getKeBiaoWithKKXQ:(NSString *)kkxq andBJBH:(NSString *)bjbh success:(void (^)(NSArray *))success;
@end
