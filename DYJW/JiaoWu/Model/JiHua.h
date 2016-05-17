//
//  JiHua.h
//  DYJW
//
//  Created by 风筝 on 16/4/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiHua : NSObject
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, copy)NSString *kaikexueqi;
@property (nonatomic, copy)NSString *kechengbianma;
@property (nonatomic, copy)NSString *zongxueshi;
@property (nonatomic, copy)NSString *xuefen;
@property (nonatomic, copy)NSString *kechengtixi;
@property (nonatomic, copy)NSString *kechengshuxing;
@property (nonatomic, copy)NSString *kaikedanwei;
@property (nonatomic, copy)NSString *kaohefangshi;
@property (nonatomic, copy, readonly)NSString *leftStr;
@property (nonatomic, copy, readonly)NSString *rightStr;
- (void)initLeftAndRightString;
@end
