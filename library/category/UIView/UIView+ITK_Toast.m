//
//  UIView+Toast.m
//  Muse
//
//  Created by liangqi on 15/5/20.
//  Copyright (c) 2015年 duoqu. All rights reserved.
//

#import "UIView+ITK_Toast.h"
#import <objc/runtime.h>


// 默认toast 显示时间
static const NSTimeInterval MuseToastDefaultDuration  = 2.0;

// 显示动画时间
static const NSTimeInterval MuseToastFadeDuration = 0.4;

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
static const CGFloat MuseToastVerticalPadding     = 5.0;

// 回调key
static const NSString * kRuntimeCallbackKey  = @"callbackKey";


@implementation UIView (ITK_Toast)

- (void)itk_make:(NSString *)message complete:(void (^)())complete{
    [self itk_make:message duration:MuseToastDefaultDuration position:ITKToastPositionCenterBottom complete:complete];
}

- (void) itk_make:(NSString *) message{
    [self itk_make:message duration:MuseToastDefaultDuration];
}

- (void) itk_make:(NSString *)message position:(ITKToastPosition) position{
    [self itk_make:message duration:MuseToastDefaultDuration position:position complete:nil];
}

- (void) itk_show:(UIView *)layout duration:(NSTimeInterval) duration position:(ITKToastPosition) position complete:(void (^)())complete{
    
    // 禁用autosize，使用autolayout实现
    layout.translatesAutoresizingMaskIntoConstraints = NO;
    layout.alpha = 0.0f;
    
    [self addSubview:layout];
    
    NSLayoutConstraint *hConstraint = nil;
    NSLayoutConstraint *vConstraint = nil;
    
    
    switch (position) {
        case ITKToastPositionCenterBottom:{
            // 水平居中
            hConstraint = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            
            // 页面底部20个点位置
            vConstraint = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-20];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:layout.frame.size.height];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:layout.frame.size.width];
            
            [layout addConstraint:height];
            [layout addConstraint:width];
            break;
        }

        case ITKToastPositionCenter:{
        
            // 水平居中
            hConstraint = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            
            // 垂直居中
            vConstraint = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:layout.frame.size.height];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:layout.frame.size.width];
            
            [layout addConstraint:height];
            [layout addConstraint:width];
            break;
        }
            
        case ITKToastPositionCenterTop:{
            // 水平居中
            hConstraint = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
            
            // 垂直居上20个点
            vConstraint = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:layout.frame.size.height];
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:layout attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:layout.frame.size.width];
            
            [layout addConstraint:height];
            [layout addConstraint:width];
        }
            
    }
    
    [self addConstraint:hConstraint];
    [self addConstraint:vConstraint];
    
    
    [UIView animateWithDuration:MuseToastFadeDuration delay:0.0 options:(UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         layout.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(toastTimerDidFinish:) userInfo:layout repeats:NO];
                         
                         if (complete) {
                             objc_setAssociatedObject(self, &kRuntimeCallbackKey, complete, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }
                     }];
    
    
    
}

- (void) itk_make:(NSString *) message duration:(NSTimeInterval)duration position:(ITKToastPosition) position complete:(void (^)())complete{
    UIView *layout = [self getToastLayout:message];
    [self itk_show:layout duration:duration position:position complete:complete];
}


- (void) itk_make:(NSString *) message duration:(NSTimeInterval)duration{
    [self itk_make:message duration:duration position:ITKToastPositionCenterBottom complete:nil];
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
                         
                         void (^callback)(void) = objc_getAssociatedObject(self, &kRuntimeCallbackKey);
                         if (callback) {
                             callback();
                         }
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
