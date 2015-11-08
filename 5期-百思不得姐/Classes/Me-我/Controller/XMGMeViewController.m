//
//  XMGMeViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGMeViewController.h"
#import "XMGSettingViewController.h"

@interface XMGMeViewController ()

@end

@implementation XMGMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGCommonBgColor;
    // 标题
    self.navigationItem.title = @"我的";
    // 右边-设置
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    // 右边-月亮
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem, moonItem];
}

- (void)settingClick
{
    XMGLogFunc
    
    XMGSettingViewController *setting = [[XMGSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (void)moonClick
{
    XMGLogFunc
}

@end
