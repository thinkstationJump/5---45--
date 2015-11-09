//
//  XMGLoginRegisterTextField.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/9.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGLoginRegisterTextField.h"

@implementation XMGLoginRegisterTextField

- (void)awakeFromNib
{
    // 设置光标颜色
    self.tintColor = [UIColor whiteColor];
    // 设置占位文字颜色
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
}

@end
