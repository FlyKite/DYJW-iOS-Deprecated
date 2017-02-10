//
//  ShowImageCell.h
//  DYJW
//
//  Created by 风筝 on 16/5/17.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageCell : UICollectionViewCell
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) void(^dismissAction)(UIImageView *imageView);
- (void)showFromFrame:(CGRect)frame withImageSize:(CGSize)imageSize;
- (void)scaleToFit:(NSTimeInterval)duration;
@end
