//
//  NSString+ITKFormat.m
//  Muse
//
//  Created by liangqi on 15/6/1.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "NSString+ITKFormat.h"

@implementation NSString (ITKFormat)

- (NSString *)itk_trim{
    NSString* trimStr = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    return trimStr;
}
@end
