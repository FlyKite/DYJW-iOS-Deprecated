//
//  NewsListCell.m
//  DYJW
//
//  Created by 风筝 on 16/5/29.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "NewsListCell.h"
#import "NewsCell.h"
#import "NSString+Height.h"

@interface NewsListCell () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation NewsListCell
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = [dataArray copy];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSString *title = dict[@"title"];
    CGFloat height = [title heightWithFont:[UIFont systemFontOfSize:17] withinWidth:self.frame.size.width - 16] + 93 - 20.5;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = NSStringFromClass([NewsCell class]);
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    cell.data = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (self.newsClickAction) {
        NSString *url = [NSString stringWithFormat:@"http://123.57.151.235/DYJW/app/getNews?newsUrl=%@", dict[@"url"]];
        self.newsClickAction(url);
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        NSString *className = NSStringFromClass([NewsCell class]);
        [_tableView registerNib:[UINib nibWithNibName:className bundle:nil] forCellReuseIdentifier:className];
        [self addSubview:_tableView];
    }
    return _tableView;
}
@end
