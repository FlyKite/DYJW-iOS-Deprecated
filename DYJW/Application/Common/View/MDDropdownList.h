//
//  MDDropdownList.h
//  DYJW
//
//  Created by 风筝 on 16/1/6.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDDropdownListDelegate <NSObject>
- (void)dropdownListDidSelectIndex:(NSInteger)index text:(NSString *)text;
@end

@interface MDDropdownList : UIView
@property (nonatomic, strong)NSArray *data;
@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, copy)NSString *selectedText;
@property (nonatomic, assign)id<MDDropdownListDelegate> delegate;
@end
