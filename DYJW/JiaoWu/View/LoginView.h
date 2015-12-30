//
//  LoginView.h
//  DYJW
//
//  Created by 风筝 on 15/10/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTextField.h"
#import "MDFlatButton.h"

@interface LoginView : UIView
@property (nonatomic, weak)MDTextField *usernameField;
@property (nonatomic, weak)MDTextField *passwordField;
@property (nonatomic, weak)MDTextField *verifycodeField;
@property (nonatomic, weak)MDFlatButton *loginButton;
@property (nonatomic, weak)UIImageView *verifycodeImage;
- (void)show;
- (void)hide;
- (void)logout;
@end
