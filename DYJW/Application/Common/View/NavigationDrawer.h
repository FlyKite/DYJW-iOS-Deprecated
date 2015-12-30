//
//  NavigationDrawer.h
//  DYJW
//
//  Created by 风筝 on 15/10/19.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DrawerState) {
    DrawerStateNormal,
    DrawerStateBack
};

@protocol ChangeFunctionDelegate <NSObject>
- (void)changeFunction:(NSInteger)index;
@end

@interface NavigationDrawer : UIView
+ (id)drawer;
@property (nonatomic, assign)DrawerState state;
@property (nonatomic, assign)CGFloat stateValue; // 0.0 for hide, 1.0 for show;
@property (nonatomic, weak)UIImageView *userIconView;
@property (nonatomic, weak)UILabel *usernameLabel;
@property (nonatomic, weak)UIButton *loginButton;
@property (nonatomic, weak)UIView *headView;
@property (nonatomic, weak)UITableView *functionList;
@property (nonatomic, assign)id<ChangeFunctionDelegate> delegate;
@end
