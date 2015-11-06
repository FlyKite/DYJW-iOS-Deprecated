//
//  ToolbarController.m
//  DYJW
//
//  Created by 风筝 on 15/10/19.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "ToolbarController.h"
#import "NavigationDrawer.h"
#import "Hamburger.h"
#import "MDColor.h"
#import "MainCourseController.h"
#import "JiaoWuController.h"
#import "NewsListController.h"

#define StatusBarHeight 20
#define ToolbarHeight 56
#define Padding 8
#define Size [UIScreen mainScreen].bounds.size

@interface ToolbarController () <ChangeFunctionDelegate> {
    CGRect drawerPanStartFrame;
}
@property (nonatomic, weak)UIView *contentViewContainer;
@property (nonatomic, strong)UIViewController *viewController;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)NavigationDrawer *drawer;
@property (nonatomic, weak)Hamburger *hamburger;
@property (nonatomic)NSMutableDictionary *controllersDict;
@end

@implementation ToolbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self initContainer];
    [self initDrawerAndHamburger];
    [self initGesture];
}

- (void)setNavigationBar {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *toolbarBg = [[UIView alloc] initWithFrame:CGRectMake(0, -StatusBarHeight, Size.width, StatusBarHeight + ToolbarHeight)];
    toolbarBg.backgroundColor = [MDColor lightBlue500];
    [self.navigationBar addSubview:toolbarBg];
    
    UIView *statusBar = [[UIView alloc] initWithFrame:CGRectMake(0, -StatusBarHeight, Size.width, StatusBarHeight)];
    statusBar.backgroundColor = [MDColor lightBlue600];
    [self.navigationBar addSubview:statusBar];
    
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

// 设置子controller容器
- (void)initContainer {
    CGRect frame = self.view.bounds;
    frame.size.height -= StatusBarHeight + ToolbarHeight;
    frame.origin.y = StatusBarHeight + ToolbarHeight;
    UIView *contentViewContainer = [[UIView alloc] initWithFrame:frame];
    [self.view addSubview:contentViewContainer];
    self.contentViewContainer = contentViewContainer;
    
    [self setRootViewControllerWithIndex:0];
}

// 设置抽屉及hamburger
- (void)initDrawerAndHamburger {
    self.hamburger.state = HamburgerStateNormal;
    
    self.drawer.stateValue = 0;
    self.drawer.delegate = self;
    [self.view bringSubviewToFront:self.navigationBar];
}

// 添加抽屉滑入滑出以及hamburger的点击手势
- (void)initGesture {
    UIPanGestureRecognizer *containerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealDrawerPan:)];
    [self.contentViewContainer addGestureRecognizer:containerPan];
    
    UIPanGestureRecognizer *drawerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealDrawerPan:)];
    [self.drawer addGestureRecognizer:drawerPan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealHamburgerTap)];
    [self.hamburger addGestureRecognizer:tap];
}

