//
//  ITKCircleImageView.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/24.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKCircleImageView.h"
#import "UIColor+ITK_HexColor.h"

@implementation ITKCircleImageView

#pragma mark - 类方法
+ (void) circleImageViewWithName:(NSString *)imageName{
    
}

+ (void) circleImageViewWithName:(NSString *)imageName borderColor:(NSString *)borderColor borderWith:(CGFloat)borderWith{
    
}

+ (void) circleImageViewWithName:(NSString *)imageName borderColor:(NSString *)borderColor  borderWith:(CGFloat)borderWith borderOpacity:(CGFloat)opacity{
    
}


+ (void) circleImageViewWithImage:(UIImage *)image{
    
}

#pragma mark - 初始化方法

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [super setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void) drawRect:(CGRect)rect{
    CGRect border = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetFillColorWithColor(context, [UIColor itk_colorWithHexString:@"#ffffff" withAlpha:0.5].CGColor);
    CGContextAddArc(context, self.center.x, self.center.y, border.size.width / 2, 0,2 * M_PI, 0);
    CGContextFillPath(context);
    
    CGRect imageBg = CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);
    CGContextAddEllipseInRect(context, imageBg);
    CGContextClip(context);
    
    UIImage* cover = [UIImage imageNamed:@"avatar"];
    
    [cover drawInRect:CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10)];

}

@end
