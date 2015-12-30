//
//  TabView.m
//  DYJW
//
//  Created by 风筝 on 15/11/5.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "TabView.h"
#import "MDColor.h"
#import "NSString+Height.h"

@interface TabView ()
@property (nonatomic, weak)UIView *underLine;
@end

@implementation TabView
- (void)willMoveToSuperview:(UIView *)newSuperview {
    CGRect frame = self.frame;
    frame.size.height = 36;
    frame.size.width = newSuperview.frame.size.width;
    self.frame = frame;
    self.backgroundColor = [MDColor lightBlue500];
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    if (self.data) {
        [self createView];
    }
}

- (void)setData:(NSArray *)data {
    _data = data;
    if (self.superview) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        [self createView];
    }
}

- (void)setPosition:(NSInteger)position {
    UILabel *lastLabel = [self viewWithTag:self.position];
    lastLabel.textColor = [MDColor lightBlue100];
    
    _position = position;
    
    UILabel *label = [self viewWithTag:self.position];
    label.textColor = [MDColor whiteColor];
    
    CGRect frame = self.underLine.frame;
    frame.size.width = label.frame.size.width;
    frame.origin.x = label.frame.origin.x;
    [UIView animateWithDuration:0.4 animations:^{
        self.underLine.frame = frame;
        CGPoint offset = CGPointMake(frame.origin.x - frame.size.width / 2, 0);
        offset.x = offset.x < self.contentSize.width - self.frame.size.width ? offset.x : self.contentSize.width - self.frame.size.width;
        offset.x = offset.x > 0 ? offset.x : 0;
        self.contentOffset = offset;
    }];
}

- (void)createView {
    CGFloat x = 0;
    CGFloat y = 0;
    _position = 1;
    for (int i = 0; i < self.data.count; i++) {
        NSString *title = self.data[i];
        CGFloat width = [title widthWithFont:[UIFont systemFontOfSize:14] withinHeight:MAXFLOAT] + 32;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, self.frame.size.height)];
        x += width;
        label.font = [UIFont systemFontOfSize:14];
        label.text = title;
        label.textColor = [MDColor lightBlue100];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = i + 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [label addGestureRecognizer:tap];
        label.userInteractionEnabled = YES;
        [self addSubview:label];
        if (i == 0) {
            label.textColor = [MDColor whiteColor];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 33, width, 3)];
            line.backgroundColor = [MDColor lightBlue100];
            [self addSubview:line];
            self.underLine = line;
        }
    }
    CGSize size = self.contentSize;
    size.width = x;
    self.contentSize = size;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    self.position = tap.view.tag;
    [self.tabDelegate tabClicked:self.position - 1];
}
@end
