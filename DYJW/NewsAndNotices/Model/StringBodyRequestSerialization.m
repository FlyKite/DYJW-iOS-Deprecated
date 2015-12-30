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
        mutableRequest.HTTPBody = [parameters dataUsingEncoding:NSUTF8StringEncoding];
    }
    return mutableRequest;
}
@end

