//
//  DBHelper.m
//  DYJW
//
//  Created by 风筝 on 16/6/5.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "DBHelper.h"
#import <objc/runtime.h>
#import "UserInfo.h"

#define Username [UserInfo userInfo].username
#define DBFolder [NSString stringWithFormat:@"%@/Documents/db/", NSHomeDirectory()]
#define DBUserFolder [NSString stringWithFormat:@"%@/Documents/db/%@", NSHomeDirectory(), Username]
#define DBPath(db) [NSString stringWithFormat:@"%@/Documents/db/%@/%@", NSHomeDirectory(), Username, db]

@implementation DBHelper
+ (void)load {
    [super load];
    // 检测并创建db文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:DBFolder isDirectory:&isDir];
    if (!isDirExists) {
        NSError *error;
        BOOL createSuccess = [fileManager createDirectoryAtPath:DBFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (createSuccess) {
            NSLog(@"创建db文件夹成功");
        } else {
            NSLog(@"创建db文件夹失败：%@", error);
        }
    }
}

+ (BOOL)dbExists:(NSString *)dbPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:dbPath];
}

+ (FMDatabase *)openDatabase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    BOOL isDirExists = [fileManager fileExistsAtPath:DBUserFolder isDirectory:&isDir];
    if (!isDirExists) {
        NSError *error;
        BOOL createSuccess = [fileManager createDirectoryAtPath:DBUserFolder withIntermediateDirectories:YES attributes:nil error:&error];
        if (createSuccess) {
            NSLog(@"创建用户db文件夹成功");
        } else {
            NSLog(@"创建用户db文件夹失败：%@", error);
        }
    }
    
    NSString *dbName = [NSString stringWithFormat:@"%@.db", [self class]];
    NSString *dbPath = DBPath(dbName);
    BOOL dbExists = [self dbExists:dbPath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Can not open database : %@\nDatabase : %@", [db lastErrorMessage], dbName);
        return nil;
    }
    if (!dbExists) {
        if ([self initial:db]) {
            NSLog(@"初始化数据库成功 : %@", dbPath);
        } else {
            NSLog(@"初始化数据库失败 : %@\nDatabase : %@", [db lastErrorMessage], dbName);
        }
    }
    return db;
}

+ (BOOL)initial:(FMDatabase *)db {
    [db executeUpdate:@"create table if not exists tb_version (id integer primary key, version integer)"];
    [db executeUpdate:@"insert into tb_version values(1, 1)"];
    return YES;
}
@end
