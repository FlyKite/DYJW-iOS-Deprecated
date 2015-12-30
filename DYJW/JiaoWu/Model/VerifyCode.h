//
//  VerifyCode.h
//  DYJW
//
//  Created by 风筝 on 15/10/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^loadSuccessBlock)(UIImage *verifycodeImage, NSString *recognizedCode);
typedef void (^loadFailureBlock)(void);

@interface VerifyCode : NSObject
- (void)loadVerifyCodeImageSuccess:(loadSuccessBlock)success failure:(loadFailureBlock)failure;
@property (nonatomic)NSString *recognizedCode;
@property (nonatomic)UIImage *verifycodeImage;
@end
