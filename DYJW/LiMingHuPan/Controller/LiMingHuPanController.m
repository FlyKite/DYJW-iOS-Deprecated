//
//  LiMingHuPanController.m
//  DYJW
//
//  Created by 风筝 on 15/12/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "LiMingHuPanController.h"
#import "ItemCell.h"
#import "AFNetworking.h"
#import "MDFloatCircleButton.h"
#import "LMHPPubItemController.h"
#import "UserInfo.h"

@interface LiMingHuPanController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) MDFloatCircleButton *pubButton;
@end

@implementation LiMingHuPanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray array];
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
    self.pubButton.hidden = ![UserInfo cookie];
}

- (void)createView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[ItemCell class] forCellReuseIdentifier:@"cell"];
    self.page = 1;
    
    MDFloatCircleButton *button = [MDFloatCircleButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(ScreenWidth - 16 - 48, ScreenHeight - 76 - 32 - 48, 0, 0);
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.pubButton = button;
}

- (void)postButtonClick {
    LMHPPubItemController *controller = [[LMHPPubItemController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)loadData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *param = @{
                            @"page" : @(self.page)
                            };
    [manager GET:CombineUrl(@"app/lmhp/item") parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull json) {
        if ([json[@"result"] integerValue] == 0) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in json[@"data"]) {
                LMHPItem *item = [[LMHPItem alloc] init];
                item.logo = dict[@"userLogo"];
                item.nickname = dict[@"nickname"];
                item.pubtime = dict[@"pubTime"];
                item.itemId = dict[@"id"];
                item.price = dict[@"price"];
                item.title = dict[@"title"];
                item.desc = dict[@"content"];
                item.images = dict[@"images"];
                [self.dataArray addObject:item];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error%@", error);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ItemCell cellHeight:self.dataArray[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 76) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
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
