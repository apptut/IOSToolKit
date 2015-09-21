//
//  NSString+ITK_Size.m
//  Muse
//
//  Created by liangqi on 15/5/25.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "NSString+ITK_Size.h"

@implementation NSString (ITK_Size)

- (CGSize) itk_sizeForStringWith:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    if (self.length == 0) {
        return CGSizeMake(0, 0);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [self boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    
}

- (CGSize)itk_sizeForStringWith:(CGFloat)fontSize constrainedToSize:(CGSize)constrainedSize{
    return [self itk_sizeForStringWith:[UIFont systemFontOfSize:fontSize] constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
}

@end