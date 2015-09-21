//
//  NSDate+ITK_Time.m
//  Muse
//
//  Created by liangqi on 15/6/3.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "NSDate+ITK_Time.h"

@implementation NSDate (ITK_Time)

- (long)itk_timestamp{
    return (long)([self timeIntervalSince1970]);
}

+ (long)itk_timestampNow{
    return (long)([[NSDate date] timeIntervalSince1970] * 1000);
}

+ (NSDate *) itk_stringToDate:(NSString *)format time:(NSString *)time{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [self timeZone];
    formatter.dateFormat = format;
    return [formatter dateFromString:time];
}

- (NSString *) itk_toString:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSDate timeZone];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}


#pragma mark - 私有方法
+ (NSTimeZone *) timeZone{
    return [NSTimeZone timeZoneWithName:@"GMT"];
}
@end
