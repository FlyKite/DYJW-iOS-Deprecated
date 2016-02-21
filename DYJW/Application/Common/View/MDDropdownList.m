//
//  MDDropdownList.m
//  DYJW
//
//  Created by 风筝 on 16/1/6.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import "MDDropdownList.h"
#import "MDColor.h"
#import "UIView+MDRippleView.h"

#define Window [[[UIApplication sharedApplication] delegate] window]
#define FrameInWindow [self convertRect:self.bounds toView:Window]

@interface MDDropdownList () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UIView *screenView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *tableShadowView;
@property (nonatomic)CAShapeLayer *underlineLayer;
@property (nonatomic)CAShapeLayer *triangleLayer;
@property (nonatomic)CATextLayer *textLayer;
@end

@implementation MDDropdownList
- (id)initWithFrame:(CGRect)frame {
    frame.size.height = 48;
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self createRippleView];
        self.shownRows = 4;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    frame.size.height = 48;
//    NSInteger shouldBeWidth = frame.size.width;
//    shouldBeWidth = shouldBeWidth / 48 * 48;
//    frame.size.width = frame.size.width > shouldBeWidth ? shouldBeWidth + 48 : shouldBeWidth;
    self.underlineLayer.frame = CGRectMake(0, 47, frame.size.width, 1);
    self.textLayer.frame = CGRectMake(2, 15, frame.size.width - 4, 18);
    self.triangleLayer.position = CGPointMake(frame.size.width - 12, 24);
    [super setFrame:frame];
}

- (void)rippleFinished {
    [self showList];
}

- (void)showList {
    // 获取自身在屏幕里的frame
    [Window addSubview:self.screenView];
    [Window bringSubviewToFront:self.screenView];
    self.tableView.alpha = 0;
    self.tableView.frame = FrameInWindow;
    self.tableShadowView.alpha = 0;
    self.tableShadowView.frame = FrameInWindow;
    [self showIndexAnimate:NO];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = FrameInWindow;
        frame.origin.y -= 48;
        frame.size.height = 48 * (self.shownRows > self.data.count ? self.data.count : self.shownRows);
        self.tableView.frame = frame;
        self.tableShadowView.alpha = 1;
        self.tableShadowView.frame = frame;
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showIndexAnimate:(BOOL)animate {
    if (_selectedIndex > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_selectedIndex - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animate];
    }
}

- (void)hideList {
    CGRect frame = FrameInWindow;
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.tableView.alpha = 0;
        self.tableView.frame = frame;
        self.tableShadowView.alpha = 0;
        self.tableShadowView.frame = frame;
    } completion:^(BOOL finished) {
        [self.screenView removeFromSuperview];
    }];
}

#pragma mark - Setters
- (void)setData:(NSArray *)data {
    _data = data;
    [self.tableView reloadData];
    if (data.count > 0) {
        self.selectedIndex = 0;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex < self.data.count) {
        _selectedIndex = selectedIndex;
        self.selectedText = self.data[0];
    } else {
        NSLog(@"Error : out of range!.");
    }
}

- (void)setSelectedText:(NSString *)selectedText {
    for (int i = 0; i < self.data.count; i++) {
        if ([selectedText isEqualToString:self.data[i]]) {
            _selectedIndex = i;
            _selectedText = selectedText;
            self.textLayer.string = selectedText;
            break;
        }
    }
}

#pragma mark - Getters
// 文本图层
- (CATextLayer *)textLayer {
    if (!_textLayer) {
        _textLayer = [[CATextLayer alloc] init];
        _textLayer.foregroundColor = [MDColor grey800].CGColor;
        _textLayer.alignmentMode = kCAAlignmentJustified;
        _textLayer.wrapped = YES;
        _textLayer.contentsScale = [[UIScreen mainScreen] scale];
        
        UIFont *font = [UIFont systemFontOfSize:16];
        CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        CGFontRef fontRef = CGFontCreateWithFontName(fontName);
        _textLayer.font = fontRef;
        _textLayer.fontSize = font.pointSize;
        CGFontRelease(fontRef);
        [self.layer addSublayer:_textLayer];
    }
    return _textLayer;
}

// 灰色下划线
- (CAShapeLayer *)underlineLayer {
    if (!_underlineLayer) {
        _underlineLayer = [[CAShapeLayer alloc] init];
        _underlineLayer.backgroundColor = [MDColor grey300].CGColor;
        [self.layer addSublayer:_underlineLayer];
    }
    return _underlineLayer;
}

// 倒三角
- (CAShapeLayer *)triangleLayer {
    if (!_triangleLayer) {
        _triangleLayer = [[CAShapeLayer alloc] init];
        _triangleLayer.frame = CGRectMake(0, 0, 8, 4);
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(8, 0)];
        [path addLineToPoint:CGPointMake(4, 4)];
        _triangleLayer.path = path.CGPath;
        _triangleLayer.fillColor = [MDColor grey500].CGColor;
        [self.layer addSublayer:_triangleLayer];
    }
    return _triangleLayer;
}

// 全屏容器（点击tableview外的区域则消失）
- (UIView *)screenView {
    if (!_screenView) {
        UIView *view = [[UIView alloc] initWithFrame:Window.bounds];
        UIButton *maskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        maskButton.frame = Window.bounds;
        [maskButton addTarget:self action:@selector(hideList) forControlEvents:UIControlEventTouchDown];
        [view addSubview:maskButton];
        _screenView = view;
    }
    return _screenView;
}

// TableView的阴影
- (UIView *)tableShadowView {
    if (!_tableShadowView) {
        CGRect frame = CGRectMake(self.frame.size.width, 0, 0, 0);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [MDColor grey50];
        [self.screenView addSubview:view];
        view.alpha = 0;
        view.layer.cornerRadius = 2;
        view.layer.shadowColor = [MDColor grey500].CGColor;
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowOffset = CGSizeMake(0, 2);
        view.layer.masksToBounds = NO;
        _tableShadowView = view;
    }
    return _tableShadowView;
}

// 显示列表
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = CGRectMake(self.frame.size.width, 0, 0, 0);
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.rowHeight = 48;
        tableView.sectionHeaderHeight = 8;
        tableView.sectionFooterHeight = 8;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        tableView.dataSource = self;
        tableView.delegate = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        tableView.layer.cornerRadius = 2;
        tableView.clipsToBounds = YES;
        
        self.tableShadowView.frame = CGRectZero;
        [self.screenView addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - TableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGRect frame = cell.textLabel.frame;
    frame.size.width = cell.frame.size.width - 16;
    frame.origin.x = 16;
    cell.textLabel.frame = frame;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = [MDColor grey800];
    cell.textLabel.text = self.data[indexPath.row];
    [cell createRippleView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.textLayer.string = self.data[indexPath.row];
    _selectedIndex = indexPath.row;
    _selectedText = self.data[indexPath.row];
    [self showIndexAnimate:YES];
    [self performSelector:@selector(hideList) withObject:nil afterDelay:0.3];
    if ([self.delegate respondsToSelector:@selector(dropdownListDidSelectIndex:text:)]) {
        [self.delegate dropdownListDidSelectIndex:_selectedIndex text:_selectedText];
    }
}
@end
