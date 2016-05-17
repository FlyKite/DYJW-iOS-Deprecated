//
//  AddImageCell.m
//  DYJW
//
//  Created by 风筝 on 16/5/17.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "AddImageCell.h"

@interface AddImageCell ()
@property (nonatomic, weak)UIImageView *imageView;
@end

@implementation AddImageCell
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image ? image : [UIImage imageNamed:@"icon_addimage"];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}
@end
