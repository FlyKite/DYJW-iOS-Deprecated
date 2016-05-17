//
//  JiHuaCell.m
//  DYJW
//
//  Created by 风筝 on 16/4/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "JiHuaCell.h"
#import "UIView+MDRippleView.h"
#import "NSString+Height.h"

@interface JiHuaCell ()
@property (nonatomic, weak)UIView *cardView;
@property (nonatomic, weak)UILabel *title;
@property (nonatomic, weak)UILabel *left;
@property (nonatomic, weak)UILabel *right;
@end

@implementation JiHuaCell
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

- (void)setModel:(JiHua *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    self.title.text = model.courseName;
    self.left.text = model.leftStr;
    self.right.text = model.rightStr;
    [self setViewFrames];
}

- (void)setViewFrames {
    CGFloat leftWidth = [self.model.leftStr widthWithFont:[UIFont systemFontOfSize:15] withinHeight:ViewHeight(self.left)];
    CGFloat rightWidth = [self.model.rightStr widthWithFont:[UIFont systemFontOfSize:15] withinHeight:ViewHeight(self.left)];
    if (leftWidth + rightWidth + 16 < ViewWidth(self.left)) {
        CGRect frame = self.right.frame;
        frame.origin.x = ViewX(self.left) + leftWidth + (ViewWidth(self.left) - leftWidth - rightWidth) / 2;
        self.right.frame = frame;
    } else {
        CGRect frame = self.right.frame;
        frame.origin.x = ViewX(self.left) + leftWidth + 8;
        self.right.frame = frame;
    }
}

#pragma mark - Getters
- (UIView *)cardView {
    if (!_cardView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 8, ScreenWidth - 32, 130)];
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [MDColor grey500].CGColor;
        view.layer.shadowOpacity = 0.75;
        view.layer.shadowRadius = 2;
        view.layer.shadowOffset = CGSizeMake(0, 2);
        view.backgroundColor = [UIColor whiteColor];
        [view createRippleView];
        [self addSubview:view];
        _cardView = view;
    }
    return _cardView;
}

- (UILabel *)title {
    if (!_title) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, ViewWidth(self.cardView) - 32, 18)];
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textColor = [MDColor grey900];
        [self.cardView addSubview:title];
        _title = title;
    }
    return _title;
}

- (UILabel *)left {
    if (!_left) {
        UILabel *left = [[UILabel alloc] initWithFrame:CGRectMake(16, 42, ViewWidth(self.cardView) - 32, 72)];
        left.font = [UIFont systemFontOfSize:15];
        left.textColor = [MDColor grey800];
        left.numberOfLines = 0;
        [self.cardView addSubview:left];
        _left = left;
    }
    return _left;
}

- (UILabel *)right {
    if (!_right) {
        UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(16, 42, ViewWidth(self.cardView) - 32, 72)];
        right.font = [UIFont systemFontOfSize:15];
        right.textColor = [MDColor grey800];
        right.numberOfLines = 0;
        [self.cardView addSubview:right];
        _right = right;
    }
    return _right;
}
@end
