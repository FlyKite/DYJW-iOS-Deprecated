//
//  DBHelper.h
//  DYJW
//
//  Created by 风筝 on 16/6/5.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBHelper : NSObject
+ (FMDatabase *)openDatabase;
+ (BOOL)createTableWithModel:(NSObject *)model andIdentifer:(NSString *)identifer;
+ (BOOL)initial:(FMDatabase *)db;
@end