// 处理抽屉的滑动手势
- (void)dealDrawerPan:(UIPanGestureRecognizer *)pan {
    if (pan.view == self.contentViewContainer && pan.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [pan locationInView:pan.view];
        if (point.x < 30) {
            CGRect frame = self.drawer.frame;
            frame.origin.x = 0;
            self.drawer.frame = frame;
            CGPoint point = [pan locationInView:pan.view];
            self.drawer.stateValue = point.x / (self.drawer.frame.size.width * 2 / 3);
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat stateValue = 0;
        CGPoint point = [pan locationInView:pan.view];
        if (point.x > self.drawer.frame.size.width * 2 / 3) {
            return;
        }
        if (pan.view == self.contentViewContainer && self.drawer.frame.origin.x == 0) {
            stateValue = point.x / (self.drawer.frame.size.width * 2 / 3);
        }
        if (pan.view == self.drawer) {
            stateValue = point.x / (self.drawer.frame.size.width * 2 / 3);
        }
        self.drawer.stateValue = stateValue;
        self.hamburger.stateValue = self.hamburger.state == HamburgerStateNormal ? (stateValue > 1 ? 1 : stateValue) : 1 - stateValue;
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        CGPoint v = [pan velocityInView:pan.view];
        if (v.x > 600 || v.x < -600) {
            self.drawer.stateValue = v.x > 0 && self.drawer.frame.origin.x == 0 ? 1 : 0;
            if (v.x > 0 && self.drawer.frame.origin.x == 0) {
                self.hamburger.stateValue = self.hamburger.state == HamburgerStateNormal ? 1 : 0;
            } else if (v.x < 0) {
                self.hamburger.stateValue = self.hamburger.state == HamburgerStateBack ? 1 : 0;
            }
        } else {
            CGFloat stateValue = self.drawer.stateValue < 0.5 ? 0 : 1;
            self.drawer.stateValue = stateValue;
            self.hamburger.stateValue = self.hamburger.state == HamburgerStateNormal ? stateValue : 1 - stateValue;
        }
    }
}

- (void)dealHamburgerTap {
    if (self.hamburger.state == HamburgerStateNormal) {
        self.hamburger.state = HamburgerStateBack;
        self.drawer.stateValue = 1;
    } else {
        self.hamburger.state = HamburgerStateNormal;
        self.drawer.stateValue = 0;
    }
}

// 改变NavigationBar的高度
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.navigationBar.frame;
    frame.size.height = ToolbarHeight;
    [self.navigationBar setFrame:frame];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, Size.width - 112, 56)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:22];
        [self.navigationBar addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (Hamburger *)hamburger {
    if (!_hamburger) {
        Hamburger *hamburger = [Hamburger hamburger];
        [self.navigationBar addSubview:hamburger];
        _hamburger = hamburger;
    }
    return _hamburger;
}

- (NavigationDrawer *)drawer {
    if (!_drawer) {
        NavigationDrawer *drawer = [NavigationDrawer drawer];
        [self.view addSubview:drawer];
        _drawer = drawer;
    }
    return _drawer;
}

// 当抽屉中点击按钮时切换rootViewController
- (void)changeFunction:(NSInteger)index {
    [self setRootViewControllerWithIndex:index];
    [self dealHamburgerTap];
}

- (void)setRootViewControllerWithIndex:(NSInteger)index {
    UIViewController *vc = [self controllerWithIndex:index];
    NSArray *functionArray = @[@"东油教务", @"黎明湖畔", @"教务系统", @"东油新闻", @"教务通知"];
    self.title = functionArray[index];
    [self setRootViewController:vc];
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (!_viewController) {
        _viewController = rootViewController;
    } else {
        [_viewController willMoveToParentViewController:nil];
        [_viewController.view removeFromSuperview];
        [_viewController removeFromParentViewController];
        _viewController = rootViewController;
    }
    
    [self addChildViewController:rootViewController];
    CGRect frame = self.view.bounds;
    frame.size.height -= StatusBarHeight + ToolbarHeight;
    rootViewController.view.frame = frame;
    [self.contentViewContainer addSubview:rootViewController.view];
    [rootViewController didMoveToParentViewController:self];
}

- (UIViewController *)controllerWithIndex:(NSInteger)index {
    UIViewController *vc = self.controllersDict[[NSString stringWithFormat:@"%ld", index]];
    if (!vc) {
        switch (index) {
            case 0:
                vc = [[MainCourseController alloc] init];
                break;
            case 2:
                vc = [[JiaoWuController alloc] init];
                break;
            case 3:
                vc = [[NewsListController alloc] init];
                ((NewsListController *)vc).newsListType = NewsListDongYouNews;
                break;
            case 4:
                vc = [[NewsListController alloc] init];
                ((NewsListController *)vc).newsListType = NewsListJiaowuNotice;
                break;
            default:
                vc = [[UIViewController alloc] init];
                break;
        }
        [self.controllersDict setValue:vc forKey:[NSString stringWithFormat:@"%ld", index]];
    }
    return vc;
}

- (NSMutableDictionary *)controllersDict {
    if (!_controllersDict) {
        _controllersDict = [[NSMutableDictionary alloc] init];
    }
    return _controllersDict;
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
