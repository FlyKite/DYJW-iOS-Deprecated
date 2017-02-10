//
//  StringBodyRequestSerialization.m
//  DYJW
//
//  Created by 风筝 on 15/11/4.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "StringBodyRequestSerialization.h"

@implementation StringBodyRequestSerialization
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                                     error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *mutableRequest = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    if ([parameters isKindOfClass:NSString.class]) {
        // 将请求体替换为目标字符串
        mutableRequest.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    }
    return mutableRequest;
}
@end

