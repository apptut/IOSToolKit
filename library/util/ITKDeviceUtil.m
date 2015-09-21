//
//  ITKDeviceUtil.m
//  yiyou
//
//  Created by liangqi on 15/6/28.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKDeviceUtil.h"
#import <A0SimpleKeychain.h>
#import <UIKit/UIKit.h>
#import "NSDate+ITK_Time.h"

static NSString* const kAppUUidKey = @"com.h5shuo.H5Shuo.uuidKey";

@implementation ITKDeviceUtil

+ (NSString *) appVersionName{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) appVersionBuild{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *) appUUID{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* uuid = [userDefaults objectForKey:kAppUUidKey];
    if (!uuid) {
        // 尝试从keychain中获取
        uuid = [[A0SimpleKeychain keychain] stringForKey:kAppUUidKey];
        if (!uuid) {
            uuid = @"";
        }else{
            // 重新存储一次
            [userDefaults setObject:uuid forKey:kAppUUidKey];
            [userDefaults synchronize];
        }
    }
    return uuid;
}

+ (void) setupUUID{
    if (![[A0SimpleKeychain keychain] stringForKey:kAppUUidKey]) {
        NSString *uuid = [NSUUID UUID].UUIDString;
        
        // 存储一份到keychain
        [[A0SimpleKeychain keychain] setString:uuid forKey:kAppUUidKey];
        
        // 存储一份到用户数据表中
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:uuid forKey:kAppUUidKey];
        [userDefaults synchronize];
    }
}

+ (NSDictionary *) networkBaseParams{

    UIDevice* device = [UIDevice currentDevice];
    return @{
             @"systemName":device.systemName,
             @"systemVersion":device.systemVersion,
             @"appVersion":[self appVersionName],
             @"appNum":[self appVersionBuild],
             @"phoneModel":device.model,
             @"buindId":[NSBundle mainBundle].bundleIdentifier,
             @"uuid":[self appUUID],
             @"t":[NSNumber numberWithLong:[NSDate itk_timestampNow]]
             };
}

+ (NSString *) webviewUserAgent{
    UIDevice* device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"H5Shuo/%@ (%@; IOS %@) MicroMessenger",[self appVersionName],device.model,device.systemVersion];
}

@end
