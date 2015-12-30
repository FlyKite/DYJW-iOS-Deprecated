//
//  Course.m
//  DYJW
//
//  Created by 风筝 on 15/11/2.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "Course.h"

@implementation Course
+ (NSDictionary *)courses {
    return nil;
}

+ (NSString *)nowTerm {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSInteger year = [[formatter stringFromDate:date] integerValue];
    formatter.dateFormat = @"MM";
    NSInteger month = [[formatter stringFromDate:date] integerValue];
    formatter.dateFormat = @"dd";
    NSInteger day = [[formatter stringFromDate:date] integerValue];
    NSInteger term;
    if (month > 8 || (month == 8 && day >= 10)) {
        term = 1;
    } else {
        year -= 1;
        if (month == 1 || (month == 2 && day <= 10)) {
            term = 1;
        } else {
            term = 2;
        }
    }
    return [NSString stringWithFormat:@"%ld_%ld_%ld", year, year + 1, term];
}

@end
