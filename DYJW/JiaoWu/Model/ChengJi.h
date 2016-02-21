//
//  ChengJi.h
//  DYJW
//
//  Created by 风筝 on 16/2/12.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChengJi : NSObject
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, copy)NSString *flag;
@property (nonatomic, readonly)UIColor *flagColor;
@property (nonatomic, copy)NSString *zongchengji;
@property (nonatomic, copy)NSString *chengjibiaozhi;
@property (nonatomic, copy)NSString *kechengxingzhi;
@property (nonatomic, copy)NSString *kechengleibie;
@property (nonatomic, copy)NSString *xueshi;
@property (nonatomic, copy)NSString *xuefen;
@property (nonatomic, copy)NSString *kaoshixingzhi;
@property (nonatomic, copy)NSString *buchongxueqi;
@property (nonatomic, copy)NSString *detailURL;
@property (nonatomic, copy, readonly)NSString *leftStr;
@property (nonatomic, copy, readonly)NSString *rightStr;
- (void)initLeftAndRightString;
@end
