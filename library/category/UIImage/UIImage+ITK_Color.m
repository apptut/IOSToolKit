//
//  UIImage+ITK_Color.m
//  yiyou
//
//  Created by liangqi on 15/6/7.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "UIImage+ITK_Color.h"

@implementation UIImage (ITK_Color)

+ (UIImage *)itk_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
