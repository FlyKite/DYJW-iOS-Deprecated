//
//  UIView+RippleView.h
//  DYJW
//
//  Created by 风筝 on 16/1/4.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MDRippleView)
- (void)createRippleView;
- (void)createRippleViewWithColor:(UIColor *)color;
- (void)createRippleViewWithColor:(UIColor *)color andAlpha:(CGFloat)alpha;
@end

@interface UIButton (MDRippleView)

@end
