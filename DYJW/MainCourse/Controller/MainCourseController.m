//
//  MainCourseController.m
//  DYJW
//
//  Created by 风筝 on 15/10/29.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "MainCourseController.h"
#import "WeekDayView.h"
#import "CourseView.h"
#import "Course.h"
#import "UserInfo.h"
#import "MDColor.h"
#import "MDDropdownList.h"
#import "MDProgressView.h"

@interface MainCourseController ()
@property (nonatomic, weak)UILabel *noCourseLabel;
@property (nonatomic, weak)CourseView *courseView;
@property (nonatomic)CGRect frame;
@end

@implementation MainCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WeekDayView *weekDayView = [[WeekDayView alloc] init];
    [self.view addSubview:weekDayView];
    UserInfo *user = [UserInfo userInfo];
    if (!user.name) {
        self.noCourseLabel.hidden = NO;
    } else {
        NSDictionary *courses = [Course courses];
        if (courses) {
            self.courseView.hidden = NO;
        } else {
            self.noCourseLabel.hidden = NO;
        }
    }
    [self test];
}

#warning test
- (void)test {
    MDDropdownList *dropdownList = [[MDDropdownList alloc] initWithFrame:CGRectMake(100, 30, 82, 48)];
    dropdownList.data = @[@"UK", @"CN", @"JP", @"US", @"AU", @"CA", @"HK"];
    [self.view addSubview:dropdownList];
    
    MDProgressView *progress1 = [MDProgressView progressViewWithStyle:MDProgressViewStyleLoadingLarge];
    progress1.frame = CGRectMake(80, 320, 0, 0);
    progress1.showBackMask = YES;
    [self.view addSubview:progress1];
    
    MDProgressView *progress2 = [MDProgressView progressViewWithStyle:MDProgressViewStyleLoadingMedium];
    progress2.frame = CGRectMake(180, 320, 0, 0);
    progress2.showBackMask = YES;
//    progress2.color = [UIColor cyanColor];
    [self.view addSubview:progress2];
    
    MDProgressView *progress3 = [MDProgressView progressViewWithStyle:MDProgressViewStyleLoadingSmall];
    progress3.frame = CGRectMake(260, 320, 0, 0);
    progress3.showBackMask = YES;
    [self.view addSubview:progress3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)frame {
    if (CGRectIsEmpty(_frame)) {
        _frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 76);
    }
    return _frame;
}

- (UILabel *)noCourseLabel {
    if (!_noCourseLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = @"还没有课程哦~\n快登录教务管理系统获取课程表吧~";
        label.textColor = [MDColor grey500];
        [self.view addSubview:label];
        _noCourseLabel = label;
    }
    return _noCourseLabel;
}

- (CourseView *)courseView {
    if (!_courseView) {
        CourseView *courseView = [CourseView courseView];
        [self.view addSubview:courseView];
        _courseView = courseView;
    }
    return _courseView;
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
