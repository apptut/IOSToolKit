//
//  ITKPlaceholderTextView.m
//  yiyou
//
//  Created by liangqi on 15/6/23.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKPlaceholderTextView.h"
#import "UIColor+ITK_HexColor.h"
#import "ITKAlignLabel.h"

@interface ITKPlaceholderTextView(){
    ITKAlignLabel *_placeholderLabel;
}
@end

@implementation ITKPlaceholderTextView


- (void)setPlaceholder:(NSString *)placeholder{
    if (!_placeholder) {
        _placeholder = placeholder;
        [self configPlaceholder];
    }
}

- (void) configPlaceholder{
    NSNotificationCenter *notify = [NSNotificationCenter defaultCenter];
    
    [notify addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    CGRect labelFrame = CGRectMake(5, 8, self.bounds.size.width, self.bounds.size.height);
    _placeholderLabel = [[ITKAlignLabel alloc] initWithFrame:labelFrame];
    _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.text = _placeholder;
    _placeholderLabel.textColor = [UIColor itk_colorWithHexString:@"#ccc"];
    _placeholderLabel.font = self.font;
    
    [self addSubview:_placeholderLabel];
    
}

- (void) textDidChange{
    _placeholderLabel.hidden = self.text.length > 0;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
