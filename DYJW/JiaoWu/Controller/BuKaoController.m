//
//  BuKaoController.m
//  DYJW
//
//  Created by 风筝 on 16/4/21.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "BuKaoController.h"
#import "MDAlertView.h"
#import "JiaoWu.h"
#import "ChongXiuCell.h"

@interface BuKaoController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)UITableView *kbkcTableView;
@property (nonatomic, weak)UITableView *ybkcTableView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)NSArray *kbkcArray;
@property (nonatomic, strong)NSArray *ybkcArray;
@end

@implementation BuKaoController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getBuKao];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getBuKao {
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
    alertView.message = @"正在加载...";
    alertView.canCancelTouchOutside = NO;
    [alertView show];
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    __block NSInteger loadingCount = 2;
    [jiaowu getBuKaoList:^(NSArray *kbkcArray, NSArray *ybkcArray, NSString *title) {
        if (--loadingCount == 0) {
            [alertView dismiss];
        }
        if (kbkcArray) {
            self.kbkcArray = kbkcArray;
            [self.kbkcTableView reloadData];
        } else if (ybkcArray) {
            self.ybkcArray = ybkcArray;
            [self.ybkcTableView reloadData];
        } else {
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            alertView.message = [NSString stringWithFormat:@"加载%@失败，请稍后重试...", title];
            [alertView show];
        }
    }];
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
