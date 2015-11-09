//
//  XMGLoginRegisterTextField.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/9.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGLoginRegisterTextField.h"

static NSString * const XMGPlaceholderColorKey = @"placeholderLabel.textColor";

@interface XMGLoginRegisterTextField() <UITextFieldDelegate>

@end

@implementation XMGLoginRegisterTextField

- (void)awakeFromNib
{
    // 设置光标颜色
    self.tintColor = [UIColor whiteColor];
    // 设置默认的占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:XMGPlaceholderColorKey];
    
    self.delegate = self;
}

#pragma mark - <UITextFieldDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self setValue:[UIColor whiteColor] forKeyPath:XMGPlaceholderColorKey];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setValue:[UIColor grayColor] forKeyPath:XMGPlaceholderColorKey];
}
@end
