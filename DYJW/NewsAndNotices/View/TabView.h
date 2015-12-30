//
//  TabView.h
//  DYJW
//
//  Created by 风筝 on 15/11/5.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabViewDelegate <NSObject>
- (void)tabClicked:(NSInteger)position;
@end

@interface TabView : UIScrollView
@property (nonatomic, strong)NSArray *data;
@property (nonatomic, weak)id<TabViewDelegate> tabDelegate;
@property (nonatomic, assign)NSInteger position;
@end
