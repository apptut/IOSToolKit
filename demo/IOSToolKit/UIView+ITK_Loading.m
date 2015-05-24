//
//  UIView+ITK_Loading.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/23.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "UIView+ITK_Loading.h"
#import "UIColor+ITK_HexColor.h"


// message字体大小
static const CGFloat ITKFontSize = 13.0;

// message距离loading图片的间距
static const CGFloat ITKMessageMarginTop = 8.0;

static NSString* ITKMessageColor = @"#666666";

@implementation UIView (ITK_Loading)


- (void) itk_showLoading:(NSString *)message{
    
    UIView* layoutView = [self getLayout:message];
    [self addSubview:layoutView];
    
    // 设置autolayout
    layoutView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* flvCenterV = [NSString stringWithFormat:@"V:[superView]-(<=1)-[layoutView(==%d)]",(int)layoutView.bounds.size.width];
    NSString* flvCenterH = [NSString stringWithFormat:@"H:[superView]-(<=1)-[layoutView(==%d)]",(int)layoutView.bounds.size.height];
    NSArray* centerV = [NSLayoutConstraint constraintsWithVisualFormat: flvCenterV options:NSLayoutFormatAlignAllCenterX metrics:nil views:@{@"superView":self,@"layoutView":layoutView}];
    NSArray *centerH = [NSLayoutConstraint constraintsWithVisualFormat:flvCenterH options:NSLayoutFormatAlignAllCenterY metrics:nil views:@{@"superView":self,@"layoutView":layoutView}];
    
    [self addConstraints:centerV];
    [self addConstraints:centerH];
    
}

- (void) itk_showLoading{
    [self itk_showLoading:nil];
}


- (UIView *) getLayout:(NSString *) message{
    UIView *layoutView = [[UIView alloc] init];
    
    UILabel *info = nil;
    
    UIImage* loadingFirst = [UIImage imageNamed:@"global_network_loading_1"];
    
    if (!loadingFirst) {
        @throw [[NSException alloc] initWithName:@"Loading View Exception" reason:@"loading view must set images array to imageView" userInfo:nil];
    }
    
    // loading动画逐帧图片
    NSArray* loadingImages = @[
                               loadingFirst,
                               [UIImage imageNamed:@"global_network_loading_2"]
                               ];
    
    // 获取loading图片宽度
    CGFloat imageWith = loadingFirst.size.width;
    CGFloat imageHeight = loadingFirst.size.height;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWith, imageHeight)];
    imageView.animationImages = loadingImages;
    imageView.animationDuration = 0.3;
    [imageView startAnimating];
    
    [layoutView addSubview:imageView];
    
    CGFloat layoutBoxWith,layoutBoxHeight;
    
    if (message != nil) {
        info = [[UILabel alloc] init];
        info.text = message;
        info.font = [UIFont systemFontOfSize:ITKFontSize];
        info.textColor = [UIColor itk_colorWithHexString:ITKMessageColor];
        info.numberOfLines = 0;
        
        CGSize maxSizeMessage = CGSizeMake(self.bounds.size.width * 0.8, self.bounds.size.height * 0.8);
        CGSize expectedSizeMessage = [self sizeForString:message font:info.font constrainedToSize:maxSizeMessage lineBreakMode:info.lineBreakMode];
        
        info.frame = CGRectMake(0.0, imageHeight + ITKMessageMarginTop, expectedSizeMessage.width, expectedSizeMessage.height);
        
        layoutBoxWith = MAX(imageWith, expectedSizeMessage.width);
        layoutBoxHeight = CGRectGetMaxY(info.frame);
        
        info.center = CGPointMake(layoutBoxWith/2, info.center.y);
        
        [layoutView addSubview:info];

    }else{
        layoutBoxWith = imageWith;
        layoutBoxHeight = imageHeight;
    }
    
    layoutView.frame = CGRectMake(0.0, 0.0, layoutBoxWith, layoutBoxHeight);
    
    return layoutView;
}

- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = lineBreakMode;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}
@end
