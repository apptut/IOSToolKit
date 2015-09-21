//
//  NSLayoutConstraint+ITK_Extension.h
//  yiyou
//
//  Created by liangqi on 15/6/8.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSLayoutConstraint (ITK_Extension)


+ (void) itk_centerVertical:(UIView *) fromItem toItem:(UIView *)toItem;

+ (void) itk_centerHorizontal:(UIView *) fromItem toItem:(UIView *)toItem;

+ (void) itk_center:(UIView *) fromItem toItem:(UIView *)toItem;


/**
 *  使用UIView元素本身固定宽度、高度作为约束
 *
 *  @param fromItem 需要约束的对象
 */
+ (void) itk_wrapContent: (UIView *) fromItem;
@end
