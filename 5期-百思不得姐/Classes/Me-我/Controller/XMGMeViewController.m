//
//  XMGMeViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGMeViewController.h"

@interface XMGMeViewController ()

@end

@implementation XMGMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGCommonBgColor;
    // 标题
    self.navigationItem.title = @"我的";
    // 右边-设置
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
    [settingButton setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    [settingButton sizeToFit];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    // 右边-月亮
    UIButton *moonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moonButton setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
    [moonButton setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
    [moonButton addTarget:self action:@selector(moonClick) forControlEvents:UIControlEventTouchUpInside];
    [moonButton sizeToFit];
    UIBarButtonItem *moonItem = [[UIBarButtonItem alloc] initWithCustomView:moonButton];
    
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

- (void)settingClick
{
    XMGLogFunc
}

- (void)moonClick
{
    XMGLogFunc
}

@end
