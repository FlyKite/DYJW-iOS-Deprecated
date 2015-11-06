//
//  NewsListController.h
//  DYJW
//
//  Created by 风筝 on 15/11/3.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NewsListType) {
    NewsListDongYouNews,
    NewsListJiaowuNotice
};

@interface NewsListController : UIViewController
@property (nonatomic, assign)NewsListType newsListType;
@end
