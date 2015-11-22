//
//  XMGVoiceViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/16.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGVoiceViewController.h"

@interface XMGVoiceViewController ()

@end

@implementation XMGVoiceViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    // self.type = XMGTopicTypeVoice;
}

- (XMGTopicType)type
{
    return XMGTopicTypeVoice;
}

@end
