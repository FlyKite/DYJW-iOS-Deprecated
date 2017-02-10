//
//  ToolbarSubViewController.m
//  DYJW
//
//  Created by 风筝 on 15/10/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "ToolbarSubViewController.h"

@interface ToolbarSubViewController ()

@end

@implementation ToolbarSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.view removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self.view removeObserver:self forKeyPath:@"frame"];
        [self setViewFrame];
        [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)setViewFrame {
    CGRect frame = CGRectMake(0, ToolbarHeight + StatusBarHeight, ScreenWidth, ScreenHeight - ToolbarHeight - StatusBarHeight);
    self.view.frame = frame;
}

- (void)viewDidLayoutSubviews {
    [self setViewFrame];
}

// 消除导航栏的返回按钮
- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
}

- (void)viewDidAppear:(BOOL)animated {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
}

- (void)setTitle:(NSString *)title {
    self.navigationController.title = title;
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
