//
//  UIView+ITK_Position.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ITK_Position)

// UIView frame x坐标
@property(nonatomic,assign) CGFloat itk_x;

// UIView frame y坐标
@property(nonatomic,assign) CGFloat itk_y;

// UIView frame width
@property(nonatomic,assign) CGFloat itk_width;

// UIView frame height
@property(nonatomic,assign) CGFloat itk_height;

// UIView frame center x
@property(nonatomic,assign) CGFloat itk_center_x;

@end
