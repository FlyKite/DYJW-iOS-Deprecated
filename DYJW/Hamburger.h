//
//  Hamburger.h
//  DYJW
//
//  Created by 风筝 on 15/10/19.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HamburgerState) {
    HamburgerStateNormal,
    HamburgerStateBack
};
typedef void(^onClickAction)(void);

@interface Hamburger : UIView
@property (nonatomic, assign)HamburgerState state;
@property (nonatomic, assign)CGFloat stateValue;    // The stateValue is between 0.00 and 1.00 for Hamburger rotation;
+ (id)hamburger;
- (void)toggle;
@property (nonatomic, strong)onClickAction onClickAction;
@end
