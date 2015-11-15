//
//  XMGMeFooterView.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/15.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGMeFooterView.h"
#import "XMGMeSquare.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "XMGMeSquareButton.h"

@interface XMGMeFooterView()
/** 存放所有模型的字典 */
//@property (nonatomic, strong) NSMutableDictionary<NSString *, XMGMeSquare *> *allSquares;
@end

@implementation XMGMeFooterView

//- (NSMutableDictionary<NSString *,XMGMeSquare *> *)allSquares
//{
//    if (!_allSquares) {
//        _allSquares = [NSMutableDictionary dictionary];
//    }
//    return _allSquares;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
            // 字典数组 -> 模型数组
            NSArray *squares = [XMGMeSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            // 根据模型数据创建对应的控件
            [self createSquares:squares];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            XMGLog(@"请求失败 - %@", error);
        }];
    }
    return self;
}

/**
 *  根据模型数据创建对应的控件
 */
- (void)createSquares:(NSArray *)squares
{
    // 方块个数
    NSUInteger count = squares.count;
    
    // 方块的尺寸
    int maxColsCount = 4; // 一行的最大列数
    CGFloat buttonW = self.xmg_width / maxColsCount;
    CGFloat buttonH = buttonW;
    
    // 创建所有的方块
    for (NSUInteger i = 0; i < count; i++) {
        // i位置对应的模型数据
        XMGMeSquare *square = squares[i];
        
        // 创建按钮
        XMGMeSquareButton *button = [XMGMeSquareButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 设置frame
        button.xmg_x = (i % maxColsCount) * buttonW;
        button.xmg_y = (i / maxColsCount) * buttonH;
        button.xmg_width = buttonW;
        button.xmg_height = buttonH;
        
        // 设置数据
        button.square = square;
        
        // 存储模型数据
//        self.allSquares[button.currentTitle] = square;
    }
    
    // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
    self.xmg_height = self.subviews.lastObject.xmg_bottom;
    
    // 设置tableView的contentSize
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    [tableView reloadData]; // 重新刷新数据(会重新计算contentSize)
//    tableView.contentSize = CGSizeMake(0, self.xmg_bottom); // 不靠谱
}

- (void)buttonClick:(XMGMeSquareButton *)button
{
//    XMGMeSquare *square = self.allSquares[button.currentTitle];
    XMGMeSquare *square = button.square;
    
    if ([square.url hasPrefix:@"http"]) { // 利用webView加载url即可
        XMGLog(@"利用webView加载url");
    } else if ([square.url hasPrefix:@"mod"]) { // 另行处理
        if ([square.url hasSuffix:@"BDJ_To_Check"]) {
            XMGLog(@"跳转到[审帖]界面");
        } else if ([square.url hasSuffix:@"BDJ_To_RecentHot"]) {
            XMGLog(@"跳转到[每日排行]界面");
        } else {
            XMGLog(@"跳转到其他界面");
        }
    } else {
        XMGLog(@"不是http或者mod协议的");
    }
}

@end
