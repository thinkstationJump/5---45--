//
//  XMGEssenceViewController.m
//  5期-百思不得姐
//
//  Created by xiaomage on 15/11/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGEssenceViewController.h"
#import "XMGTitleButton.h"
#import "XMGAllViewController.h"
#import "XMGVideoViewController.h"
#import "XMGVoiceViewController.h"
#import "XMGPictureViewController.h"
#import "XMGWordViewController.h"
#import "XMGRecommendTagViewController.h"

@interface XMGEssenceViewController () <UIScrollViewDelegate>
/** 当前选中的标题按钮 */
@property (nonatomic, weak) XMGTitleButton *selectedTitleButton;
/** 标题按钮底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/** 标题栏 */
@property (nonatomic, weak) UIView *titlesView;
@end

@implementation XMGEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupChildViewControllers];
    
    [self setupScrollView];
    
    [self setupTitlesView];
    
    // 默认添加子控制器的view
    [self addChildVcView];
}

- (void)setupChildViewControllers
{
    XMGVoiceViewController *voice = [[XMGVoiceViewController alloc] init];
    [self addChildViewController:voice];
    
    XMGAllViewController *all = [[XMGAllViewController alloc] init];
    [self addChildViewController:all];
    
    XMGVideoViewController *video = [[XMGVideoViewController alloc] init];
    [self addChildViewController:video];
    
    XMGPictureViewController *picture = [[XMGPictureViewController alloc] init];
    [self addChildViewController:picture];
    
    XMGWordViewController *word = [[XMGWordViewController alloc] init];
    [self addChildViewController:word];
}

- (void)setupScrollView
{
    // 不允许自动调整scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = XMGCommonBgColor;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
    // 添加所有子控制器的view到scrollView中
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.xmg_width, 0);
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)setupTitlesView
{
    // 标题栏
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.frame = CGRectMake(0, 64, self.view.xmg_width, 35);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 添加标题
    NSArray *titles = @[@"声音", @"全部", @"视频", @"图片", @"段子"];
    NSUInteger count = titles.count;
    CGFloat titleButtonW = titlesView.xmg_width / count;
    CGFloat titleButtonH = titlesView.xmg_height;
    for (NSUInteger i = 0; i < count; i++) {
        // 创建
        XMGTitleButton *titleButton = [XMGTitleButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        
        // 设置数据
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
        
        // 设置frame
        titleButton.frame = CGRectMake(i * titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    // 按钮的选中颜色
    XMGTitleButton *firstTitleButton = titlesView.subviews.firstObject;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    indicatorView.xmg_height = 1;
    indicatorView.xmg_y = titlesView.xmg_height - indicatorView.xmg_height;
    [titlesView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    // 立刻根据文字内容计算label的宽度
    [firstTitleButton.titleLabel sizeToFit];
    indicatorView.xmg_width = firstTitleButton.titleLabel.xmg_width;
    indicatorView.xmg_centerX = firstTitleButton.xmg_centerX;
    
    // 默认情况 : 选中最前面的标题按钮
    firstTitleButton.selected = YES;
    self.selectedTitleButton = firstTitleButton;
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
    // 某个标题按钮被重复点击
    if (titleButton == self.selectedTitleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:XMGTitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;

    // 指示器
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.xmg_width = titleButton.titleLabel.xmg_width;
        self.indicatorView.xmg_centerX = titleButton.xmg_centerX;
    }];
    
    // 让UIScrollView滚动到对应位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = titleButton.tag * self.scrollView.xmg_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)tagClick
{
    XMGRecommendTagViewController *tag = [[XMGRecommendTagViewController alloc] init];
    [self.navigationController pushViewController:tag animated:YES];
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    // 子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.xmg_width;
    
    // 取出子控制器
    UIViewController *childVc = self.childViewControllers[index];
    if ([childVc isViewLoaded]) return;
    
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 使用setContentOffset:animated:或者scrollRectVisible:animated:方法让scrollView产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时, 就会调用这个方法
 * 前提: 人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 选中\点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.xmg_width;
    XMGTitleButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
    
    // 添加子控制器的view
    [self addChildVcView];
    
    // 当index == 0时, viewWithTag:方法返回的就是self.titlesView
    //    XMGTitleButton *titleButton = (XMGTitleButton *)[self.titlesView viewWithTag:index];
}
@end
