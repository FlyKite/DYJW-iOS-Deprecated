//
//  NewsList.m
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "NewsList.h"
#import "NewsCell.h"
#import "NSString+Height.h"
#import "News.h"

@interface NewsList () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation NewsList
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)setPath:(NSString *)path {
    _path = path;
    [News newsWithPath:_path andPage:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:[NSString stringWithFormat:@"NEWS_%@", _path] object:nil];
}

- (void)refreshData:(NSNotification *)notification {
    self.data = notification.object;
}

- (void)setData:(NSArray *)data {
    _data = data;
    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.data[indexPath.row];
    NSString *title = dict[@"title"];
    CGFloat height = [title heightWithFont:[UIFont systemFontOfSize:17] withinWidth:self.frame.size.width - 16] + 93 - 20.5;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [NewsCell cellWithTableView:self];
    cell.data = self.data[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.data[indexPath.row];
    [self.newsDelegate newsClicked:dict[@"link"]];
}
@end
