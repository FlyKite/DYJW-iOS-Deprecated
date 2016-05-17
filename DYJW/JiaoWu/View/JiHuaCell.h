//
//  JiHuaCell.h
//  DYJW
//
//  Created by 风筝 on 16/4/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JiHua.h"

@interface JiHuaCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)JiHua *model;
@end
