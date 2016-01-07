//
//  MDProgressBar.m
//  DYJW
//
//  Created by 风筝 on 16/1/7.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "MDProgressView.h"

@implementation MDProgressView
+ (id)progressViewWithStyle:(MDProgressViewStyle)style {
    return [[self alloc] initWithViewStyle:style];
}

- (id)initWithViewStyle:(MDProgressViewStyle)style {
    CGRect frame;
    switch (style) {
        case MDProgressViewStyleLoadingLarge: frame = CGRectMake(0, 0, 72, 72); break;
        case MDProgressViewStyleLoadingMidium: frame = CGRectMake(0, 0, 48, 48); break;
        case MDProgressViewStyleLoadingSmall: frame = CGRectMake(0, 0, 36, 36); break;
        case MDProgressViewStyleBar: frame = CGRectMake(0, 0, 4, 100); break;
    }
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
