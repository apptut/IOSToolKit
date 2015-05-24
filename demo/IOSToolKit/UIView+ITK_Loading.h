//
//  UIView+ITK_Loading.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/23.
//
//  简单使用UIImageView实现的逐帧动画效果
//
//  使用注意：需要设置 imageView.animationImages NSArray 动画列表
//  
//

#import <UIKit/UIKit.h>

@interface UIView (ITK_Loading)

- (void) itk_showLoading: (NSString *)message;
- (void) itk_showLoading;

@end
