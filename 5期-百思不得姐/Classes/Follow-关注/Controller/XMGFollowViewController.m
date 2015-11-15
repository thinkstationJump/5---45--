//
//  XMGFollowViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGFollowViewController.h"
#import "XMGRecommendFollowViewController.h"
#import "XMGLoginRegisterViewController.h"

@interface XMGFollowViewController ()
/** 文本框 */
@property (nonatomic, weak) UITextField *textField;
@end

@implementation XMGFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGCommonBgColor;
    
    // 标题(不建议使用self.title属性)
    self.navigationItem.title = @"我的关注";
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(followClick)];
    
    UITextField *textField = [[UITextField alloc] init];
//    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.frame = CGRectMake(100, 100, 150, 25);
    textField.placeholder = @"请输入手机号";
    textField.placeholderColor = [UIColor orangeColor];
    [self.view addSubview:textField];
    self.textField = textField;
    
    UITextField *textField2 = [[UITextField alloc] init];
    textField2.backgroundColor = [UIColor whiteColor];
    textField2.frame = CGRectMake(100, 200, 150, 25);
    textField2.placeholder = @"请输入手机号";
    [self.view addSubview:textField2];
}

- (IBAction)loginRegister {
    self.textField.placeholderColor = nil;
    
    NSLog(@"%@", self.textField.placeholderColor);
    
//    XMGLoginRegisterViewController *loginRegister = [[XMGLoginRegisterViewController alloc] init];
//    [self presentViewController:loginRegister animated:YES completion:nil];
}

- (void)followClick
{
    XMGLogFunc
    
    XMGRecommendFollowViewController *follow = [[XMGRecommendFollowViewController alloc] init];
    [self.navigationController pushViewController:follow animated:YES];
}

@end
