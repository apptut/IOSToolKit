//
//  NSString+ITK_Validate.m
//  Muse
//
//  Created by liangqi on 15/6/2.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "NSString+ITK_Validate.h"

@implementation NSString (ITK_Validate)


- (BOOL) itk_isMobile{
    NSString *pattern = @"1{1}[0-9]{10}";
    return [self itk_isMatchRegex:pattern];
}


- (BOOL) itk_isEmail{
    NSString *pattern = @"([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}";
    return [self itk_isMatchRegex:pattern];
}

- (BOOL) itk_isMatchRegex:(NSString *)regex{
    NSError *error = nil;
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSRange range = [exp rangeOfFirstMatchInString:self options:NSMatchingReportCompletion    range:NSMakeRange(0, self.length)];
        return range.length > 0;
    }
    return NO;
}

/**
 *  检测字符串是否为空
 *
 *  @return Valid == YES
 */
- (BOOL) itk_isEmpty{
    NSString* trimStr = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    return trimStr.length == 0;
}

/**
 *  检测字符最大不能超过上限
 *
 *  @param maxLength int
 *
 *  @return Valid == YES
 */
- (BOOL) itk_max:(int)maxLength{
    NSString* trimStr = [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    return trimStr.length <= maxLength;
}

@end
