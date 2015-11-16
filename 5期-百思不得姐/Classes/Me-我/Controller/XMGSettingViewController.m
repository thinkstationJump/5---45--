//
//  XMGSettingViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGSettingViewController.h"
#import "XMGTestViewController.h"
#import <SDImageCache.h>

@interface XMGSettingViewController ()

@end

@implementation XMGSettingViewController
- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XMGCommonBgColor;
    self.navigationItem.title = @"设置";
}

- (void)getCacheSize
{
    // 总大小
    unsigned long long size = 0;
    
    // 获得缓存文件夹路径
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dirpath = [cachesPath stringByAppendingPathComponent:@"default"];
    
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
    // Enumerator : 遍历器\迭代器
    NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:dirpath];
    for (NSString *subpath in enumerator) {
        // 全路径
        NSString *fullSubpath = [dirpath stringByAppendingPathComponent:subpath];
        // 累加文件大小
        size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
    }
    
    XMGLog(@"%zd", size);
}

- (void)getCacheSize2
{
    // 总大小
    unsigned long long size = 0;
    
    // 获得缓存文件夹路径
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dirpath = [cachesPath stringByAppendingPathComponent:@"default"];
    
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
    NSArray *subpaths = [mgr subpathsAtPath:dirpath];
    for (NSString *subpath in subpaths) {
        // 全路径
        NSString *fullSubpath = [dirpath stringByAppendingPathComponent:subpath];
        // 累加文件大小
        size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
    }
    
    XMGLog(@"%zd", size);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XMGTestViewController *test = [[XMGTestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.确定重用标示:
    static NSString *ID = @"setting";
    
    // 2.从缓存池中取
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 3.如果空就手动创建
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // 设置cell右边的指示器(用来说明正在处理一些事情)
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingView startAnimating];
    cell.accessoryView = loadingView;
    
    // 设置cell默认的文字
    cell.textLabel.text = @"清除缓存(正在计算缓存大小...)";
    
    // 在子线程计算缓存大小
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获得缓存文件夹路径
        unsigned long long size = @"/Users/xiaomage/Desktop/课堂共享/01-UI基础".fileSize;
        size += [SDImageCache sharedImageCache].getSize;
        
        // 生成文字
        NSString *text = [NSString stringWithFormat:@"清除缓存(%zdB)", size];
        
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            // 设置文字
            cell.textLabel.text = text;
            // 清空右边的指示器
            cell.accessoryView = nil;
            // 显示右边的箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        });
    });
    
    return cell;
}
@end
