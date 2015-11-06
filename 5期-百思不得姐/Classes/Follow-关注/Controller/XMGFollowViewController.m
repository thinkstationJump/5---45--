//
//  XMGFollowViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGFollowViewController.h"

@interface XMGFollowViewController ()

@end

@implementation XMGFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGCommonBgColor;
    
    // 标题(不建议使用self.title属性)
    self.navigationItem.title = @"我的关注";
    // 左边
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(followClick) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)followClick
{
    XMGLogFunc
}

@end
