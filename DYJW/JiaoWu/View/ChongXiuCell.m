//
//  ChongXiuCell.m
//  DYJW
//
//  Created by 风筝 on 16/3/9.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ChongXiuCell.h"
#import "UIView+MDRippleView.h"

@interface ChongXiuCell ()
@property (nonatomic, weak)UIView *cardView;
@property (nonatomic, weak)UILabel *title;
@end

@implementation ChongXiuCell
+ (id)cellWithTableView:(UITableView *)tableView {
    NSString * className = NSStringFromClass([self class]);
    [tableView registerClass:[self class] forCellReuseIdentifier:className];
    return [tableView dequeueReusableCellWithIdentifier:className];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self cardView];
    }
    return self;
}

- (void)setModel:(ChongXiuBuKao *)model {
    _model = model;
    self.title.text = model.courseName;
}

- (void)cardClick {
    if (self.detailAction) {
        self.detailAction(self.model);
    }
}

#pragma mark - Getters
- (UIView *)cardView {
    if (!_cardView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 8, ScreenWidth - 32, 82)];
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [MDColor grey500].CGColor;
        view.layer.shadowOpacity = 0.75;
        view.layer.shadowRadius = 2;
        view.layer.shadowOffset = CGSizeMake(0, 2);
        view.backgroundColor = [UIColor whiteColor];
        [view createRippleView];
        view.rippleFinishAction = ^() {
            [self cardClick];
        };
        [self addSubview:view];
        _cardView = view;
        
        CALayer *line = [[CALayer alloc] init];
        line.frame = CGRectMake(0, 50, ViewWidth(view), 1);
        line.backgroundColor = [MDColor grey500].CGColor;
        [view.layer addSublayer:line];
    }
    return _cardView;
}

- (UILabel *)title {
    if (!_title) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, ViewWidth(self.cardView) - 32, 18)];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textColor = [MDColor grey700];
        [self.cardView addSubview:title];
        _title = title;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 59, ViewWidth(title), 15)];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.textColor = [MDColor grey600];
        label.text = @"点击查看详情";
        label.textAlignment = NSTextAlignmentCenter;
        [self.cardView addSubview:label];
    }
    return _title;
}
@end
