//
//  ITKDeviceUtil.h
//  yiyou
//
//  Created by liangqi on 15/6/28.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ITKDeviceUtil : NSObject

/**
 *  获取app版本号
 *
 *  @return such as 1.0.0
 */
+ (NSString *) appVersionName;


/**
 *  获取app build number string
 *
 *  @return such as 1
 */
+ (NSString *) appVersionBuild;


/**
 *  获取当前唯一的识别id
 *
 *  @return UUID 字符串
 */
+ (NSString *) appUUID;

/**
 *  初始化app唯一识别id
 */
+ (void) setupUUID;


/**
 *  网络请求基础参数配置
 *
 *  @return NSDictionary
 */
+ (NSArray *) networkBaseParams;

/**
 *  获取webview 自定义User Agent
 *
 *  @return NSString
 */
+ (NSString *) webviewUserAgent;

@end
