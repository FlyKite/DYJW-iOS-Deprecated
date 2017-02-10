//
//  ShowImageView.h
//  DYJW
//
//  Created by 风筝 on 16/5/17.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowImageViewDelegate <NSObject>
@required
- (CGRect)hideImageViewToIndex:(NSInteger)index;
@end

@interface ShowImageView : UICollectionView
+ (instancetype)showImageView;
@property (copy, nonatomic) NSArray *imageUrls;
@property (weak, nonatomic) id<ShowImageViewDelegate> frameDelegate;
- (void)showFromRect:(CGRect)rect withIndex:(NSInteger)index;
@end
