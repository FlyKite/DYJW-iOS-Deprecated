//
//  SystemPanel.h
//  DYJW
//
//  Created by 风筝 on 15/11/3.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SystemPanelDelegate <NSObject>
- (void)systemPanelButtonClick:(NSInteger)position;
@end

@interface SystemPanel : UIView
@property (nonatomic, assign)id<SystemPanelDelegate> delegate;
- (void)show;
- (void)hide;
@end
