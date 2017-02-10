//
//  ShowImageView.m
//  DYJW
//
//  Created by 风筝 on 16/5/17.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ShowImageView.h"
#import "ShowImageCell.h"

@interface ShowImageView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UILabel *pageLabel;
@property (assign, nonatomic) BOOL firstEnter;
@property (assign, nonatomic) CGRect showFromFrame;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) NSInteger showPage;
@end

@implementation ShowImageView
+ (instancetype)showImageView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = ScreenSize;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    CGRect frame = ScreenBounds;
    frame.size.width += 10;
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.firstEnter = YES;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.pagingEnabled = YES;
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        [self registerClass:[ShowImageCell class] forCellWithReuseIdentifier:@"cell"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [self addSubview:label];
        _pageLabel = label;
    }
    return self;
}

- (void)showFromRect:(CGRect)rect withIndex:(NSInteger)index {
    
}

- (void)setImageUrls:(NSArray *)imageUrls {
    _imageUrls = [imageUrls copy];
    [self reloadData];
}

- (void)showFromFrame:(CGRect)frame toPage:(NSInteger)page withImageSize:(CGSize)imageSize {
    [Window addSubview:self];
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    self.pageLabel.center = CGPointMake(ViewWidth(self) * (page + 0.5), ScreenHeight - 50);
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)page + 1, (long)self.imageUrls.count];
    self.pageLabel.alpha = 0;
    self.showFromFrame = frame;
    self.imageSize = imageSize;
    self.showPage = page;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [MDColor rgbColor:@"#101010"];
        self.pageLabel.alpha = 1;
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShowImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.firstEnter && indexPath.item == self.showPage) {
        self.firstEnter = NO;
        [cell showFromFrame:self.showFromFrame withImageSize:self.imageSize];
    }
    cell.dismissAction = ^(UIImageView *imageView) {
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        container.clipsToBounds = YES;
        UIImageView *imageInstead = [[UIImageView alloc] initWithFrame:CGRectMake(0, ViewY(imageView), ViewWidth(imageView), ViewHeight(imageView))];
        imageInstead.image = imageView.image;
        [container addSubview:imageInstead];
        [Window addSubview:container];
        [imageView removeFromSuperview];
        CGRect frame = self.showFromFrame;
        NSInteger smallImageWidth = frame.size.width;
        switch (smallImageWidth) {
            case 70: {
                frame.origin.x -= self.showPage % 3 * 77.5;
                frame.origin.y -= self.showPage / 3 * 75;
                frame.origin.x += indexPath.item % 3 * 77.5;
                frame.origin.y += indexPath.item / 3 * 75;
                break;
            }
            case 100: {
                frame.origin.x -= self.showPage * 105;
                frame.origin.x += indexPath.item * 105;
                break;
            }
            case 95: {
                frame.origin.x -= self.showPage % 2 * 100;
                frame.origin.y -= self.showPage / 2 * 100;
                frame.origin.x += indexPath.item % 2 * 100;
                frame.origin.y += indexPath.item / 2 * 100;
                break;
            }
        }
        [UIView animateWithDuration:0.3 animations:^{
            container.frame = frame;
            CGSize imageSize = imageInstead.image.size;
            BOOL widthLarger = imageSize.width > imageSize.height;
            if (widthLarger) {
                CGFloat width = imageSize.width * frame.size.height / imageSize.height;
                imageInstead.frame = CGRectMake((frame.size.width - width) / 2, 0, width, frame.size.height);
            } else {
                CGFloat height = imageSize.height * frame.size.width / imageSize.width;
                imageInstead.frame = CGRectMake(0, (frame.size.height - height) / 2, frame.size.width, height);
            }
        } completion:^(BOOL finished) {
            [imageInstead removeFromSuperview];
            [container removeFromSuperview];
        }];
        [self dismiss];
    };
    cell.imageUrl = self.imageUrls[indexPath.item];
    return cell;
}

- (void)dismiss {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.pageLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger page = (offsetX + ViewWidth(scrollView) / 2) / ViewWidth(scrollView) + 1;
    page = page < 1 ? 1 : (page > self.imageUrls.count ? self.imageUrls.count : page);
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)page, (long)self.imageUrls.count];
    self.pageLabel.center = CGPointMake(offsetX + ViewWidth(scrollView) / 2, ScreenHeight - 50);
}
@end
