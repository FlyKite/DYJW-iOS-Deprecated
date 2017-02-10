//
//  NewsListController.m
//  DYJW
//
//  Created by 风筝 on 15/11/3.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "NewsListController.h"
#import "News.h"
#import "TabView.h"
#import "NewsController.h"
#import "NewsListCell.h"
#import "AFNetworking.h"

#define Padding 16

@interface NewsListController () <TabViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak)TabView *tab;
@property (nonatomic, strong)NSArray *pathArray;
@property (strong, nonatomic) NSMutableDictionary *newsListDict;
@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation NewsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.newsListType == NewsListDongYouNews) {
        self.tab.data = @[@"通知公告", @"东油要闻", @"教学科研", @"党建思政", @"菁菁校园", @"院部动态", @"交流合作", @"媒体聚焦", @"典型宣传", @"专题热点", @"高教视点", @"理论学习", @"创意东油"];
        self.pathArray = @[@"520203.html", @"520202.html", @"520205.html", @"520204.html", @"520208.html", @"520209.html", @"520215.html", @"520210.html", @"520206.html", @"520211.html", @"520218.html", @"520219.html", @"520222.html"];
    } else {
        self.tab.data = @[@"通知公告", @"新闻动态", @"机构设置", @"办事指南", @"规章制度", @"教学建设", @"资料下载", @"信息发布", @"高教视窗"];
        self.pathArray = @[@"350312.html", @"350309.html", @"350302.html", @"350304.html", @"350303.html", @"350316.html", @"350305.html", @"350307.html", @"350317.html"];
    }
    self.newsListDict = [NSMutableDictionary dictionary];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self collectionView];
}

- (TabView *)tab {
    if (!_tab) {
        TabView  *tabView = [[TabView alloc] init];
        tabView.tabDelegate = self;
        [self.view addSubview:tabView];
        _tab = tabView;
    }
    return _tab;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - 36 - 76);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 36, ScreenWidth, ScreenHeight - 36 - 76) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[NewsListCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:collectionView];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pathArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableArray *list = self.newsListDict[[NSString stringWithFormat:@"%ld", (long)indexPath.item]];
    cell.dataArray = list;
    cell.newsClickAction = ^(NSString *url) {
        [self performSelector:@selector(viewNews:) withObject:url afterDelay:0.3];
    };
    [self loadNewsList:indexPath.item];
    return cell;
}

- (void)loadNewsList:(NSInteger)index {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *param = @{
                            @"newsPath" : self.pathArray[index],
                            @"page" : @1
                            };
    [manager GET:@"http://123.57.151.235/DYJW/app/getNewsList" parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull json) {
        if ([json[@"result"] integerValue] == 0) {
            NSString *listKey = [NSString stringWithFormat:@"%ld", (long)index];
            NSMutableArray *list = self.newsListDict[listKey];
            if (!list) {
                list = [NSMutableArray array];
            }
            [list addObjectsFromArray:json[@"data"]];
            self.newsListDict[listKey] = list;
            NewsListCell *cell = (NewsListCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            cell.dataArray = list;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)tabClicked:(NSInteger)position {
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionView.contentOffset = CGPointMake(self.collectionView.frame.size.width * (position), 0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width + 1;
    page = page > 0 ? page : 1;
    page = page <= self.tab.data.count ? page : self.tab.data.count;
    self.tab.position = page;
}

- (void)viewNews:(NSString *)url {
    NewsController *controller = [[NewsController alloc] init];
    controller.url = url;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
