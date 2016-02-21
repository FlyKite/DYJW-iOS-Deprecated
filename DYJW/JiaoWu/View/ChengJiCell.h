//
//  ChengJiCell.h
//  DYJW
//
//  Created by 风筝 on 16/2/12.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChengJi.h"

@interface ChengJiCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)ChengJi *model;
@property (nonatomic, copy)void(^detailAction)(NSString *url, NSString *courseName);
@end
