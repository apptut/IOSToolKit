//
//  ITKPaddingTextField.m
//  H5Shuo
//
//  Created by liangqi on 15/9/15.
//  Copyright (c) 2015年 h5shuo. All rights reserved.
//

#import "ITKPaddingTextField.h"

@implementation ITKPaddingTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _paddingLeft = 4;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds,_paddingLeft,0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, _paddingLeft, 0);
}

- (void)setPaddingLeft:(CGFloat)left{
    _paddingLeft = left;
    [self setNeedsDisplay];
}

@end
