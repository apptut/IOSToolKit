//
//  ITKBgColorButton.m
//  yiyou
//
//  Created by liangqi on 15/6/25.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKBgColorButton.h"

@interface ITKBgColorButton () {
    NSMutableDictionary* _colors;
}

@end

@implementation ITKBgColorButton

- (void)setBackgroundColor:(UIColor*)backgroundColor forState:(UIControlState)state
{    // If it is normal then set the standard background here
    if (_colors == nil) {
        _colors = [NSMutableDictionary dictionary];
    }

    if (state == UIControlStateNormal) {
        [super setBackgroundColor:backgroundColor];
    }

    // Store the background colour for that state
    [_colors setValue:backgroundColor forKey:[self keyForState:state]];
}

- (UIColor*)backgroundColorForState:(UIControlState)state
{
    return [_colors valueForKey:[self keyForState:state]];
}

- (void)setHighlighted:(BOOL)highlighted
{
    // Do original Highlight
    [super setHighlighted:highlighted];
    // Highlight with new colour OR replace with orignial
    NSString* highlightedKey = [self keyForState:UIControlStateHighlighted];
    UIColor* highlightedColor = [_colors valueForKey:highlightedKey];
    if (highlighted && highlightedColor) {
        [super setBackgroundColor:highlightedColor];
    }
    else {
        // 由于系统在调用setSelected后，会再触发一次setHighlighted，故做如下处理，否则，背景色会被最后一次的覆盖掉。
        if ([self isSelected]) {
            NSString* selectedKey = [self keyForState:UIControlStateSelected];
            UIColor* selectedColor = [_colors valueForKey:selectedKey];
            [super setBackgroundColor:selectedColor];
        }
        else {
            NSString* normalKey = [self keyForState:UIControlStateNormal];
            [super setBackgroundColor:[_colors valueForKey:normalKey]];
        }
    }
}
- (void)setSelected:(BOOL)selected
{
    // Do original Selected
    [super setSelected:selected];
    // Select with new colour OR replace with orignial
    NSString* selectedKey = [self keyForState:UIControlStateSelected];
    UIColor* selectedColor = [_colors valueForKey:selectedKey];
    if (selected && selectedColor) {
        [super setBackgroundColor:selectedColor];
    }
    else {
        NSString* normalKey = [self keyForState:UIControlStateNormal];
        [super setBackgroundColor:[_colors valueForKey:normalKey]];
    }
}
- (NSString*)keyForState:(UIControlState)state
{
    return [NSString stringWithFormat:@"state_%@", @(state)];
}

/**
 *  button disable样式
 *
 *  @param enabled 是否可点击
 */
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];

    NSString* selectedKey = [self keyForState:UIControlStateDisabled];
    UIColor* selectedColor = [_colors valueForKey:selectedKey];
    if (selectedColor) {
        [super setBackgroundColor:selectedColor];
    }
    else {
        NSString* normalKey = [self keyForState:UIControlStateNormal];
        [super setBackgroundColor:[_colors valueForKey:normalKey]];
    }
}

//image btn

- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state
{
    UIImage* imageSteth = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [super setBackgroundImage:imageSteth forState:state];
}

@end
