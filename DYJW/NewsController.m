//
//  NewsController.m
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "NewsController.h"
#import "News.h"

@interface NewsController ()
@property (nonatomic, weak)UIWebView *webView;
@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [News newsWithURL:self.url];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:[NSString stringWithFormat:@"NEWS_CONTENT"] object:nil];
}

- (void)refreshData:(NSNotification *)notification {
    [self.webView loadHTMLString:notification.object baseURL:[NSURL URLWithString:self.url]];
}

- (UIWebView *)webView {
    if (!_webView) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 76, self.view.bounds.size.width, self.view.bounds.size.height - 76)];
        [self.view addSubview:webView];
        _webView = webView;
    }
    return _webView;
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
