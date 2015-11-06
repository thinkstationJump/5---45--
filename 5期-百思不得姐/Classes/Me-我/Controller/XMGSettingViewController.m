//
//  XMGSettingViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingViewController.h"
#import "XMGTestViewController.h"

@interface XMGSettingViewController ()

@end

@implementation XMGSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XMGTestViewController *test = [[XMGTestViewController alloc] init];
    test.view.backgroundColor = XMGRandomColor;
    test.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test animated:YES];
}

@end
