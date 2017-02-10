//
//  JiHuaController.m
//  DYJW
//
//  Created by 风筝 on 16/4/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "JiHuaController.h"
#import "MDAlertView.h"
#import "JiaoWu.h"
#import "JiHuaCell.h"

@interface JiHuaController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSArray *jihuaArray;
@end

@implementation JiHuaController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"教学计划";
    self.view.backgroundColor = [MDColor grey50];
    [self getJiHua];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getJiHua {
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
    alertView.message = @"正在加载...";
    alertView.canCancelTouchOutside = NO;
    [alertView show];
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    [jiaowu getJiHuaList:^(NSArray *jihuaArray) {
        [alertView dismiss];
        if (jihuaArray) {
            self.jihuaArray = jihuaArray;
            [self.tableView reloadData];
        } else {
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            alertView.message = @"加载失败，请稍后重试...";
            [alertView show];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.jihuaArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JiHuaCell *cell = [JiHuaCell cellWithTableView:tableView];
    cell.model = self.jihuaArray[indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 76) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = 146;
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
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
