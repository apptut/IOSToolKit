//
//  UIScrollView+ITK_Position.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "UIScrollView+ITK_Position.h"

@implementation UIScrollView (ITK_Position)

- (CGFloat)itk_insetLeft{
    return self.contentInset.left;
}

- (void)setItk_insetLeft:(CGFloat)itk_insetLeft{
    UIEdgeInsets inset = self.contentInset;
    inset.left= itk_insetLeft;
    self.contentInset = inset;
}

- (CGFloat)itk_insetBottom{
    return self.contentInset.bottom;
}

- (void)setItk_insetBottom:(CGFloat)itk_insetBottom{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = itk_insetBottom;
    self.contentInset = inset;
}

- (void)setItk_insetTop:(CGFloat)itk_insetTop{
    UIEdgeInsets inset = self.contentInset;
    inset.top = itk_insetTop;
    self.contentInset = inset;
}

- (CGFloat)itk_insetTop{
    return self.contentInset.top;
}

- (CGFloat)itk_insetRight
{
    return self.contentInset.right;
}

- (void)setItk_insetRight:(CGFloat)itk_insetRight{
    UIEdgeInsets inset = self.contentInset;
    inset.right = itk_insetRight;
    self.contentInset = inset;
}

- (CGFloat)itk_offsetX
{
    return self.contentOffset.x;
}

- (void)setItk_offsetX:(CGFloat)itk_offsetX{
    CGPoint offset = self.contentOffset;
    offset.x = itk_offsetX;
    self.contentOffset = offset;
}

- (void)setItk_offsetY:(CGFloat)itk_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = itk_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)itk_offsetY
{
    return self.contentOffset.y;
}

- (void)setItk_contentSizeW:(CGFloat)itk_contentSizeW
{
    CGSize size = self.contentSize;
    size.width = itk_contentSizeW;
    self.contentSize = size;
}

- (CGFloat)itk_contentSizeW
{
    return self.contentSize.width;
}

- (void)setItk_contentSizeH:(CGFloat)itk_contentSizeH
{
    CGSize size = self.contentSize;
    size.height = itk_contentSizeH;
    self.contentSize = size;
}

- (CGFloat)itk_contentSizeH
{
    return self.contentSize.height;
}

@end
