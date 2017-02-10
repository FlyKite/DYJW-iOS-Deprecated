//
//  NewsListCell.h
//  DYJW
//
//  Created by 风筝 on 16/5/29.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsListCell : UICollectionViewCell
@property (copy, nonatomic) NSArray *dataArray;
@property (copy, nonatomic) void(^newsClickAction)(NSString *);
@end
