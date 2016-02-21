//
//  Course.m
//  DYJW
//
//  Created by 风筝 on 16/2/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "Course.h"

@implementation Course
- (void)setRawText:(NSString *)rawText {
    _rawText = rawText;
    NSArray *rows = [rawText componentsSeparatedByString:@"\n"];
    if (rows.count % 5 == 0) {
        self.courseName = rows[0];
        self.className = rows[1];
        self.teacherName = rows[2];
        self.weeks = rows[3];
        self.classroom = rows[4];
        if (rows.count > 5) {
            NSMutableString *string = [[NSMutableString alloc] init];
            for (int i = 5; i < rows.count; i++) {
                [string appendFormat:@"%@\n", rows[i]];
            }
            if (string.length > 0) {
                [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
            }
            Course *course = [[Course alloc] init];
            course.rawText = [string copy];
            self.nextCourse = course;
        }
    } else if(rows.count % 3 == 0) {
        self.courseName = rows[0];
        self.teacherName = rows[1];
        self.weeks = rows[2];
        if (rows.count > 3) {
            NSMutableString *string = [[NSMutableString alloc] init];
            for (int i = 3; i < rows.count; i++) {
                [string appendString:rows[i]];
            }
            Course *course = [[Course alloc] init];
            course.rawText = [string copy];
            self.nextCourse = course;
        }
    }
}

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
