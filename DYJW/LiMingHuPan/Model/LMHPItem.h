//
//  LMHPItem.h
//  DYJW
//
//  Created by 风筝 on 16/5/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMHPItem : NSObject
@property (assign, nonatomic) NSNumber *itemId;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *logo;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSString *images;
@property (copy, nonatomic) NSArray *imageUrls;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *typeName;
@property (copy, nonatomic) NSString *pubtime;
@property (strong, nonatomic) NSDate *pubDate;
@end
//"id" : 1000005, "nickname" : "121501140113", "logo" : "", "title" : "title测试测试", "price" : 9999.99, "images" : "14423607144085111001324118200.jpg", "description" : "description测试测试", "type_name" : "文具", "pubtime" : "2015/9/15 23:45:14"