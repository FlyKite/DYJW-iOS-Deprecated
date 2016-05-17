//
//  ChongXiuController.m
//  DYJW
//
//  Created by 风筝 on 16/3/9.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ChongXiuController.h"
#import "MDDropdownList.h"
#import "JiaoWu.h"
#import "MDAlertView.h"
#import "ChongXiuCell.h"
#import "AFNetworking.h"

@interface ChongXiuController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)NSArray *chongxiuArray;
@end

@implementation ChongXiuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [MDColor grey50];
    [self getChongXiu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getChongXiu {
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
    alertView.message = @"正在加载...";
    alertView.canCancelTouchOutside = NO;
    [alertView show];
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    [jiaowu getChongXiuList:^(NSString *bmsj, NSArray *chongxiuArray) {
        [alertView dismiss];
        if (chongxiuArray) {
            self.chongxiuArray = chongxiuArray;
            self.timeLabel.text = bmsj;
            [self.tableView reloadData];
        } else {
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            alertView.message = @"加载失败，请稍后重试...";
            [alertView show];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chongxiuArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChongXiuCell *cell = [ChongXiuCell cellWithTableView:tableView];
    cell.model = self.chongxiuArray[indexPath.row];
    cell.detailAction = ^(ChongXiuBuKao *model) {
        MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
        alertView.message = model.info;
        alertView.canCancelTouchOutside = NO;
        if([model.status isEqualToString:@"报名"] || [model.status isEqualToString:@"取消报名"]) {
            [alertView setPositiveButton:model.status andAction:^{
                NSString *url = [model.status isEqualToString:@"报名"] ? model.baomingUrl : model.quxiaoUrl;
                MDAlertView *progress = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
                progress.message = @"请稍候...";
                [progress show];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                [manager POST:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    [progress dismiss];
                    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
                    alertView.message = @"操作成功";
                    [alertView show];
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [progress dismiss];
                    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
                    alertView.message = @"操作失败";
                    [alertView show];
                }];
            }];
        } else {
            [alertView setPositiveButton:model.status andAction:nil];
        }
        [alertView setNegativeButton:@"返回" andAction:nil];
        [alertView show];
    };
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 76) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = 98;
        tableView.tableHeaderView = [self timeView];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)timeView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
    [view addSubview:self.timeLabel];
    return view;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, ScreenWidth - 32, 36)];
        label.textColor = [MDColor grey800];
        label.font = [UIFont systemFontOfSize:15];
        label.numberOfLines = 0;
        _timeLabel = label;
    }
    return _timeLabel;
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
