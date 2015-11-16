//
//  XMGClearCacheCell.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/16.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGClearCacheCell.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

#define XMGCustomCacheFile [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"Custom"]

@implementation XMGClearCacheCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 设置cell右边的指示器(用来说明正在处理一些事情)
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        
        // 设置cell默认的文字(如果设置文字之前userInteractionEnabled=NO, 那么文字会自动变成浅灰色)
        self.textLabel.text = @"清除缓存(正在计算缓存大小...)";
        
        // 禁止点击
        self.userInteractionEnabled = NO;
        
        // 在子线程计算缓存大小
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
#warning 睡眠
//            [NSThread sleepForTimeInterval:2.0];
            
            // 获得缓存文件夹路径
            unsigned long long size = XMGCustomCacheFile.fileSize;
            size += [SDImageCache sharedImageCache].getSize;
            NSString *sizeText = nil;
            if (size >= pow(10, 9)) { // size >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
            } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // 1KB > size
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
//            if (size >= 1000 * 1000 * 1000) { // size >= 1GB
//                sizeText = [NSString stringWithFormat:@"%.2fGB", size / 1000.0 / 1000.0 / 1000.0];
//            } else if (size >= 1000 * 1000) { // 1GB > size >= 1MB
//                sizeText = [NSString stringWithFormat:@"%.2fMB", size / 1000.0 / 1000.0];
//            } else if (size >= 1000) { // 1MB > size >= 1KB
//                sizeText = [NSString stringWithFormat:@"%.2fKB", size / 1000.0];
//            } else { // 1KB > size
//                sizeText = [NSString stringWithFormat:@"%zdB", size];
//            }
            
            // 生成文字
            NSString *text = [NSString stringWithFormat:@"清除缓存(%@)", sizeText];
            
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                // 设置文字
                self.textLabel.text = text;
                // 清空右边的指示器
                self.accessoryView = nil;
                // 显示右边的箭头
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                // 添加手势监听器
                [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCache)]];
                
                // 恢复点击事件
                self.userInteractionEnabled = YES;
            });
        });
    }
    return self;
}

/**
 *  清除缓存
 */
- (void)clearCache
{
    // 弹出指示器
    [SVProgressHUD showWithStatus:@"正在清除缓存..." maskType:SVProgressHUDMaskTypeBlack];
    
    // 删除SDWebImage的缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        // 删除自定义的缓存
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSFileManager *mgr = [NSFileManager defaultManager];
            [mgr removeItemAtPath:XMGCustomCacheFile error:nil];
            [mgr createDirectoryAtPath:XMGCustomCacheFile withIntermediateDirectories:YES attributes:nil error:nil];
            
#warning 睡眠
//            [NSThread sleepForTimeInterval:2.0];
            
            // 所有的缓存都清除完毕
            dispatch_async(dispatch_get_main_queue(), ^{
                // 隐藏指示器
                [SVProgressHUD dismiss];
                
                // 设置文字
                self.textLabel.text = @"清除缓存(0B)";
            });
        });
    }];
}

@end
