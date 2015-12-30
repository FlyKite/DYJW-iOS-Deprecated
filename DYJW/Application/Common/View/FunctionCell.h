//
//  FunctionCell.h
//  DYJW
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *functionImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (id)cellWithTableView:(UITableView *)tableView;
@end
