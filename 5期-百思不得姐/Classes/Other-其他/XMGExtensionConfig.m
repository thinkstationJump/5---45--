//
//  XMGExtensionConfig.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/20.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGExtensionConfig.h"
#import <MJExtension.h>
#import "XMGTopic.h"
#import "XMGComment.h"

@implementation XMGExtensionConfig

+ (void)load
{
    [XMGTopic mj_setupObjectClassInArray:^NSDictionary *{
        return @{@"top_cmt" : [XMGComment class]};
    }];
    
    [XMGTopic mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"top_cmt" : @"top_cmt[0]"};
    }];
}

@end
