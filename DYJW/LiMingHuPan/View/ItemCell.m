//
//  ItemCell.m
//  DYJW
//
//  Created by 风筝 on 16/5/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ItemCell.h"
#import "UIView+MDRippleView.h"
#import "MDColor.h"
#import "UIImageView+AFNetworking.h"

#define ImageHeight 100

@interface ItemCell () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UIView *cardView;
@property (strong, nonatomic) UIImageView *logo;
@property (strong, nonatomic) UILabel *nickname;
@property (strong, nonatomic) UILabel *pubtime;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UICollectionView *images;
@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *desc;
@end

@interface ImageCell : UICollectionViewCell
@property (copy, nonatomic) NSString *imageName;
@end

@implementation ItemCell
+ (CGFloat)cellHeight:(LMHPItem *)item {
    CGFloat titleHeight = [ItemCell heightForString:item.title width:ScreenWidth - 64 fontSize:16];
    CGFloat descHeight = [ItemCell heightForString:item.title width:ScreenWidth - 64 fontSize:15];
    CGFloat imageHeight = item.images.length > 0 ? ImageHeight + 8 : 0;
    return 64 + 8 + titleHeight + 8 + imageHeight + descHeight + 24;
}

+ (CGFloat)heightForString:(NSString *)str width:(CGFloat)width fontSize:(CGFloat)size {
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                        context:nil];
    return ceil(textRect.size.height);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(16, 8, ScreenWidth - 32, 130)];
    view.layer.cornerRadius = 2;
    view.layer.shadowColor = [MDColor grey500].CGColor;
    view.layer.shadowOpacity = 0.75;
    view.layer.shadowRadius = 2;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.backgroundColor = [UIColor whiteColor];
    [view createRippleView];
    [self addSubview:view];
    self.cardView = view;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 48, 48)];
    logo.layer.cornerRadius = 24;
    logo.clipsToBounds = YES;
    [view addSubview:logo];
    self.logo = logo;
    
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(ViewWidth(view) - 16 - 80, ViewY(logo), 80, ViewHeight(logo))];
    price.textAlignment = NSTextAlignmentRight;
    price.textColor = [MDColor pink500];
    price.font = [UIFont systemFontOfSize:20];
    [view addSubview:price];
    self.price = price;
    
    UILabel *nickname = [[UILabel alloc] initWithFrame:CGRectMake(ViewX(logo) + ViewWidth(logo) + 8, ViewY(logo), ViewX(price) - ViewX(logo) - ViewWidth(logo) - 16, ViewHeight(logo) / 2)];
    nickname.font = [UIFont systemFontOfSize:16];
    nickname.textColor = [MDColor grey900];
    [view addSubview:nickname];
    self.nickname = nickname;
    
    UILabel *pubtime = [[UILabel alloc] initWithFrame:CGRectMake(ViewX(nickname), ViewY(nickname) + ViewHeight(nickname), ViewWidth(nickname), ViewHeight(nickname))];
    pubtime.font = [UIFont systemFontOfSize:16];
    pubtime.textColor = [MDColor grey700];
    [view addSubview:pubtime];
    self.pubtime = pubtime;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(ViewX(logo) + ViewWidth(logo) + 8, ViewY(logo) + ViewHeight(logo) / 2, ViewY(price) - ViewX(logo) - ViewWidth(logo) - 16, ViewHeight(logo) / 2)];
    title.font = [UIFont systemFontOfSize:16];
    title.textColor = [MDColor grey800];
    [view addSubview:title];
    self.title = title;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ImageHeight, ImageHeight);
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth(view), ImageHeight) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
    [view addSubview:collectionView];
    self.images = collectionView;
    
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(ViewX(logo) + ViewWidth(logo) + 8, ViewY(logo) + ViewHeight(logo) / 2, ViewY(price) - ViewX(logo) - ViewWidth(logo) - 16, ViewHeight(logo) / 2)];
    desc.font = [UIFont systemFontOfSize:16];
    desc.textColor = [MDColor grey600];
    [view addSubview:desc];
    self.desc = desc;
    
}

- (void)setModel:(LMHPItem *)model {
    _model = model;
    self.logo.image = model.logo.length > 0 ? [UIImage imageNamed:@"default_user"] : [UIImage imageNamed:@"default_user"];
    self.nickname.text = model.nickname;
    self.pubtime.text = model.pubtime;
    self.price.text = [NSString stringWithFormat:@"%.2lf", [model.price doubleValue]];
    self.title.text = model.title;
    self.desc.text = model.desc;
    [self setViewFrames];
    [self.images reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.imageUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageName = self.model.imageUrls[indexPath.item];
    return cell;
}

- (void)setViewFrames {
    self.cardView.frame = CGRectMake(16, 8, ScreenWidth - 32, [ItemCell cellHeight:self.model] - 16);
    self.title.frame = CGRectMake(16, ViewY(self.logo) + ViewHeight(self.logo) + 8, ScreenWidth - 32, [ItemCell heightForString:self.model.title width:ScreenWidth - 32 fontSize:16]);
    self.images.frame = CGRectMake(0, ViewY(self.title) + ViewHeight(self.title) + 8, ViewWidth(self.cardView), self.model.images.length > 0 ? 100 : 0);
    self.desc.frame = CGRectMake(16, ViewY(self.title) + ViewHeight(self.title) + (self.model.images.length > 0 ? ImageHeight + 16 : 8), ScreenWidth - 32, [ItemCell heightForString:self.model.desc width:ScreenWidth - 32 fontSize:16]);
}
@end

@interface ImageCell ()
@property (strong, nonatomic) UIImageView *image;
@end

@implementation ImageCell
- (void)setImageName:(NSString *)imageName {
    _imageName = [imageName copy];
    NSString *thumb = [NSString stringWithFormat:@"app/lmhp/thumbs?imageName=%@", imageName];
    [self.image setImageWithURL:[NSURL URLWithString:CombineUrl(thumb)] placeholderImage:[UIImage imageNamed:@"holder_image"]];
//    self.image 
}

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageHeight, ImageHeight)];
        [self addSubview:_image];
    }
    return _image;
}
@end
