//
//  NSString+ITK_Size.h
//  Muse
//
//  Created by liangqi on 15/5/25.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (ITK_Size)

/**
 *  获取传入字符串渲染的frame大小
 *
 *  @param font            字符串字体
 *  @param constrainedSize 约束的尺寸guize
 *  @param lineBreakMode   文字折行模式
 *
 *  @return 尺寸宽高
 */
- (CGSize) itk_sizeForStringWith:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode ;


/**
 *  计算指定字体大小的box大小
 *
 *  @param fontSize            字符串字体
 *  @param constrainedSize 约束的尺寸guize
 *
 *  @return 尺寸宽高
 */

- (CGSize) itk_sizeForStringWith:(CGFloat)fontSize constrainedToSize:(CGSize)constrainedSize;
@end