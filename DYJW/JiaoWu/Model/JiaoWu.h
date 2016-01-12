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
- (BOOL)loginWithVerifycode:(NSString *)verifycode;
- (void)getXueqiList:(void(^)(NSArray *xueqiArray, NSString *bjbh))success addAllXueqi:(BOOL)allXueqi;
@end
