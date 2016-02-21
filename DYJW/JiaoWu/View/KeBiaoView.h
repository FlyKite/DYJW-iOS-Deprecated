//
//  KeBiaoView.h
//  DYJW
//
//  Created by 风筝 on 16/2/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeBiaoView : UICollectionView
+ (instancetype)kebiaoViewWithFrame:(CGRect)frame;
@property (nonatomic, strong)NSArray *courses;
@end
