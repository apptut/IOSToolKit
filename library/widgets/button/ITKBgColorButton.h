//
//  ITKBgColorButton.h
//  yiyou
//
//  Created by liangqi on 15/6/25.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITKBgColorButton : UIButton
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;
@end
