//
//  XMGEssenceViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGTitleButton.h"

@interface XMGEssenceViewController ()
/** 当前选中的标题按钮 */
@property (nonatomic, weak) XMGTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
@end

@implementation XMGEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupScrollView];
    
    [self setupTitlesView];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = XMGRandomColor;
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
}

- (void)setupTitlesView
{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    titlesView.frame = CGRectMake(0, 64, self.view.xmg_width, 35);
    [self.view addSubview:titlesView];
    
    // 添加标题
    NSArray *titles = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = titlesView.xmg_width / count;
    CGFloat titleButtonH = titlesView.xmg_height;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        XMGTitleButton *titleButton = [XMGTitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    // 按钮的选中颜色
    XMGTitleButton *lastTitleButton = titlesView.subviews.lastObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [lastTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.xmg_height = 1;
    indicatorView.xmg_y = titlesView.xmg_height - indicatorView.xmg_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
}

- (void)setupNav
{
    self.view.backgroundColor = XMGCommonBgColor;
    // 标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    // 左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
}

#pragma mark - 监听点击
- (void)titleClick:(XMGTitleButton *)titleButton
{
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;

    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.xmg_width = titleButton.titleLabel.xmg_width;
        self.indicatorView.xmg_centerX = titleButton.xmg_centerX;
    }];
}

- (void)tagClick
{
    XMGLogFunc
}

@end
