//
//  NewsListController.h
//  DYJW
//
//  Created by 风筝 on 15/11/3.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "ToolbarSubViewController.h"

typedef NS_ENUM(NSUInteger, NewsListType) {
    NewsListDongYouNews,
    NewsListJiaowuNotice
};

@interface NewsListController : ToolbarSubViewController
@property (nonatomic, assign)NewsListType newsListType;
@end
