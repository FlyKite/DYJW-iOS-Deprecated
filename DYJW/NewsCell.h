//
//  NewsCell.h
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tabLabel;
@property (nonatomic, strong)NSDictionary *data;
@end
