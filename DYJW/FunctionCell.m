//
//  FunctionCell.m
//  DYJW
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "FunctionCell.h"
#import "MDColor.h"

@implementation FunctionCell
+ (id)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    UINib * nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (void)awakeFromNib {
    // Initialization code
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 46)];
    bg.backgroundColor = [MDColor lightBlue100];
    self.selectedBackgroundView = bg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
