//
//  CourseDatabase.m
//  DYJW
//
//  Created by 风筝 on 16/6/5.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "CourseDatabase.h"

@implementation CourseDatabase
+ (BOOL)initial:(FMDatabase *)db {
    [super initial:db];
    [db executeUpdate:@"create table if not exists tb_refreshTime (id integer primary key, refreshTime integer)"];
    [db executeUpdate:@"insert into tb_refreshTime values(?,?)", @(1), @(0)];
    [db executeUpdate:@"create table if not exists tb_vaccine (babyVaccineId integer, vaccineName text, vaccineDesc text, status int, vaccineAge int, defendIll text, vaccineCare text, injectTime double, vaccineId integer, type int)"];
    [db executeUpdate:@"create table if not exists tb_vaccine_alert (babyVaccineId integer primary key, vaccineName text, injectTime double, alertDay int, alertTime int)"];
    return YES;
}

@end
