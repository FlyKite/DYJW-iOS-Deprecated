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
#import "LiMingHuPanController.h"

#define StatusBarHeight 20
#define ToolbarHeight 56
#define Padding 8
#define Size [UIScreen mainScreen].bounds.size

@interface ToolbarController () <ChangeFunctionDelegate> {
    CGRect drawerPanStartFrame;
}
//@property (nonatomic, weak)UIView *contentViewContainer;
@property (nonatomic, strong)UIViewController *viewController;
@property (nonnull, strong)UIPanGestureRecognizer *viewPan;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)NavigationDrawer *drawer;
@property (nonatomic, weak)Hamburger *hamburger;
@property (nonatomic)NSMutableDictionary *controllersDict;
@end

@implementation ToolbarController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self initDrawerAndHamburger];
    [self initGesture];
    [self setRootViewControllerWithIndex:0];
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
    if (title) {
        self.titleLabel.text = title;
    }
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
    containerPan.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:containerPan];
    self.viewPan = containerPan;
    
    UIPanGestureRecognizer *drawerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dealDrawerPan:)];
    [self.drawer addGestureRecognizer:drawerPan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dealHamburgerTap)];
    [self.hamburger addGestureRecognizer:tap];
}

// 处理抽屉的滑动手势
- (void)dealDrawerPan:(UIPanGestureRecognizer *)pan {
    if (self.hamburger.state == HamburgerStatePopBack) {
        // 当Hamburger按钮显示为指向左侧的箭头时不可滑出Drawer
        return;
    }
    if (pan.view == self.view && pan.state == UIGestureRecognizerStateBegan) {
        // 用户开始Pan（拖动）手势时进行判断
        CGPoint point = [pan locationInView:pan.view];
        if (point.x < 30) {
            // 若用户从距离屏幕左侧30个像素的距离内开始滑动则响应用户手势，否则不做任何处理
            CGRect frame = self.drawer.frame;
            frame.origin.x = 0;
            self.drawer.frame = frame;
            CGPoint point = [pan locationInView:pan.view];
            self.drawer.stateValue = point.x / (self.drawer.frame.size.width * 2 / 3);
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        // 响应用户手势之后在用户滑动过程中随时计算Drawer的位置
        CGFloat stateValue = 0;
        CGPoint point = [pan locationInView:pan.view];
        if (point.x > self.drawer.frame.size.width * 2 / 3) {
            stateValue = 1.0;
            return;
        }
        if (pan.view == self.view && self.drawer.frame.origin.x == 0) {
            stateValue = point.x / (self.drawer.frame.size.width * 2 / 3);
        }
        if (pan.view == self.drawer) {
            stateValue = point.x / (self.drawer.frame.size.width * 2 / 3);
        }
        self.drawer.stateValue = stateValue;
        self.hamburger.stateValue = self.hamburger.state == HamburgerStateNormal ? (stateValue > 1 ? 1 : stateValue) : 1 - stateValue;
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        // 当用户抬起手指时作出结束判断
        CGPoint v = [pan velocityInView:pan.view];
        if (v.x > 600 || v.x < -600) {
            // 若用户抬起手指时速度大于600像素点每秒则会根据用户滑动方向作出打开或关闭Drawer的动作
            self.drawer.stateValue = v.x > 0 && self.drawer.frame.origin.x == 0 ? 1 : 0;
            if (v.x > 0 && self.drawer.frame.origin.x == 0) {
                self.hamburger.stateValue = self.hamburger.state == HamburgerStateNormal ? 1 : 0;
            } else if (v.x < 0) {
                self.hamburger.stateValue = self.hamburger.state == HamburgerStateBack ? 1 : 0;
            }
        } else {
            // 若用户抬起手指是速度不满足要求则判断Drawer滑出位置是否大于一半，若为是则打开Drawer，否则关闭Drawer
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
        if (self.hamburger.state == HamburgerStatePopBack) {
            [self popViewControllerAnimated:YES];
        }
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
    [self performSelector:@selector(performChangeFunction:) withObject:@(index) afterDelay:0.2];
}

- (void)performChangeFunction:(NSNumber *)index {
    [self setRootViewControllerWithIndex:[index integerValue]];
    [self dealHamburgerTap];
}

- (void)setRootViewControllerWithIndex:(NSInteger)index {
    UIViewController *vc = [self controllerWithIndex:index];
    NSArray *functionArray = @[@"东油教务", @"黎明湖畔", @"教务系统", @"东油新闻", @"教务通知"];
    self.title = functionArray[index];
    [self setRootViewController:vc];
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    if (_viewController != rootViewController) {
        _viewController = rootViewController;
        [self popToRootViewControllerAnimated:NO];
        if ([self.viewControllers containsObject:rootViewController]) {
            [super popToViewController:rootViewController animated:NO];
        } else {
            [super pushViewController:rootViewController animated:NO];
        }
    }
}

- (UIViewController *)controllerWithIndex:(NSInteger)index {
    UIViewController *vc = self.controllersDict[[NSString stringWithFormat:@"%ld", index]];
    if (!vc) {
        switch (index) {
            case 0:
                vc = [[MainCourseController alloc] init];
                break;
            case 1:
                vc = [[LiMingHuPanController alloc] init];
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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    self.hamburger.state = HamburgerStatePopBack;
    self.viewPan.enabled = NO;
}

- (nullable NSArray<__kindof UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *controllers = [super popToViewController:viewController animated:animated];
    if ([self.controllersDict.allValues containsObject:viewController]) {
        self.hamburger.state = HamburgerStateNormal;
    }
    return controllers;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    self.viewPan.enabled = YES;
    UIViewController *controller = [super popViewControllerAnimated:animated];
    if ([self.controllersDict.allValues containsObject:self.topViewController]) {
        self.hamburger.state = HamburgerStateNormal;
    }
    return controller;
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

@end
