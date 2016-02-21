//
//  ChengJi.m
//  DYJW
//
//  Created by 风筝 on 16/2/12.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ChengJi.h"

@implementation ChengJi
- (void)setFlag:(NSString *)flag {
    _flag = flag;
    if ([flag isEqualToString:@"√"]) {
        _flagColor = [MDColor green500];
    } else if ([@"优良合及" containsString:flag]) {
        _flagColor = [MDColor green500];
    } else {
        _flagColor = [MDColor red500];
    }
}

- (NSString *)detailURL {
    return [NSString stringWithFormat:@"http://jwgl.nepu.edu.cn%@", _detailURL];
}

- (void)initLeftAndRightString {
    NSMutableString *left = [[NSMutableString alloc] init];
    [left appendFormat:@"总成绩：%@\n", self.zongchengji];
    [left appendFormat:@"课程性质：%@\n", self.kechengxingzhi];
    [left appendFormat:@"学时：%@\n", self.xueshi];
    [left appendFormat:@"考试性质：%@", self.kaoshixingzhi];
    _leftStr = [left copy];
    
    NSMutableString *right = [[NSMutableString alloc] init];
    [right appendFormat:@"成绩标志：%@\n", self.chengjibiaozhi];
    [right appendFormat:@"课程类别：%@\n", self.kechengleibie];
    [right appendFormat:@"学分：%@\n", self.xuefen];
    [right appendFormat:@"补重学期：%@", self.buchongxueqi ? self.buchongxueqi : @""];
    _rightStr = [right copy];
}
@end
