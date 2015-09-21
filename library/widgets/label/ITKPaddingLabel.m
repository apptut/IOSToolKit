//
//  ITKPaddingLabel.m
//  Muse
//
//  Created by liangqi on 15/5/25.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "ITKPaddingLabel.h"

@implementation ITKPaddingLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _paddingLeft = 4;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(0, self.paddingLeft, 0, self.paddingLeft))];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    return CGRectInset([self.attributedText boundingRectWithSize:CGSizeMake(999, 999)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil], -self.paddingLeft, 0);
}

- (void)setPaddingLeft:(CGFloat)left{
    _paddingLeft = left;
    [self setNeedsDisplay];
}
@end
