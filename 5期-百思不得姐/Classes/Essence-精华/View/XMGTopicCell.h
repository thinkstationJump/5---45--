//
//  XMGTopicCell.h
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/19.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMGTopic;

@interface XMGTopicCell : UITableViewCell
/** 帖子模型数据 */
@property (nonatomic, strong) XMGTopic *topic;
@end
