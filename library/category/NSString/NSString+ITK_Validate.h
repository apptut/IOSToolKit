//
//  NSString+ITK_Validate.h
//  Muse
//
//  Created by liangqi on 15/6/2.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ITK_Validate)

/**
 *  手机号验证
 *
 *  @return valid == YES
 */
- (BOOL) itk_isMobile;


/**
 *  邮箱地址是否合法
 *
 *  @return valid = YES
 */
- (BOOL) itk_isEmail;


/**
 *  是否匹配指定的正则表达式
 *
 *  @param regex 正则表达式
 *
 *  @return Valid == YES
 */
- (BOOL) itk_isMatchRegex:(NSString *)regex;


/**
 *  检测字符串是否为空
 *
 *  @return Valid == YES
 */
- (BOOL) itk_isEmpty;


/**
 *  检测字符最大不能超过上限
 *
 *  @param maxLength int
 *
 *  @return Valid == YES
 */
- (BOOL) itk_max:(int)maxLength;

@end
