//
//  NSString+Height.h
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Height)
- (float)heightWithFont:(UIFont *)font withinWidth:(float)width;
- (float)widthWithFont:(UIFont *)font withinHeight:(float)height;
@end
