//
//  News.h
//  DYJW
//
//  Created by 风筝 on 15/11/3.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject
+ (void)newsWithPath:(NSString *)path andPage:(NSInteger)page;
+ (void)newsWithURL:(NSString *)url;
@property (nonatomic, copy)NSString *cdata;
@property (nonatomic)NSMutableString *currentText;
@property (nonatomic, copy)NSString *currentElementName;
@property (nonatomic)NSMutableArray *parserObjects;
@property (nonatomic)NSMutableDictionary *twitterDic;
@end
