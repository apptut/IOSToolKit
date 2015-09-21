//
//  NSDictionary+ITK_Url.h
//  yiyou
//
//  Created by liangqi on 15/6/21.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ITK_Url)


/**
 *  组装url params
 *
 *  @return "key=value&key1=value1"
 */
-(NSString*) urlEncodedString;
@end
