//
//  LMHPItem.m
//  DYJW
//
//  Created by 风筝 on 16/5/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "LMHPItem.h"

@implementation LMHPItem
- (void)setImages:(NSString *)images {
    _images = [images copy];
    NSArray *array = [images componentsSeparatedByString:@","];
    NSMutableArray *mArray = [NSMutableArray array];
    for (NSString *image in array) {
        if (image.length > 0) {
            [mArray addObject:image];
        }
    }
    self.imageUrls = [mArray copy];
}

- (void)setPubtime:(NSString *)pubtime {
    _pubtime = [pubtime copy];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    self.pubDate = [formatter dateFromString:pubtime];
}
@end
