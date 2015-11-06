//
//  CourseView.m
//  DYJW
//
//  Created by 风筝 on 15/11/2.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "CourseView.h"
#import "MDColor.h"

@interface CourseView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation CourseView
+ (id)courseView {
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.backgroundColor = [MDColor grey500];
        self.delegate = self;
        self.dataSource = self;
        self.bounces = NO;
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [MDColor whiteColor];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.frame.size.width - 6) / 7;
    CGFloat height = (self.frame.size.height - 20) / 4.3;
    return CGSizeMake(width, height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
