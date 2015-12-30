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
#import "NewsList.h"
#import "NewsController.h"

#define Padding 16

@interface NewsListController () <TabViewDelegate, NewsListDelegate, UIScrollViewDelegate>
@property (nonatomic, weak)TabView *tab;
@property (nonatomic, strong)NSArray *pathArray;
@property (nonatomic, weak)UIScrollView *contentView;
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
    [self contentView];
    [self newsListWithPage:1];
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, self.view.frame.size.width, self.view.frame.size.height - 36 - 76)];
        scrollView.delegate = self;
        scrollView.bounces = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _contentView = scrollView;
    }
    return _contentView;
}

- (void)setPathArray:(NSArray *)pathArray {
    _pathArray = pathArray;
    self.contentView.contentSize = CGSizeMake(self.contentView.frame.size.width * pathArray.count, self.contentView.frame.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width + 1;
    [self newsListWithPage:page];
    self.tab.position = page;
}

- (NewsList *)newsListWithPage:(NSInteger)page {
    NewsList *newsList = [self.view viewWithTag:page + 1234];
    if (!newsList) {
        NewsList *newsList = [[NewsList alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width * (page - 1), 0, self.contentView.frame.size.width, self.contentView.frame.size.height) style:UITableViewStylePlain];
        newsList.tag = page + 1234;
        newsList.path = self.pathArray[page - 1];
        newsList.newsDelegate = self;
        [self.contentView addSubview:newsList];
    }
    return newsList;
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

- (void)tabClicked:(NSInteger)position {
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.contentOffset = CGPointMake(self.contentView.frame.size.width * (position), 0);
    }];
    [self newsListWithPage:position + 1];
}

- (void)newsClicked:(NSString *)url {
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
