//
//  UIView+ITK_HexColor.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/23.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ITK_HexColor)

+ (UIColor *) itk_colorWithHexString:(NSString *) hex;

+ (UIColor *) itk_colorWithHexString:(NSString *) hex withAlpha:(CGFloat) alpha;

@end
