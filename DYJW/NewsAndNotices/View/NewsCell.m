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
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createRippleView];
    }
    return self;
}

- (void)setData:(NSDictionary *)data {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tabLabel.text = data[@"topic"];
    self.titleLabel.text = data[@"title"];
    self.timeLabel.text = data[@"date"];
}
@end
