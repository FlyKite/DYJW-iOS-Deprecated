//
//  WeekDayView.m
//  DYJW
//
//  Created by 风筝 on 15/10/29.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "WeekDayView.h"
#import "MDColor.h"

@implementation WeekDayView
- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = CGRectMake(0, 0, newSuperview.frame.size.width, 20);
    self.backgroundColor = [MDColor lightBlue500];
    for (int i = 0; i < 7; i++) {
        int x = self.frame.size.width / 7 * i;
        int y = 0;
        int width = self.frame.size.width / 7;
        int height = self.frame.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        switch (i) {
            case 0: label.text = @"周一"; break;
            case 1: label.text = @"周二"; break;
            case 2: label.text = @"周三"; break;
            case 3: label.text = @"周四"; break;
            case 4: label.text = @"周五"; break;
            case 5: label.text = @"周六"; break;
            case 6: label.text = @"周日"; break;
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
