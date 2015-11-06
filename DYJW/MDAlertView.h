//
//  MDAlertView.h
//  DYJW
//
//  Created by 风筝 on 15/10/31.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDFlatButton.h"

@interface MDAlertView : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, weak)MDFlatButton *positiveButton;
@property (nonatomic, weak)MDFlatButton *negativeButton;
@property (nonatomic, weak)MDFlatButton *leftButton;
@end
