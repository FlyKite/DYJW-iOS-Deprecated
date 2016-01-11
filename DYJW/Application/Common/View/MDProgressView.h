//
//  MDProgressBar.h
//  DYJW
//
//  Created by 风筝 on 16/1/7.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MDProgressViewStyle) {
    MDProgressViewStyleLoadingLarge,
    MDProgressViewStyleLoadingMedium,
    MDProgressViewStyleLoadingSmall,
    MDProgressViewStyleBar
};

@interface MDProgressView : UIView
+ (id)progressViewWithStyle:(MDProgressViewStyle)style;
@property (nonatomic, assign, readonly)MDProgressViewStyle style;
@property (nonatomic, strong)UIColor *color;
@property (nonatomic, assign)BOOL showBackMask; // Set background mask of LoadingProgressView.
@property (nonatomic, assign)BOOL showBackMaskShadow; // Set background mask shadow of LoadingProgressView.
@end
