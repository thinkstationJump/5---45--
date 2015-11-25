//
//  XMGRefreshFooter.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGRefreshFooter.h"

@implementation XMGRefreshFooter

- (void)prepare
{
    [super prepare];
    
    self.stateLabel.textColor = [UIColor redColor];
    
    [self addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    [self setTitle:@"没有数据啦,不要再上拉了" forState:MJRefreshStateNoMoreData];
    
    // 刷新控件出现一半就会进入刷新状态
//    self.triggerAutomaticallyRefreshPercent = 0.5;
    
    // 不要自动刷新
//    self.automaticallyRefresh = NO;
}

@end
