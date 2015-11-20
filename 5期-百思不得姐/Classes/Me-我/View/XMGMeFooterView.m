//
//  XMGMeFooterView.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/15.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGMeFooterView.h"
#import "XMGMeSquare.h"
#import "XMGHTTPSessionManager.h"
#import <MJExtension.h>
#import "XMGMeSquareButton.h"
#import "XMGWebViewController.h"
#import <SafariServices/SafariServices.h>

@interface XMGMeFooterView()
@end

@implementation XMGMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 请求
        [[XMGHTTPSessionManager manager] GET:XMGCommonURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nonnull responseObject) {
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
    NSUInteger maxColsCount = 4; // 一行的最大列数
    CGFloat buttonW = self.xmg_width / maxColsCount;
    CGFloat buttonH = buttonW;
    
    // 创建所有的方块
    for (NSUInteger i = 0; i < count; i++) {
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
        button.square = squares[i];
    }
    
    // 设置footer的高度 == 最后一个按钮的bottom(最大Y值)
    self.xmg_height = self.subviews.lastObject.xmg_bottom;
    
    // 设置tableView的contentSize
    UITableView *tableView = (UITableView *)self.superview;
    tableView.tableFooterView = self;
    [tableView reloadData]; // 重新刷新数据(会重新计算contentSize)
    
    // 总数 : 1660
    // 每一行最多显示的数量 : 30
    // 总行数 : (1660 + 30 - 1) / 30
    //    NSUInteger rowsCount = 0;
    //    if (count % maxColsCount == 0) { // 能整除
    //        rowsCount = count / maxColsCount;
    //    } else { // 不能整除
    //        rowsCount = count / maxColsCount + 1;
    //    }
    
    //    NSUInteger rowsCount = count / maxColsCount;
    //    if (count % maxColsCount) { // 不能整除
    //        rowsCount += 1;
    //    }
    
    // 总数 : 2476
    // 每页显示的最大数量 : 35
    // 总页数 :  (2476 + 35 - 1) / 35
    // pagesCount = (总数  +  每页显示的最大数量 - 1) / 每页显示的最大数量
    
//    NSUInteger rowsCount = (count + maxColsCount - 1) / maxColsCount;
//    self.xmg_height = rowsCount * buttonH;
}

- (void)buttonClick:(XMGMeSquareButton *)button
{
    NSString *url = button.square.url;
    
    if ([url hasPrefix:@"http"]) { // 利用webView加载url即可
        // 使用SFSafariViewController显示网页
//        SFSafariViewController *webView = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
//        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
//        [tabBarVc presentViewController:webView animated:YES completion:nil];
        

        // 获得"我"模块对应的导航控制器
//        UITabBarController *tabBarVc = [UIApplication sharedApplication].keyWindow.rootViewController;
//        UINavigationController *nav = tabBarVc.childViewControllers.firstObject;
        UITabBarController *tabBarVc = (UITabBarController *)self.window.rootViewController;
        UINavigationController *nav = tabBarVc.selectedViewController;
        
        // 显示XMGWebViewController
        XMGWebViewController *webView = [[XMGWebViewController alloc] init];
        webView.url = url;
        webView.navigationItem.title = button.currentTitle;
        [nav pushViewController:webView animated:YES];
    } else if ([url hasPrefix:@"mod"]) { // 另行处理
        if ([url hasSuffix:@"BDJ_To_Check"]) {
            XMGLog(@"跳转到[审帖]界面");
        } else if ([url hasSuffix:@"BDJ_To_RecentHot"]) {
            XMGLog(@"跳转到[每日排行]界面");
        } else {
            XMGLog(@"跳转到其他界面");
        }
    } else {
        XMGLog(@"不是http或者mod协议的");
    }
}

@end
