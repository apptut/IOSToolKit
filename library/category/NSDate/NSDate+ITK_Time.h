//
//  NSDate+ITK_Time.h
//  Muse
//
//  Created by liangqi on 15/6/3.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ITK_Time)

/**
 *  获取给定时间的当前时间戳毫秒值
 *
 *  @return 毫秒值时间戳
 */
- (long) itk_timestamp;

/**
 *  返回当前时间的时间戳毫秒值
 *
 *  @return 时间戳
 */
+ (long) itk_timestampNow;

/**
 *  转换字符串时间为NSDate，默认时区+0800，如："2010-10-10 10:00:01" => NSDate()
 *
 *  @param format "yy-MM-dd HH:mm:ss"
 *  @param time   2010-10-10 10:00:01
 *
 *  @return NSDate
 */
+ (NSDate *) itk_stringToDate:(NSString *)format time:(NSString *)time;


/**
 *  NSDate => time string such as 2014-10-10
 *
 *  @param format such as yy-MM-dd
 *
 *  @return NSString
 */
- (NSString *) itk_toString:(NSString *)format;
@end
