//
//  ChongXiuCell.h
//  DYJW
//
//  Created by 风筝 on 16/3/9.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChongXiuBuKao.h"

@interface ChongXiuCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)ChongXiuBuKao *model;
@property (nonatomic, copy)void(^detailAction)(ChongXiuBuKao *model);
@end
