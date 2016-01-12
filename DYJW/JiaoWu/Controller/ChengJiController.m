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

@interface ChengJiController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)MDDropdownList *dropdownList;
@property (nonatomic, weak)UITableView *tableView;
@end

@implementation ChengJiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    dropdown.data = @[@"2011-2012-1", @"2011-2012-2", @"2012-2013-1", @"2012-2013-2", @"2013-2014-1", @"2013-2014-2"];
    [self.view addSubview:dropdown];
    self.dropdownList = dropdown;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 48, ScreenWidth, ScreenHeight - 76) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (void)getXueqi {
    JiaoWu *jiaowu = [JiaoWu jiaowu];
    [jiaowu getXueqiList:^(NSArray *xueqiArray, NSString *bjbh) {
        self.dropdownList.data = xueqiArray;
    } addAllXueqi:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
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
