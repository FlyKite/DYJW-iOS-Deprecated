//
//  VerifyAlertCustomView.h
//  DYJW
//
//  Created by 风筝 on 16/2/3.
//  Copyright © 2016年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTextField.h"

@interface VerifyAlertCustomView : UIView
+ (instancetype)viewWithMessage:(NSString *)message;
@property (nonatomic, weak)MDTextField *verifycodeField;
@property (nonatomic, weak)UIImageView *verifycodeImage;
@end
