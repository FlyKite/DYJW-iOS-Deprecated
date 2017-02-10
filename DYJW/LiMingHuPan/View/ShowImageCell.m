//
//  ShowImageCell.m
//  DYJW
//
//  Created by 风筝 on 16/5/17.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ShowImageCell.h"
#import "UIImageView+AFNetworking.h"
#import "MDAlertView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ShowImageCell () <UIScrollViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) BOOL firstEnter;
@property (assign, nonatomic) CGRect oldFrame;
@property (assign, nonatomic) CGPoint startLocation;
@property (assign, nonatomic) NSInteger imageState;
@end

@implementation ShowImageCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
        doubleTap.numberOfTapsRequired = 2;
        [tap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:doubleTap];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        longPress.allowableMovement = 20.0;
        longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)showFromFrame:(CGRect)frame withImageSize:(CGSize)imageSize {
    self.firstEnter = YES;
    
    UIView *container = [[UIView alloc] initWithFrame:frame];
    container.clipsToBounds = YES;
    [self addSubview:container];
    [self.imageView removeFromSuperview];
    [container addSubview:self.imageView];
    
    BOOL widthLarger = imageSize.width > imageSize.height;
    if (widthLarger) {
        CGFloat width = imageSize.width * frame.size.height / imageSize.height;
        self.imageView.frame = CGRectMake((frame.size.width - width) / 2, 0, width, frame.size.height);
    } else {
        CGFloat height = imageSize.height * frame.size.width / imageSize.width;
        self.imageView.frame = CGRectMake(0, (frame.size.height - height) / 2, frame.size.width, height);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        container.frame = self.bounds;
        self.imageView.frame = CGRectMake(0, 0, ViewWidth(self), ViewWidth(self));
        self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        [self.scrollView addSubview:self.imageView];
        [container removeFromSuperview];
        self.scrollView.delegate = self;
    }];
}

- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = [imageUrl copy];
    self.imageState = 0;
    self.imageView.image = [UIImage imageNamed:@"userhead_normal"];
    self.imageView.frame = CGRectMake(0, 0, ViewWidth(self), ViewWidth(self));
    self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    self.scrollView.contentSize = self.bounds.size;
//    self.imageView setImageWithURLRequest:<#(nonnull NSURLRequest *)#> placeholderImage:<#(nullable UIImage *)#> success:<#^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image)success#> failure:<#^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error)failure#>
//    [manager downloadImageWithURL:[NSURL URLWithString:_imageUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if ([imageURL.absoluteString isEqualToString:_imageUrl]) {
//            self.imageView.image = image;
//            self.scrollView.maximumZoomScale = image.size.width / 2 / ViewWidth(self);
//            self.scrollView.minimumZoomScale = 1;
//            [UIView animateWithDuration:self.firstEnter ? 0.3 : 0 animations:^{
//                CGSize windowSize = Window.bounds.size;
//                CGFloat windowScale = windowSize.width / windowSize.height;
//                CGFloat width = image.size.width / image.size.height > windowScale ? windowSize.width : image.size.width * windowSize.height / image.size.height;
//                CGFloat height = image.size.width / image.size.height < windowScale ? windowSize.height : image.size.height * windowSize.width / image.size.width;
//                self.imageView.bounds = CGRectMake(0, 0, width, height);
//                self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
//            } completion:^(BOOL finished) {
//                self.firstEnter = NO;
//            }];
//        }
//    }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
        [self.scrollView addSubview:_imageView];
    }
    return _imageView;
}

#pragma mark - 点击消失
- (void)click {
    if (self.dismissAction) {
        if (self.imageState != 0) {
            [self scaleToFit:0.1];
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(performDismissAction) userInfo:nil repeats:NO];
        } else {
            [self performDismissAction];
        }
    }
}

- (void)performDismissAction {
    self.alpha = 0;
    self.dismissAction(self.imageView);
}

