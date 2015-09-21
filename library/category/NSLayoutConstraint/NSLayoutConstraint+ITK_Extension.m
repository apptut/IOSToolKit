//
//  NSLayoutConstraint+ITK_Extension.m
//  yiyou
//
//  Created by liangqi on 15/6/8.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "NSLayoutConstraint+ITK_Extension.h"

@implementation NSLayoutConstraint (ITK_Extension)

+ (void) itk_centerVertical:(UIView *) fromItem toItem:(UIView *)toItem{
    if (fromItem.translatesAutoresizingMaskIntoConstraints) {
        fromItem.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *vetical = [NSLayoutConstraint constraintWithItem:fromItem attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [toItem addConstraint:vetical];
}

+ (void) itk_centerHorizontal:(UIView *) fromItem toItem:(UIView *)toItem{
    if (fromItem.translatesAutoresizingMaskIntoConstraints) {
        fromItem.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:fromItem attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:toItem attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [toItem addConstraint:constraint];
}

+ (void) itk_center:(UIView *) fromItem toItem:(UIView *)toItem{
    if (fromItem.translatesAutoresizingMaskIntoConstraints) {
        fromItem.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    // position to parent view
    [self itk_centerVertical:fromItem toItem:toItem];
    [self itk_centerHorizontal:fromItem toItem:toItem];
    
    // self position
    [self itk_wrapContent:fromItem];
}

+ (void) itk_wrapContent: (UIView *) fromItem{
    if (fromItem.translatesAutoresizingMaskIntoConstraints) {
        fromItem.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *constraintHeight = [NSLayoutConstraint constraintWithItem:fromItem attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0 constant:fromItem.frame.size.height];
    [fromItem addConstraint:constraintHeight];
    
    NSLayoutConstraint *constaintWidth = [NSLayoutConstraint constraintWithItem:fromItem attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0 constant:fromItem.frame.size.width];
    [fromItem addConstraint:constaintWidth];
}
@end
