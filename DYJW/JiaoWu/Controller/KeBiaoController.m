//
//  KeBiaoController.m
//  DYJW
//
//  Created by 风筝 on 16/2/16.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "KeBiaoController.h"
#import "MDDropdownList.h"
#import "MDAlertView.h"
#import "JiaoWu.h"
#import "KeBiaoView.h"

@interface KeBiaoController () <MDDropdownListDelegate>
@property (nonatomic, weak)MDDropdownList *dropdownList;
@property (nonatomic, weak)KeBiaoView *kebiaoView;
@property (nonatomic, strong)NSArray *kebiaoArray;
@property (nonatomic, strong)NSString *bjbh;
@end

@implementation KeBiaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    KeBiaoView *view = [KeBiaoView kebiaoViewWithFrame:CGRectMake(0, 48, ScreenWidth, ScreenHeight - 76 - 48)];
    [self.view addSubview:view];
    self.kebiaoView = view;
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
            self.bjbh = bjbh;
        } else {
            self.dropdownList.data = @[@"加载失败..."];
        }
    } addAllXueqi:NO];
}

- (void)dropdownListDidSelectIndex:(NSInteger)index text:(NSString *)text {
    if (index == 0) {
        return;
    }
    MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleLoading];
    alertView.message = @"正在加载...";
    alertView.canCancelTouchOutside = NO;
    [alertView show];
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    [jiaowu getKeBiaoWithKKXQ:text andBJBH:self.bjbh success:^(NSArray *kebiaoArray) {
        [alertView dismiss];
        if (kebiaoArray) {
            self.kebiaoArray = kebiaoArray;
            self.kebiaoView.courses = kebiaoArray;
        } else {
            MDAlertView *alertView = [MDAlertView alertViewWithStyle:MDAlertViewStyleDialog];
            alertView.message = @"加载失败，请稍后重试...";
            [alertView show];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
