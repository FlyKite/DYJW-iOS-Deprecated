//
//  MDAlertView.h
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MDAlertViewStyle) {
    MDAlertViewStyleLoading,
    MDAlertViewStyleProgress,
    MDAlertViewStyleDialog,
    MDAlertViewStyleCustom
};

@interface MDAlertView : UIView
@property (nonatomic, assign)MDAlertViewStyle style;
+ (instancetype)alertViewWithStyle:(MDAlertViewStyle)type;

@property (nonatomic, assign)CGSize alertSize;  // This property only effects when style is custom.
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, assign)BOOL canCancelTouchOutside;    // Default value is YES. The MDAlertView will not dismiss when you click the area outside the MDAlertView if value is NO.
@property (nonatomic, strong)UIView *customView;    // This will only effects when style is custom.
- (void)setPositiveButton:(NSString *)text andAction:(void(^)(void))positiveAction;
- (void)setNegativeButton:(NSString *)text andAction:(void(^)(void))negativeAction;
- (void)show;
- (void)dismiss;
@end
