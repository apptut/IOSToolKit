//
//  UIView+Toast.m
//  Muse
//
//  Created by liangqi on 15/5/20.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "UIView+ITK_Toast.h"


// 默认toast 显示时间
static const NSTimeInterval MuseToastDefaultDuration  = 2.0;

// 显示动画时间
static const NSTimeInterval MuseToastFadeDuration = 0.8;

// toast圆角效果
static const CGFloat MuseToastCornerRadius = 5.0;

// toast透明度效果
static const CGFloat MuseToastOpacity = 0.7;

// toast最大显示文字行数
static const CGFloat MuseToastMaxMessageLines = 0;

// toast字体大小
static const CGFloat MuseToastFontSize = 13.0;

// toast容器宽高
static const CGFloat MuseToastMaxWidth            = 0.8;
static const CGFloat MuseToastMaxHeight           = 0.8;

// 内边距
static const CGFloat MuseToastHorizontalPadding   = 10.0;
static const CGFloat MuseToastVerticalPadding     = 10.0;



@implementation UIView (ITK_Toast)


- (void) itk_make:(NSString *) message{
    [self itk_make:message duration:MuseToastDefaultDuration];
}

- (void) itk_show:(UIView *)layout duration:(NSTimeInterval) duration{
    
    // 设置toast位置
    layout.center = [self getLayoutPositoin:nil withToast:layout];
    
    [self addSubview:layout];
    
    [UIView animateWithDuration:MuseToastFadeDuration delay:0.0 options:(UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         layout.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:layout repeats:NO];
                     }];
}



- (void) itk_make:(NSString *) message duration:(NSTimeInterval)duration{
    UIView *layout = [self getToastLayout:message];
    [self itk_show:layout duration:duration];
}


- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)hideToast:(UIView *)toast {
    [UIView animateWithDuration:MuseToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}



- (UIView *) getToastLayout:(NSString *) message{
    
    if (!message) return nil;
 
    UIView *layoutView = [[UIView alloc] init];
    
    // 控件位置
    layoutView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    
    // 控件圆角
    layoutView.layer.cornerRadius = MuseToastCornerRadius;
    
    // 设置背景透明度
    layoutView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:MuseToastOpacity];
    
    
    // 初始化显示字符串控件
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = MuseToastMaxMessageLines;
    label.font = [UIFont systemFontOfSize:MuseToastFontSize];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.alpha = 1.0;
    label.text = message;
    
    
    CGSize maxSizeMessage = CGSizeMake(self.bounds.size.width * MuseToastMaxWidth, self.bounds.size.height * MuseToastMaxHeight);
    CGSize expectedSizeMessage = [self sizeForString:message font:label.font constrainedToSize:maxSizeMessage lineBreakMode:label.lineBreakMode];
    label.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);

    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(label != nil) {
        messageWidth = label.bounds.size.width;
        messageHeight = label.bounds.size.height;
        messageLeft = MuseToastHorizontalPadding;
        messageTop = MuseToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat longerWidth = messageWidth;
    CGFloat longerLeft = messageHeight;
    
    CGFloat wrapperWidth = longerLeft + longerWidth + MuseToastHorizontalPadding;
    CGFloat wrapperHeight = messageTop + messageHeight + MuseToastVerticalPadding;
    
    layoutView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(label != nil) {
        label.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [layoutView addSubview:label];
    }
    
    return layoutView;
}


// 设置toast显示位置，默认显示在页面底部
- (CGPoint)getLayoutPositoin:(id)point withToast:(UIView *)toast {
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - MuseToastVerticalPadding);
}


- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

@end
