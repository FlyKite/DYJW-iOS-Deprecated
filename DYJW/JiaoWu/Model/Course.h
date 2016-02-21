//
//  Course.h
//  DYJW
//
//  Created by 风筝 on 16/2/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject
+ (NSDictionary *)courses;
+ (NSString *)nowTerm;
@property (nonatomic, copy)NSString *rawText;
@property (nonatomic, copy)NSString *courseName;
@property (nonatomic, copy)NSString *className;
@property (nonatomic, copy)NSString *teacherName;
@property (nonatomic, copy)NSString *weeks;
@property (nonatomic, copy)NSString *classroom;
@property (nonatomic, strong)Course *nextCourse;
@end
