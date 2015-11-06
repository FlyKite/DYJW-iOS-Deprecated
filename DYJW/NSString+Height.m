//
//  NSString+Height.m
//  DYJW
//
//  Created by 风筝 on 15/11/6.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "NSString+Height.h"

@implementation NSString (Height)
- (float)heightWithFont:(UIFont *)font withinWidth:(float)width {
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return ceil(textRect.size.height);
}
- (float)widthWithFont:(UIFont *)font withinHeight:(float)height {
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return ceil(textRect.size.width);
}
@end
