//
//  ITKAlignLabel.m
//  yiyou
//
//  Created by liangqi on 15/6/7.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKAlignLabel.h"

@implementation ITKAlignLabel

-(void) drawTextInRect:(CGRect)inFrame {
    CGRect draw = [self textRectForBounds:inFrame limitedToNumberOfLines:[self numberOfLines]];
    draw.origin = CGPointZero;
    [super drawTextInRect:draw];
}
@end
