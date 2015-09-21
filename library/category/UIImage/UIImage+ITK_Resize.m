//
//  UIImage+Extension.m
//  Muse
//
//  Created by liangqi on 15/5/15.
//  
//

#import "UIImage+ITK_Resize.h"

@implementation UIImage (ITK_Resize)

- (UIImage *) itk_resizbaleImage:(NSString *)img{
    
    // 设置表单区域背景拉伸效果
    UIImage *boxBg = [UIImage imageNamed:img];
    
    int top = boxBg.size.height * 0.5;
    int left = boxBg.size.width * 0.5;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, top, left);
    
    // 指定为拉伸模式，伸缩后重新赋值
    return [boxBg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
}
@end