#pragma mark - 长按保存图片
static NSTimeInterval startTime = 0;
- (void)saveImage:(UILongPressGestureRecognizer *)longPress {
    if (startTime == 0) {
        startTime = [[NSDate date] timeIntervalSince1970];
    }
    if (longPress.state == UIGestureRecognizerStateChanged) {
        if ([[NSDate date] timeIntervalSince1970] - startTime > 0.5) {
            startTime += 3600;
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片到手机", nil];
            [sheet showInView:Window];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            alertView.message = @"请在“设置-萌萌记”中开启萌萌记访问相册的权限~不然就没办法保存图片到相册了呢~";
            [alertView setPositiveButton:@"好的" andAction:nil];
            [alertView show];
        } else {
            UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(saveImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    startTime = 0;
}

- (void)saveImage:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
    if (!error) {
        alertView.message = @"保存成功";
    } else {
        alertView.message = @"保存失败";
        NSLog(@"保存失败%@", error);
    }
    [alertView show];
}

#pragma mark - 双击放大缩小
- (void)doubleClick:(UITapGestureRecognizer *)tap {
    NSLog(@"double click");
    switch (self.imageState) {
        case 0: {// 目前为适应屏幕
            CGPoint point = [tap locationInView:self.imageView];
            [self scaleToDouble:point];
            break;
        }
        case 1: {// 目前为原图大小
            [self scaleToFit:0.3];
            break;
        }
        case 2: {// 目前为2倍原图大小
            CGPoint point = [tap locationInView:self.imageView];
            [self scaleToOriginal:point];
            break;
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize originalSize = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetX = originalSize.width > contentSize.width ? (originalSize.width - contentSize.width) / 2 : 0;
    CGFloat offsetY = originalSize.height > contentSize.height ? (originalSize.height - contentSize.height) / 2 : 0;
    self.imageView.center = CGPointMake(contentSize.width / 2 + offsetX, contentSize.height / 2 + offsetY);
}

- (void)scaleToFit:(NSTimeInterval)duration {
    self.imageState = 0;
    self.scrollView.maximumZoomScale = self.imageView.image.size.width / 2 / ViewWidth(self);
    self.scrollView.minimumZoomScale = 1;
    [UIView animateWithDuration:duration animations:^{
        CGSize windowSize = Window.bounds.size;
        CGFloat windowScale = windowSize.width / windowSize.height;
        CGSize imageSize = self.imageView.image.size;
        CGFloat width = imageSize.width / imageSize.height > windowScale ? windowSize.width : imageSize.width * windowSize.height / imageSize.height;
        CGFloat height = imageSize.width / imageSize.height < windowScale ? windowSize.height : imageSize.height * windowSize.width / imageSize.width;
        self.imageView.frame = CGRectMake(0, 0, width, height);
        self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
        self.scrollView.contentSize = self.frame.size;
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)scaleToOriginal:(CGPoint)showPoint {
    self.imageState = 1;
    CGSize imageSize = self.imageView.image.size;
    self.scrollView.maximumZoomScale = imageSize.width / 4 > ScreenWidth ? 1 : ScreenWidth * 2 / imageSize.width;
    self.scrollView.minimumZoomScale = imageSize.width / 2 > ScreenWidth ? ScreenWidth * 2 / imageSize.width : 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = CGRectMake(0, 0, imageSize.width / 2, imageSize.height / 2);
        self.imageView.center = CGPointMake(ViewWidth(self.imageView) / 2, ViewHeight(self.imageView) / 2);
        self.scrollView.contentSize = self.imageView.frame.size;
    }];
}

- (void)scaleToDouble:(CGPoint)showPoint {
    self.imageState = 2;
    self.scrollView.maximumZoomScale = 1;
    self.scrollView.minimumZoomScale = 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        self.imageView.frame = CGRectMake(0, 0, ViewWidth(self.imageView) * 2, ViewHeight(self.imageView) * 2);
        self.imageView.center = CGPointMake(ViewWidth(self.imageView) / 2, ViewHeight(self.imageView) / 2);
        self.scrollView.contentSize = self.imageView.frame.size;
        CGFloat x = showPoint.x > ViewWidth(self.imageView) -  ScreenWidth ? ViewWidth(self.imageView) -  ScreenWidth : showPoint.x;
        CGFloat y = showPoint.y > ViewHeight(self.imageView) -  ScreenHeight ? ViewHeight(self.imageView) -  ScreenHeight : showPoint.y;
        self.scrollView.contentOffset = CGPointMake(x, y);
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2.0;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}
@end
