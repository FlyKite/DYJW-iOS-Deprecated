//
//  KeBiaoView.m
//  DYJW
//
//  Created by 风筝 on 16/2/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "KeBiaoView.h"
#import "Course.h"
#import "MDAlertView.h"

#define MinHeight 100
#define MinWidth 100

@interface KeBiaoView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSArray *rowHeights;
@end

@interface KeBiaoLayout : UICollectionViewFlowLayout

@end

@interface KeBiaoCell : UICollectionViewCell
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)Course *course;
@property (nonatomic, weak)UILabel *textLabel;
@end

@implementation KeBiaoView
+ (instancetype)kebiaoViewWithFrame:(CGRect)frame {
    KeBiaoLayout *layout = [[KeBiaoLayout alloc] init];
    return [[self alloc] initWithFrame:frame collectionViewLayout:layout];
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self registerClass:[KeBiaoCell class] forCellWithReuseIdentifier:@"cell"];
        self.rowHeights = @[@100, @100, @100, @100, @100, @100];
    }
    return self;
}

- (void)setCourses:(NSArray *)courses {
    if (_courses != courses) {
        _courses = courses;
        [self reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 56;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KeBiaoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.text = @"";
    if ((indexPath.row + indexPath.row / 8) % 2 == 0) {
        cell.backgroundColor = [MDColor whiteColor];
    } else {
        cell.backgroundColor = [MDColor grey100];
    }
    NSString *text;
    switch (indexPath.row) {
        case 0: text = @""; break;
        case 1: text = @"周一"; break;
        case 2: text = @"周二"; break;
        case 3: text = @"周三"; break;
        case 4: text = @"周四"; break;
        case 5: text = @"周五"; break;
        case 6: text = @"周六"; break;
        case 7: text = @"周日"; break;
        case 8: text = @"第\n一\n大\n节"; break;
        case 16: text = @"第\n二\n大\n节"; break;
        case 24: text = @"第\n三\n大\n节"; break;
        case 32: text = @"第\n四\n大\n节"; break;
        case 40: text = @"第\n五\n大\n节"; break;
        case 48: text = @"第\n六\n大\n节"; break;
    }
    if (text) {
        cell.text = text;
    } else {
        NSInteger realRow = (indexPath.row / 8 - 1) * 7 + indexPath.row % 8 - 1;
        Course *course = self.courses[realRow];
        cell.course = course;
    }
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 8) {
        if (indexPath.row == 0) {
            NSInteger width = (ScreenWidth - 20) / 7;
            width = ScreenWidth - width * 7;
            return CGSizeMake(width, width);
        } else {
            NSInteger width = (ScreenWidth - 20) / 7;
            NSInteger height = ScreenWidth - width * 7;
            return CGSizeMake(width, height);
        }
    } else if (indexPath.row % 8 == 0) {
        NSInteger width = (ScreenWidth - 20) / 7;
        width = ScreenWidth - width * 7;
        CGFloat height = [self.rowHeights[indexPath.row / 8 - 1] floatValue];
        return CGSizeMake(width, height);
    } else {
        NSInteger width = (ScreenWidth - 20) / 7;
        CGFloat height = [self.rowHeights[indexPath.row / 8 - 1] floatValue];
        return CGSizeMake(width, height);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 8 && indexPath.row % 8 != 0) {
        MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
        NSInteger realRow = (indexPath.row / 8 - 1) * 7 + indexPath.row % 8 - 1;
        Course *course = self.courses[realRow];
        alertView.message = course.rawText;
        [alertView show];
    }
}
@end

@implementation KeBiaoLayout
-(id)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 确定了缩进，此处为上方、下方各缩进200
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // 每个item在水平方向的最小间距
        self.minimumLineSpacing = 0;
        self.minimumInteritemSpacing = 0;
    }
    return self;
}
@end

@implementation KeBiaoCell
- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
    self.textLabel.frame = self.bounds;
}

- (void)setCourse:(Course *)course {
    _course = course;
    if (course && course.courseName.length > 0) {
        NSMutableString *text = [[NSMutableString alloc] initWithString:course.courseName];
        while (course.nextCourse) {
            course = course.nextCourse;
            [text appendFormat:@"\n-----\n%@", course.courseName];
        }
        self.text = [text copy];
        self.textLabel.frame = self.bounds;
    }
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [MDColor grey600];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self addSubview:label];
        _textLabel = label;
    }
    return _textLabel;
}
@end