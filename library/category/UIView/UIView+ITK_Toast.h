//
//  UIView+Toast.h
//  Muse
//
//  Created by liangqi on 15/5/20.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  toast位置
 */
typedef NS_ENUM(NSUInteger, ITKToastPosition){
    /**
     *  center center
     */
    ITKToastPositionCenter,
    /**
     *  center top
     */
    ITKToastPositionCenterTop,
    /**
     *  center bottom
     */
    ITKToastPositionCenterBottom
};

@interface UIView (ITK_Toast)

/**
 *  显示toast消息
 *
 *  @param message 消息内容
 */
- (void) itk_make:(NSString *) message;


/**
 *  显示toast消息，并指定toast屏幕显示位置
 *
 *  @param message  消息内容
 *  @param position 所在位置
 */
- (void) itk_make:(NSString *)message position:(ITKToastPosition) position;


/**
 *  显示toast消息，带回调函数
 *
 *  @param message  显示内容
 *  @param complete 动画执行完毕
 */
- (void) itk_make:(NSString *)message complete:(void (^)())complete;

@end
