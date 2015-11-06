//
//  NewsList.h
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsListDelegate <NSObject>
- (void)newsClicked:(NSString *)url;
@end

@interface NewsList : UITableView
@property (nonatomic, copy)NSString *path;
@property (nonatomic, strong)NSArray *data;
@property (nonatomic, weak)id<NewsListDelegate> newsDelegate;
@end
