//
//  UIView+ITK_HexColor.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/23.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "UIColor+ITK_HexColor.h"

static NSString* const itkInitError = @"color must begin with #, such as #333 or #666666";

@implementation UIColor (ITK_HexColor)

+ (UIColor *) itk_colorWithHexString:(NSString *) hex
{
    return [self itk_colorWithHexString:hex withAlpha:1.0f];
}

+ (UIColor *) itk_colorWithHexString:(NSString *) hex withAlpha:(CGFloat) alpha
{
    // remove white space
    NSString* cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (![cString hasPrefix:@"#"]){
        @throw [[NSException alloc] initWithName:@"ColorExceptoin" reason:itkInitError userInfo:nil];
    }
    
    cString = [cString substringFromIndex:1];
    
    if (cString.length != 6 && cString.length != 3){
        @throw [[NSException alloc] initWithName:@"ColorExceptoin" reason:itkInitError userInfo:nil];
    }
    
    
    NSString* rString = nil;
    NSString* gString = nil;
    NSString* bString = nil;
    
    NSArray *patternType = @[@[@"(\\w)(\\w)(\\w)",@[@"$1$1",@"$2$2",@"$3$3"]],@[@"(\\w{2})(\\w{2})(\\w{2})",@[@"$1",@"$2",@"$3"]]];
    
    if (cString.length == 3) {
        rString = [self getHexSubStr:cString pattern:patternType[0][0] match:patternType[0][1][0]];
        gString = [self getHexSubStr:cString pattern:patternType[0][0] match:patternType[0][1][1]];
        bString = [self getHexSubStr:cString pattern:patternType[0][0] match:patternType[0][1][2]];
    }else{
        rString = [self getHexSubStr:cString pattern:patternType[1][0] match:patternType[1][1][0]];
        gString = [self getHexSubStr:cString pattern:patternType[1][0] match:patternType[1][1][1]];
        bString = [self getHexSubStr:cString pattern:patternType[1][0] match:patternType[1][1][2]];
    }
    
    
    unsigned int r, g, b;
    
    // Scan values
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:alpha];
}

+ (NSString *) getHexSubStr:(NSString *) str pattern: (NSString *)pattern match:(NSString *) match{
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:NULL];
    return [regx stringByReplacingMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:match];
}


@end
