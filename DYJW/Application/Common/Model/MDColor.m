//
//  MDColor.m
//  FlyKiteMaterialDesignLibrary
//
//  Created by qianfeng on 15/8/20.
//  Copyright (c) 2015年 Doge Studio. All rights reserved.
//

#import "MDColor.h"

@implementation MDColor
+ (UIImage *)pureColorImageWithColor:(UIColor *)color andSize:(CGSize)size {
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIColor *) rgbColor:(NSString *)rgbString {
    float red = 0;
    float green = 0;
    float blue = 0;
    for (int i = 1; i <= 6; i++) {
        char ch = [rgbString characterAtIndex:i];
        switch (i) {
            case 1:
                red += ch <= '9' && ch >= '0' ? (ch - 48) * 16 : 0;
                red += ch <= 'F' && ch >= 'A' ? (ch - 55) * 16 : 0;
                red += ch <= 'f' && ch >= 'a' ? (ch - 87) * 16 : 0;
                break;
            case 2:
                red += ch <= '9' && ch >= '0' ? ch - 48 : 0;
                red += ch <= 'F' && ch >= 'A' ? ch - 55 : 0;
                red += ch <= 'f' && ch >= 'a' ? ch - 87 : 0;
                break;
            case 3:
                green += ch <= '9' && ch >= '0' ? (ch - 48) * 16 : 0;
                green += ch <= 'F' && ch >= 'A' ? (ch - 55) * 16 : 0;
                green += ch <= 'f' && ch >= 'a' ? (ch - 87) * 16 : 0;
                break;
            case 4:
                green += ch <= '9' && ch >= '0' ? ch - 48 : 0;
                green += ch <= 'F' && ch >= 'A' ? ch - 55 : 0;
                green += ch <= 'f' && ch >= 'a' ? ch - 87 : 0;
                break;
            case 5:
                blue += ch <= '9' && ch >= '0' ? (ch - 48) * 16 : 0;
                blue += ch <= 'F' && ch >= 'A' ? (ch - 55) * 16 : 0;
                blue += ch <= 'f' && ch >= 'a' ? (ch - 87) * 16 : 0;
                break;
            case 6:
                blue += ch <= '9' && ch >= '0' ? ch - 48 : 0;
                blue += ch <= 'F' && ch >= 'A' ? ch - 55 : 0;
                blue += ch <= 'f' && ch >= 'a' ? ch - 87 : 0;
                break;
        }
    }
    return [UIColor colorWithRed:red/255 green:green/255 blue:blue/255 alpha:1];
}
// lightBlue
+ (UIColor *) red50 {return [MDColor rgbColor:@"#fde0dc"];}
+ (UIColor *) red100 {return [MDColor rgbColor:@"#f9bdbb"];}
+ (UIColor *) red200 {return [MDColor rgbColor:@"#f69988"];}
+ (UIColor *) red300 {return [MDColor rgbColor:@"#f36c60"];}
+ (UIColor *) red400 {return [MDColor rgbColor:@"#e84e40"];}
+ (UIColor *) red500 {return [MDColor rgbColor:@"#e51c23"];}
+ (UIColor *) red600 {return [MDColor rgbColor:@"#dd191d"];}
+ (UIColor *) red700 {return [MDColor rgbColor:@"#d01716"];}
+ (UIColor *) red800 {return [MDColor rgbColor:@"#c41411"];}
+ (UIColor *) red900 {return [MDColor rgbColor:@"#b0120a"];}
+ (UIColor *) redA100 {return [MDColor rgbColor:@"#ff7997"];}
+ (UIColor *) redA200 {return [MDColor rgbColor:@"#ff5177"];}
+ (UIColor *) redA400 {return [MDColor rgbColor:@"#ff2d6f"];}
+ (UIColor *) redA700 {return [MDColor rgbColor:@"#e00032"];}
// Pink
+ (UIColor *) pink50 {return [MDColor rgbColor:@"#fce4ec"];}
+ (UIColor *) pink100 {return [MDColor rgbColor:@"#f8bbd0"];}
+ (UIColor *) pink200 {return [MDColor rgbColor:@"#f48fb1"];}
+ (UIColor *) pink300 {return [MDColor rgbColor:@"#f06292"];}
+ (UIColor *) pink400 {return [MDColor rgbColor:@"#ec407a"];}
+ (UIColor *) pink500 {return [MDColor rgbColor:@"#e91e63"];}
+ (UIColor *) pink600 {return [MDColor rgbColor:@"#d81b60"];}
+ (UIColor *) pink700 {return [MDColor rgbColor:@"#c2185b"];}
+ (UIColor *) pink800 {return [MDColor rgbColor:@"#ad1457"];}
+ (UIColor *) pink900 {return [MDColor rgbColor:@"#880e4f"];}
+ (UIColor *) pinkA100 {return [MDColor rgbColor:@"#ff80ab"];}
+ (UIColor *) pinkA200 {return [MDColor rgbColor:@"#ff4081"];}
+ (UIColor *) pinkA400 {return [MDColor rgbColor:@"#f50057"];}
+ (UIColor *) pinkA700 {return [MDColor rgbColor:@"#c51162"];}
// Purplex
+ (UIColor *) purple50 {return [MDColor rgbColor:@"#f3e5f5"];}
+ (UIColor *) purple100 {return [MDColor rgbColor:@"#e1bee7"];}
+ (UIColor *) purple200 {return [MDColor rgbColor:@"#ce93d8"];}
+ (UIColor *) purple300 {return [MDColor rgbColor:@"#ba68c8"];}
+ (UIColor *) purple400 {return [MDColor rgbColor:@"#ab47bc"];}
+ (UIColor *) purple500 {return [MDColor rgbColor:@"#9c27b0"];}
+ (UIColor *) purple600 {return [MDColor rgbColor:@"#8e24aa"];}
+ (UIColor *) purple700 {return [MDColor rgbColor:@"#7b1fa2"];}
+ (UIColor *) purple800 {return [MDColor rgbColor:@"#6a1b9a"];}
+ (UIColor *) purple900 {return [MDColor rgbColor:@"#4a148c"];}
+ (UIColor *) purpleA100 {return [MDColor rgbColor:@"#ea80fc"];}
+ (UIColor *) purpleA200 {return [MDColor rgbColor:@"#e040fb"];}
+ (UIColor *) purpleA400 {return [MDColor rgbColor:@"#d500f9"];}
+ (UIColor *) purpleA700 {return [MDColor rgbColor:@"#aa00ff"];}
// Deep Purple
+ (UIColor *) deepPurple50 {return [MDColor rgbColor:@"#ede7f6"];}
+ (UIColor *) deepPurple100 {return [MDColor rgbColor:@"#d1c4e9"];}
+ (UIColor *) deepPurple200 {return [MDColor rgbColor:@"#b39ddb"];}
+ (UIColor *) deepPurple300 {return [MDColor rgbColor:@"#9575cd"];}
+ (UIColor *) deepPurple400 {return [MDColor rgbColor:@"#7e57c2"];}
+ (UIColor *) deepPurple500 {return [MDColor rgbColor:@"#673ab7"];}
+ (UIColor *) deepPurple600 {return [MDColor rgbColor:@"#5e35b1"];}
+ (UIColor *) deepPurple700 {return [MDColor rgbColor:@"#512da8"];}
+ (UIColor *) deepPurple800 {return [MDColor rgbColor:@"#4527a0"];}
+ (UIColor *) deepPurple900 {return [MDColor rgbColor:@"#311b92"];}
+ (UIColor *) deepPurpleA100 {return [MDColor rgbColor:@"#b388ff"];}
+ (UIColor *) deepPurpleA200 {return [MDColor rgbColor:@"#7c4dff"];}
+ (UIColor *) deepPurpleA400 {return [MDColor rgbColor:@"#651fff"];}
+ (UIColor *) deepPurpleA700 {return [MDColor rgbColor:@"#6200ea"];}
// Indigo
+ (UIColor *) indigo50 {return [MDColor rgbColor:@"#e8eaf6"];}
+ (UIColor *) indigo100 {return [MDColor rgbColor:@"#c5cae9"];}
+ (UIColor *) indigo200 {return [MDColor rgbColor:@"#9fa8da"];}
+ (UIColor *) indigo300 {return [MDColor rgbColor:@"#7986cb"];}
+ (UIColor *) indigo400 {return [MDColor rgbColor:@"#5c6bc0"];}
+ (UIColor *) indigo500 {return [MDColor rgbColor:@"#3f51b5"];}
+ (UIColor *) indigo600 {return [MDColor rgbColor:@"#3949ab"];}
+ (UIColor *) indigo700 {return [MDColor rgbColor:@"#303f9f"];}
+ (UIColor *) indigo800 {return [MDColor rgbColor:@"#283593"];}
+ (UIColor *) indigo900 {return [MDColor rgbColor:@"#1a237e"];}
+ (UIColor *) indigoA100 {return [MDColor rgbColor:@"#8c9eff"];}
+ (UIColor *) indigoA200 {return [MDColor rgbColor:@"#536dfe"];}
+ (UIColor *) indigoA400 {return [MDColor rgbColor:@"#3d5afe"];}
+ (UIColor *) indigoA700 {return [MDColor rgbColor:@"#304ffe"];}
// Blue
+ (UIColor *) blue50 {return [MDColor rgbColor:@"#e7e9fd"];}
+ (UIColor *) blue100 {return [MDColor rgbColor:@"#d0d9ff"];}
+ (UIColor *) blue200 {return [MDColor rgbColor:@"#afbfff"];}
+ (UIColor *) blue300 {return [MDColor rgbColor:@"#91a7ff"];}
+ (UIColor *) blue400 {return [MDColor rgbColor:@"#738ffe"];}
+ (UIColor *) blue500 {return [MDColor rgbColor:@"#5677fc"];}
+ (UIColor *) blue600 {return [MDColor rgbColor:@"#4e6cef"];}
+ (UIColor *) blue700 {return [MDColor rgbColor:@"#455ede"];}
+ (UIColor *) blue800 {return [MDColor rgbColor:@"#3b50ce"];}
+ (UIColor *) blue900 {return [MDColor rgbColor:@"#2a36b1"];}
+ (UIColor *) blueA100 {return [MDColor rgbColor:@"#a6baff"];}
+ (UIColor *) blueA200 {return [MDColor rgbColor:@"#6889ff"];}
+ (UIColor *) blueA400 {return [MDColor rgbColor:@"#4d73ff"];}
+ (UIColor *) blueA700 {return [MDColor rgbColor:@"#4d69ff"];}
// Light Blue
+ (UIColor *) lightBlue50 {return [MDColor rgbColor:@"#e1f5fe"];}
+ (UIColor *) lightBlue100 {return [MDColor rgbColor:@"#b3e5fc"];}
+ (UIColor *) lightBlue200 {return [MDColor rgbColor:@"#81d4fa"];}
+ (UIColor *) lightBlue300 {return [MDColor rgbColor:@"#4fc3f7"];}
+ (UIColor *) lightBlue400 {return [MDColor rgbColor:@"#29b6f6"];}
+ (UIColor *) lightBlue500 {return [MDColor rgbColor:@"#03a9f4"];}
+ (UIColor *) lightBlue600 {return [MDColor rgbColor:@"#039be5"];}
+ (UIColor *) lightBlue700 {return [MDColor rgbColor:@"#0288d1"];}
+ (UIColor *) lightBlue800 {return [MDColor rgbColor:@"#0277bd"];}
+ (UIColor *) lightBlue900 {return [MDColor rgbColor:@"#01579b"];}
+ (UIColor *) lightBlueA100 {return [MDColor rgbColor:@"#80d8ff"];}
+ (UIColor *) lightBlueA200 {return [MDColor rgbColor:@"#40c4ff"];}
+ (UIColor *) lightBlueA400 {return [MDColor rgbColor:@"#00b0ff"];}
+ (UIColor *) lightBlueA700 {return [MDColor rgbColor:@"#0091ea"];}
// Cyan
+ (UIColor *) cyan50 {return [MDColor rgbColor:@"#e0f7fa"];}
+ (UIColor *) cyan100 {return [MDColor rgbColor:@"#b2ebf2"];}
+ (UIColor *) cyan200 {return [MDColor rgbColor:@"#80deea"];}
+ (UIColor *) cyan300 {return [MDColor rgbColor:@"#4dd0e1"];}
+ (UIColor *) cyan400 {return [MDColor rgbColor:@"#26c6da"];}
+ (UIColor *) cyan500 {return [MDColor rgbColor:@"#00bcd4"];}
+ (UIColor *) cyan600 {return [MDColor rgbColor:@"#00acc1"];}
+ (UIColor *) cyan700 {return [MDColor rgbColor:@"#0097a7"];}
+ (UIColor *) cyan800 {return [MDColor rgbColor:@"#00838f"];}
+ (UIColor *) cyan900 {return [MDColor rgbColor:@"#006064"];}
+ (UIColor *) cyanA100 {return [MDColor rgbColor:@"#84ffff"];}
+ (UIColor *) cyanA200 {return [MDColor rgbColor:@"#18ffff"];}
+ (UIColor *) cyanA400 {return [MDColor rgbColor:@"#00e5ff"];}
+ (UIColor *) cyanA700 {return [MDColor rgbColor:@"#00b8d4"];}
// Teal
+ (UIColor *) teal50 {return [MDColor rgbColor:@"#e0f2f1"];}
+ (UIColor *) teal100 {return [MDColor rgbColor:@"#b2dfdb"];}
+ (UIColor *) teal200 {return [MDColor rgbColor:@"#80cbc4"];}
+ (UIColor *) teal300 {return [MDColor rgbColor:@"#4db6ac"];}
+ (UIColor *) teal400 {return [MDColor rgbColor:@"#26a69a"];}
+ (UIColor *) teal500 {return [MDColor rgbColor:@"#009688"];}
+ (UIColor *) teal600 {return [MDColor rgbColor:@"#00897b"];}
+ (UIColor *) teal700 {return [MDColor rgbColor:@"#00796b"];}
+ (UIColor *) teal800 {return [MDColor rgbColor:@"#00695c"];}
+ (UIColor *) teal900 {return [MDColor rgbColor:@"#004d40"];}
+ (UIColor *) tealA100 {return [MDColor rgbColor:@"#a7ffeb"];}
+ (UIColor *) tealA200 {return [MDColor rgbColor:@"#64ffda"];}
+ (UIColor *) tealA400 {return [MDColor rgbColor:@"#1de9b6"];}
+ (UIColor *) tealA700 {return [MDColor rgbColor:@"#00bfa5"];}
// Green
+ (UIColor *) green50 {return [MDColor rgbColor:@"#d0f8ce"];}
+ (UIColor *) green100 {return [MDColor rgbColor:@"#a3e9a4"];}
+ (UIColor *) green200 {return [MDColor rgbColor:@"#72d572"];}
+ (UIColor *) green300 {return [MDColor rgbColor:@"#42bd41"];}
+ (UIColor *) green400 {return [MDColor rgbColor:@"#2baf2b"];}
+ (UIColor *) green500 {return [MDColor rgbColor:@"#259b24"];}
+ (UIColor *) green600 {return [MDColor rgbColor:@"#0a8f08"];}
+ (UIColor *) green700 {return [MDColor rgbColor:@"#0a7e07"];}
+ (UIColor *) green800 {return [MDColor rgbColor:@"#056f00"];}
+ (UIColor *) green900 {return [MDColor rgbColor:@"#0d5302"];}
+ (UIColor *) greenA100 {return [MDColor rgbColor:@"#a2f78d"];}
+ (UIColor *) greenA200 {return [MDColor rgbColor:@"#5af158"];}
+ (UIColor *) greenA400 {return [MDColor rgbColor:@"#14e715"];}
+ (UIColor *) greenA700 {return [MDColor rgbColor:@"#12c700"];}
// Light Green
+ (UIColor *) lightGreen50 {return [MDColor rgbColor:@"#f1f8e9"];}
+ (UIColor *) lightGreen100 {return [MDColor rgbColor:@"#dcedc8"];}
+ (UIColor *) lightGreen200 {return [MDColor rgbColor:@"#c5e1a5"];}
+ (UIColor *) lightGreen300 {return [MDColor rgbColor:@"#aed581"];}
+ (UIColor *) lightGreen400 {return [MDColor rgbColor:@"#9ccc65"];}
+ (UIColor *) lightGreen500 {return [MDColor rgbColor:@"#8bc34a"];}
+ (UIColor *) lightGreen600 {return [MDColor rgbColor:@"#7cb342"];}
+ (UIColor *) lightGreen700 {return [MDColor rgbColor:@"#689f38"];}
+ (UIColor *) lightGreen800 {return [MDColor rgbColor:@"#558b2f"];}
+ (UIColor *) lightGreen900 {return [MDColor rgbColor:@"#33691e"];}
+ (UIColor *) lightGreenA100 {return [MDColor rgbColor:@"#ccff90"];}
+ (UIColor *) lightGreenA200 {return [MDColor rgbColor:@"#b2ff59"];}
+ (UIColor *) lightGreenA400 {return [MDColor rgbColor:@"#76ff03"];}
+ (UIColor *) lightGreenA700 {return [MDColor rgbColor:@"#64dd17"];}
// Lime
+ (UIColor *) lime50 {return [MDColor rgbColor:@"#f9fbe7"];}
+ (UIColor *) lime100 {return [MDColor rgbColor:@"#f0f4c3"];}
+ (UIColor *) lime200 {return [MDColor rgbColor:@"#e6ee9c"];}
+ (UIColor *) lime300 {return [MDColor rgbColor:@"#dce775"];}
+ (UIColor *) lime400 {return [MDColor rgbColor:@"#d4e157"];}
+ (UIColor *) lime500 {return [MDColor rgbColor:@"#cddc39"];}
+ (UIColor *) lime600 {return [MDColor rgbColor:@"#c0ca33"];}
+ (UIColor *) lime700 {return [MDColor rgbColor:@"#afb42b"];}
+ (UIColor *) lime800 {return [MDColor rgbColor:@"#9e9d24"];}
+ (UIColor *) lime900 {return [MDColor rgbColor:@"#827717"];}
+ (UIColor *) limeA100 {return [MDColor rgbColor:@"#f4ff81"];}
+ (UIColor *) limeA200 {return [MDColor rgbColor:@"#eeff41"];}
+ (UIColor *) limeA400 {return [MDColor rgbColor:@"#c6ff00"];}
+ (UIColor *) limeA700 {return [MDColor rgbColor:@"#aeea00"];}
// Yellow
+ (UIColor *) yellow50 {return [MDColor rgbColor:@"#fffde7"];}
+ (UIColor *) yellow100 {return [MDColor rgbColor:@"#fff9c4"];}
+ (UIColor *) yellow200 {return [MDColor rgbColor:@"#fff59d"];}
+ (UIColor *) yellow300 {return [MDColor rgbColor:@"#fff176"];}
+ (UIColor *) yellow400 {return [MDColor rgbColor:@"#ffee58"];}
+ (UIColor *) yellow500 {return [MDColor rgbColor:@"#ffeb3b"];}
+ (UIColor *) yellow600 {return [MDColor rgbColor:@"#fdd835"];}
+ (UIColor *) yellow700 {return [MDColor rgbColor:@"#fbc02d"];}
+ (UIColor *) yellow800 {return [MDColor rgbColor:@"#f9a825"];}
+ (UIColor *) yellow900 {return [MDColor rgbColor:@"#f57f17"];}
+ (UIColor *) yellowA100 {return [MDColor rgbColor:@"#ffff8d"];}
+ (UIColor *) yellowA200 {return [MDColor rgbColor:@"#ffff00"];}
+ (UIColor *) yellowA400 {return [MDColor rgbColor:@"#ffea00"];}
+ (UIColor *) yellowA700 {return [MDColor rgbColor:@"#ffd600"];}
// Amber
+ (UIColor *) amber50 {return [MDColor rgbColor:@"#fff8e1"];}
+ (UIColor *) amber100 {return [MDColor rgbColor:@"#ffecb3"];}
+ (UIColor *) amber200 {return [MDColor rgbColor:@"#ffe082"];}
+ (UIColor *) amber300 {return [MDColor rgbColor:@"#ffd54f"];}
+ (UIColor *) amber400 {return [MDColor rgbColor:@"#ffca28"];}
+ (UIColor *) amber500 {return [MDColor rgbColor:@"#ffc107"];}
+ (UIColor *) amber600 {return [MDColor rgbColor:@"#ffb300"];}
+ (UIColor *) amber700 {return [MDColor rgbColor:@"#ffa000"];}
+ (UIColor *) amber800 {return [MDColor rgbColor:@"#ff8f00"];}
+ (UIColor *) amber900 {return [MDColor rgbColor:@"#ff6f00"];}
+ (UIColor *) amberA100 {return [MDColor rgbColor:@"#ffe57f"];}
+ (UIColor *) amberA200 {return [MDColor rgbColor:@"#ffd740"];}
+ (UIColor *) amberA400 {return [MDColor rgbColor:@"#ffc400"];}
+ (UIColor *) amberA700 {return [MDColor rgbColor:@"#ffab00"];}
// Orange
+ (UIColor *) orange50 {return [MDColor rgbColor:@"#fff3e0"];}
+ (UIColor *) orange100 {return [MDColor rgbColor:@"#ffe0b2"];}
+ (UIColor *) orange200 {return [MDColor rgbColor:@"#ffcc80"];}
+ (UIColor *) orange300 {return [MDColor rgbColor:@"#ffb74d"];}
+ (UIColor *) orange400 {return [MDColor rgbColor:@"#ffa726"];}
+ (UIColor *) orange500 {return [MDColor rgbColor:@"#ff9800"];}
+ (UIColor *) orange600 {return [MDColor rgbColor:@"#fb8c00"];}
+ (UIColor *) orange700 {return [MDColor rgbColor:@"#f57c00"];}
+ (UIColor *) orange800 {return [MDColor rgbColor:@"#ef6c00"];}
+ (UIColor *) orange900 {return [MDColor rgbColor:@"#e65100"];}
+ (UIColor *) orangeA100 {return [MDColor rgbColor:@"#ffd180"];}
+ (UIColor *) orangeA200 {return [MDColor rgbColor:@"#ffab40"];}
+ (UIColor *) orangeA400 {return [MDColor rgbColor:@"#ff9100"];}
+ (UIColor *) orangeA700 {return [MDColor rgbColor:@"#ff6d00"];}
// Deep Orange
+ (UIColor *) deepOrange50 {return [MDColor rgbColor:@"#fbe9e7"];}
+ (UIColor *) deepOrange100 {return [MDColor rgbColor:@"#ffccbc"];}
+ (UIColor *) deepOrange200 {return [MDColor rgbColor:@"#ffab91"];}
+ (UIColor *) deepOrange300 {return [MDColor rgbColor:@"#ff8a65"];}
+ (UIColor *) deepOrange400 {return [MDColor rgbColor:@"#ff7043"];}
+ (UIColor *) deepOrange500 {return [MDColor rgbColor:@"#ff5722"];}
+ (UIColor *) deepOrange600 {return [MDColor rgbColor:@"#f4511e"];}
+ (UIColor *) deepOrange700 {return [MDColor rgbColor:@"#e64a19"];}
+ (UIColor *) deepOrange800 {return [MDColor rgbColor:@"#d84315"];}
+ (UIColor *) deepOrange900 {return [MDColor rgbColor:@"#bf360c"];}
+ (UIColor *) deepOrangeA100 {return [MDColor rgbColor:@"#ff9e80"];}
+ (UIColor *) deepOrangeA200 {return [MDColor rgbColor:@"#ff6e40"];}
+ (UIColor *) deepOrangeA400 {return [MDColor rgbColor:@"#ff3d00"];}
+ (UIColor *) deepOrangeA700 {return [MDColor rgbColor:@"#dd2c00"];}
// Brown
+ (UIColor *) brown50 {return [MDColor rgbColor:@"#efebe9"];}
+ (UIColor *) brown100 {return [MDColor rgbColor:@"#d7ccc8"];}
+ (UIColor *) brown200 {return [MDColor rgbColor:@"#bcaaa4"];}
+ (UIColor *) brown300 {return [MDColor rgbColor:@"#a1887f"];}
+ (UIColor *) brown400 {return [MDColor rgbColor:@"#8d6e63"];}
+ (UIColor *) brown500 {return [MDColor rgbColor:@"#795548"];}
+ (UIColor *) brown600 {return [MDColor rgbColor:@"#6d4c41"];}
+ (UIColor *) brown700 {return [MDColor rgbColor:@"#5d4037"];}
+ (UIColor *) brown800 {return [MDColor rgbColor:@"#4e342e"];}
+ (UIColor *) brown900 {return [MDColor rgbColor:@"#3e2723"];}
// Grey
+ (UIColor *) grey50 {return [MDColor rgbColor:@"#fafafa"];}
+ (UIColor *) grey100 {return [MDColor rgbColor:@"#f5f5f5"];}
+ (UIColor *) grey200 {return [MDColor rgbColor:@"#eeeeee"];}
+ (UIColor *) grey300 {return [MDColor rgbColor:@"#e0e0e0"];}
+ (UIColor *) grey400 {return [MDColor rgbColor:@"#bdbdbd"];}
+ (UIColor *) grey500 {return [MDColor rgbColor:@"#9e9e9e"];}
+ (UIColor *) grey600 {return [MDColor rgbColor:@"#757575"];}
+ (UIColor *) grey700 {return [MDColor rgbColor:@"#616161"];}
+ (UIColor *) grey800 {return [MDColor rgbColor:@"#424242"];}
+ (UIColor *) grey900 {return [MDColor rgbColor:@"#212121"];}
// blueGrey
+ (UIColor *) blueGrey50 {return [MDColor rgbColor:@"#eceff1"];}
+ (UIColor *) blueGrey100 {return [MDColor rgbColor:@"#cfd8dc"];}
+ (UIColor *) blueGrey200 {return [MDColor rgbColor:@"#b0bec5"];}
+ (UIColor *) blueGrey300 {return [MDColor rgbColor:@"#90a4ae"];}
+ (UIColor *) blueGrey400 {return [MDColor rgbColor:@"#78909c"];}
+ (UIColor *) blueGrey500 {return [MDColor rgbColor:@"#607d8b"];}
+ (UIColor *) blueGrey600 {return [MDColor rgbColor:@"#546e7a"];}
+ (UIColor *) blueGrey700 {return [MDColor rgbColor:@"#455a64"];}
+ (UIColor *) blueGrey800 {return [MDColor rgbColor:@"#37474f"];}
+ (UIColor *) blueGrey900 {return [MDColor rgbColor:@"#263238"];}
@end
