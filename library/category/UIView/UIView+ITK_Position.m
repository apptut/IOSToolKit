//
//  UIView+ITK_Position.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "UIView+ITK_Position.h"

@implementation UIView (ITK_Position)

- (CGFloat)itk_center_x{
    return self.center.x;
}

- (void)setItk_center_x:(CGFloat)itk_center_x{
    CGPoint orgCenter = self.center;
    orgCenter.x = itk_center_x;
    self.center = orgCenter;
}

- (void)setItk_x:(CGFloat)itk_x
{
    CGRect originFrame = self.frame;
    originFrame.origin.x = itk_x;
    self.frame = originFrame;
}

- (CGFloat)itk_x
{
    return self.frame.origin.x;
}

- (void)setItk_y:(CGFloat)itk_y
{
    CGRect originFrame = self.frame;
    originFrame.origin.y = itk_y;
    self.frame = originFrame;
}

- (CGFloat)itk_y
{
    return self.frame.origin.y;
}

- (void)setItk_width:(CGFloat)itk_width
{
    CGRect originFrame = self.frame;
    originFrame.size.width = itk_width;
    self.frame = originFrame;
}

- (CGFloat)itk_width
{
    return self.frame.size.width;
}

- (void)setItk_height:(CGFloat)itk_height
{
    CGRect originFrame = self.frame;
    originFrame.size.height = itk_height;
    self.frame = originFrame;
}
- (CGFloat)itk_height
{
    return self.frame.size.height;
}
@end
