//
//  ITKCircleImageView.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/24.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITKCircleImageView : UIView

+ (void) circleImageViewWithName:(NSString *)imageName;

+ (void) circleImageViewWithName:(NSString *)imageName borderColor:(NSString *)borderColor borderWith:(CGFloat)borderWith;

+ (void) circleImageViewWithName:(NSString *)imageName borderColor:(NSString *)borderColor  borderWith:(CGFloat)borderWith borderOpacity:(CGFloat)opacity;


+ (void) circleImageViewWithImage:(UIImage *)image;


@end
