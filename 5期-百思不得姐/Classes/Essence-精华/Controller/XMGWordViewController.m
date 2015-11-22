//
//  XMGWordViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/16.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGWordViewController.h"

@interface XMGWordViewController ()

@end

@implementation XMGWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:[[UISwitch alloc] init]];
    // self.type = XMGTopicTypeWord;
}

- (XMGTopicType)type
{
    return XMGTopicTypeWord;
}
@end
