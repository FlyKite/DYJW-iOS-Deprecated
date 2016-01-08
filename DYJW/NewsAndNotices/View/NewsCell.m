//
//  NewsCell.m
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "NewsCell.h"
#import "UIView+MDRippleView.h"

@implementation NewsCell
+ (id)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    [cell createRippleView];
    return cell;
}
- (void)setData:(NSDictionary *)data {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tabLabel.text = data[@"lmmc"];
    self.titleLabel.text = data[@"title"];
    self.timeLabel.text = data[@"pubDate"];
}
@end
