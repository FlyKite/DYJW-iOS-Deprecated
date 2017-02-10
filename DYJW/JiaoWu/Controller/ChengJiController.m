//
//  ChengJiController.m
//  DYJW
//
//  Created by 风筝 on 16/1/7.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "ChengJiController.h"
#import "MDDropdownList.h"
#import "MDColor.h"
#import "JiaoWu.h"
#import "MDAlertView.h"
#import "ChengJiCell.h"

@interface ChengJiController () <UITableViewDataSource, UITableViewDelegate, MDDropdownListDelegate>
@property (nonatomic, weak)MDDropdownList *dropdownList;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)UILabel *xuefenLabel;
@property (nonatomic, strong)NSArray *chengjiArray;
@end

@implementation ChengJiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"成绩查询";
    [self createView];
    [self getXueqi];
}

- (void)createView {
    self.view.backgroundColor = [MDColor grey50];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 80, 48)];
    label.text = @"开课学期";
    label.textColor = [MDColor grey800];
    [self.view addSubview:label];
    
    MDDropdownList *dropdown = [[MDDropdownList alloc] initWithFrame:CGRectMake(96, 0, ScreenWidth - 96 - 16, 48)];
    dropdown.data = @[@"---请选择---"];
    dropdown.delegate = self;
    dropdown.shownRows = 8;
    [self.view addSubview:dropdown];
    self.dropdownList = dropdown;
}

- (void)getXueqi {
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
    alertView.message = @"正在加载学期列表...";
    alertView.canCancelTouchOutside = NO;
    [alertView show];
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    [jiaowu getXueqiList:^(NSArray *xueqiArray, NSString *bjbh) {
        [alertView dismiss];
        if (xueqiArray) {
            self.dropdownList.data = xueqiArray;
        } else {
            self.dropdownList.data = @[@"加载失败..."];
        }
    } addAllXueqi:YES];
}

- (void)dropdownListDidSelectIndex:(NSInteger)index text:(NSString *)text {
    if (index == 0) {
        return;
    } else if (index == 1) {
        text = @"";
    }
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
    alertView.message = @"正在加载...";
    alertView.canCancelTouchOutside = NO;
    [alertView show];
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    [jiaowu getChengJiWithKKXQ:text success:^(NSArray *chengjiArray, NSString *xuefen, NSString *jidian) {
        [alertView dismiss];
        if (chengjiArray) {
            self.chengjiArray = chengjiArray;
            self.xuefenLabel.text = [NSString stringWithFormat:@"已修学分：%@，绩点：%@", xuefen, jidian];
            [self.tableView reloadData];
        } else {
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            alertView.message = @"加载失败，请稍后重试...";
            [alertView show];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chengjiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChengJiCell *cell = [ChengJiCell cellWithTableView:tableView];
    cell.model = self.chengjiArray[indexPath.row];
    cell.detailAction = ^(NSString *url, NSString *courseName) {
        MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
        alertView.message = @"正在加载...";
        alertView.canCancelTouchOutside = NO;
        [alertView show];
        JiaoWu *jiaowu = [JiaoWu jiaowu];
        [jiaowu getChengJiDetail:url success:^(NSString *detail) {
            [alertView dismiss];
            MDAlertView *detailAlert = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            detailAlert.title = courseName;
            detailAlert.message = detail;
            [detailAlert show];
        }];
    };
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, ScreenWidth, ScreenHeight - 76 - 48) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.rowHeight = 146;
        tableView.tableHeaderView = [self xuefenView];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)xuefenView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    [view addSubview:self.xuefenLabel];
    return view;
}

- (UILabel *)xuefenLabel {
    if (!_xuefenLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 20)];
        label.textColor = [MDColor grey800];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        _xuefenLabel = label;
    }
    return _xuefenLabel;
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
