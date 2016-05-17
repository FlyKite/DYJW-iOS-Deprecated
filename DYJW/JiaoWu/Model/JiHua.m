//
//  JiHua.m
//  DYJW
//
//  Created by 风筝 on 16/4/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "JiHua.h"

@implementation JiHua
- (void)initLeftAndRightString {
    NSMutableString *left = [[NSMutableString alloc] init];
    [left appendFormat:@"开课学期：%@\n", self.kaikexueqi];
    [left appendFormat:@"总学时：%@\n", self.zongxueshi];
    [left appendFormat:@"课程体系：%@\n", self.kechengtixi];
    [left appendFormat:@"开课单位：%@", self.kaikedanwei];
    _leftStr = [left copy];
    
    NSMutableString *right = [[NSMutableString alloc] init];
    [right appendFormat:@"课程编码：%@\n", self.kechengbianma];
    [right appendFormat:@"学分：%@\n", self.xuefen];
    [right appendFormat:@"课程属性：%@\n", self.kechengshuxing];
    [right appendFormat:@"考核方式：%@", self.kaohefangshi];
    _rightStr = [right copy];
}
@end
