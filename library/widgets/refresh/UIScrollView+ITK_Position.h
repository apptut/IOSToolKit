//
//  UIScrollView+ITK_Position.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ITK_Position)

// 上边距偏移
@property (nonatomic,assign) CGFloat itk_insetTop;

@property (nonatomic,assign) CGFloat itk_insetBottom;

@property (nonatomic,assign) CGFloat itk_insetLeft;

@property (nonatomic,assign) CGFloat itk_insetRight;

@property (assign, nonatomic) CGFloat itk_offsetX;
@property (assign, nonatomic) CGFloat itk_offsetY;

@property (assign, nonatomic) CGFloat itk_contentSizeW;
@property (assign, nonatomic) CGFloat itk_contentSizeH;

@end
