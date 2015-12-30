//
//  VerifyCode.m
//  DYJW
//
//  Created by 风筝 on 15/10/30.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "VerifyCode.h"
#import "AFNetworking.h"

@implementation VerifyCode
- (void)loadVerifyCodeImageSuccess:(loadSuccessBlock)success failure:(loadFailureBlock)failure {
    NSString *url = @"http://jwgl.nepu.edu.cn/verifycode.servlet";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.verifycodeImage = [UIImage imageWithData:responseObject];
        self.recognizedCode = [self getVerifyCode:self.verifycodeImage];
        if (success) {
            success(self.verifycodeImage, self.recognizedCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure();
        }
    }];
}

- (NSString *)getVerifyCode:(UIImage *)image {
    NSArray *letters = @[@"b", @"c", @"m", @"n", @"v", @"x", @"z", @"1", @"2", @"3"];
    NSArray *nums =@[
                     @[@4095,@4095,@1584,@3096,@3096,@3640,@2032,@992],
                     @[@992,@2032,@3640,@3096,@3096,@3640,@560],
                     @[@4088,@4088,@48,@24,@24,@4088,@4080,@48,@24,@24,@4088,@4080],
                     @[@4088,@4088,@48,@24,@24,@24,@4088,@4080],
                     @[@56,@504,@4032,@3584,@4032,@504,@56],
                     @[@3096,@3640,@2032,@448,@2032,@3640,@3096],
                     @[@3096,@3864,@3992,@3544,@3320,@3192,@3096],
                     @[@24,@12,@6,@4095,@4095],
                     @[@3084,@3598,@3847,@3459,@3523,@3299,@3198,@3100],
                     @[@772,@1798,@3587,@3123,@3123,@3699,@2047,@974]
                     ];
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    // 分配内存
    const int imageWidth = 45;
    const int imageHeight = 12;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t *rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 裁剪图片
    CGImageRef cgimage = CGImageCreateWithImageInRect([image CGImage], CGRectMake(3, 4, 45, 12));
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), cgimage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t *pCurPtr = rgbImageBuf;
    NSMutableArray *colorLine = [[NSMutableArray alloc] init];
    for (int i = 0; i < pixelNum; i++, pCurPtr++) {
        if (*pCurPtr < 0x99999900) {
//            printf("1");
            [colorLine addObject:@1];
        } else {
//            printf("0");
            [colorLine addObject:@0];
        }
        if (i % 45 == 44) {
//            printf("\n");
            [colors addObject:colorLine];
            colorLine = [[NSMutableArray alloc] init];
        }
    }
    
    // 释放内存！重要！千万要按顺序释放！
    free(rgbImageBuf);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(cgimage);
    
    NSMutableString *vcode = [[NSMutableString alloc] init];
    for (int x = 0; x < 45; x++) {
        // 从每一列开始往后比较
        for (int i = 0; i < 10; i++) {
            // 与已知各个字符进行比较
            if ([self compare:colors position:x dest:nums[i]]) {
                [vcode appendString:letters[i]];
                break;
            }
        }
    }
    NSLog(@"VerifyCode=%@", vcode);
    return vcode;
}

- (BOOL)compare:(NSArray*)source position:(int)position dest:(NSArray*)dest {
    for (int x = position; x < position + dest.count - 1; x++) {
        // 计算图片当前列的像素点的比特值
        int lineValue = 0;
        int binBit = 1;
        for (int y = 0; y < 12; y++) {
            lineValue += [((NSNumber*)((NSArray*)source[y])[x]) intValue] == 1 ? binBit : 0;
            binBit *= 2;
        }
        // 进行按位与运算,若结果与当前字母当前列相等则可能为该字母,进行详细比较
        if ((lineValue & [((NSNumber*)dest[x-position]) intValue]) != [((NSNumber*)dest[x-position]) intValue]) {
            // 若某一列不相等则不可能为该字符
            return NO;
        }
    }
    return YES;
}
@end
