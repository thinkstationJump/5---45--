//
//  XMGCommentViewController.m
//  4期-百思不得姐
//
//  Created by xiaomage on 15/10/23.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "XMGCommentViewController.h"
#import "XMGHTTPSessionManager.h"
#import "XMGRefreshHeader.h"
#import "XMGRefreshFooter.h"
#import "XMGTopic.h"
#import "XMGComment.h"
#import <MJExtension.h>
#import "XMGCommentSectionHeader.h"
#import "XMGCommentCell.h"

@interface XMGCommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
/** 任务管理者 */
@property (nonatomic, strong) XMGHTTPSessionManager *manager;

/** 最热评论数据 */
@property (nonatomic, strong) NSArray<XMGComment *> *hotestComments;

/** 最新评论数据 */
@property (nonatomic, strong) NSMutableArray<XMGComment *> *lastestComments;

// 对象属性名不能以new开头
// @property (nonatomic, strong) NSMutableArray<XMGComment *> *newComments;
@end

@implementation XMGCommentViewController

static NSString * const XMGCommentCellId = @"comment";
static NSString * const XMGSectionHeaderlId = @"header";

#pragma mark - 懒加载
- (XMGHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [XMGHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBase];
    
    [self setupTable];
    
    [self setupRefresh];
}

- (void)setupTable
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGCommentCell class]) bundle:nil] forCellReuseIdentifier:XMGCommentCellId];
    [self.tableView registerClass:[XMGCommentSectionHeader class] forHeaderFooterViewReuseIdentifier:XMGSectionHeaderlId];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor redColor];
    headerView.xmg_height = 200;
    self.tableView.tableHeaderView = headerView;
    
    self.tableView.backgroundColor = XMGCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 每一组头部控件的高度
    self.tableView.sectionHeaderHeight = XMGCommentSectionHeaderFont.lineHeight + 2;
    
    // 设置cell的高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (void)setupRefresh
{
    self.tableView.mj_header = [XMGRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComments)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [XMGRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComments)];
}

- (void)setupBase
{
    self.navigationItem.title = @"评论";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// -[__NSArray0 objectForKeyedSubscript:]: unrecognized selector sent to instance 0x7fb738c01870
// 错误地将NSArray当做NSDictionary来使用了

#pragma mark - 数据加载
- (void)loadNewComments
{
    // 取消所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @1; // @"1";
    
    __weak typeof(self) weakSelf = self;
    
    // 发送请求
    [self.manager GET:XMGCommonURL parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 没有任何评论数据
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            // 让[刷新控件]结束刷新
            [weakSelf.tableView.mj_header endRefreshing];
            return;
        }
        
        // 字典数组 -> 模型数组
        weakSelf.lastestComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        weakSelf.hotestComments = [XMGComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 让[刷新控件]结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreComments
{
    
}

#pragma mark - 监听
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 修改约束
    CGFloat keyboardY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    self.bottomMargin.constant = screenH - keyboardY;
    
    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    if (self.lastestComments.count && self.hotestComments.count) return 2;
//    if (self.lastestComments.count && self.hotestComments.count == 0) return 1;
//    
//    return 0;
    
    // 有最热评论 + 最新评论数据
    if (self.hotestComments.count) return 2;
    
    // 没有最热评论数据, 有最新评论数据
    if (self.lastestComments.count) return 1;
    
    // 没有最热评论数据, 没有最新评论数据
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    // 第0组
//    if (section == 0) {
//        if (self.hotestComments.count) {
//            return self.hotestComments.count;
//        } else {
//            return self.lastestComments.count;
//        }
//    }
//    
//    // 其他组 - section == 1
//    return self.lastestComments.count;
    
    // 第0组 && 有最热评论数据
    if (section == 0 && self.hotestComments.count) {
        return self.hotestComments.count;
    }
    
    // 其他情况
    return self.lastestComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMGCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:XMGCommentCellId];
    
    if (indexPath.section == 0 && self.hotestComments.count) {
        cell.comment = self.hotestComments[indexPath.row];
    } else {
        cell.comment = self.lastestComments[indexPath.row];
    }
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    // 第0组 && 有最热评论数据
//    if (section == 0 && self.hotestComments.count) {
//        return @"最热评论";
//    }
//    
//    // 其他情况
//    return @"最新评论";
//}

#pragma mark - <UITableViewDelegate>
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] init];
//    label.backgroundColor = tableView.backgroundColor;
//    label.font = XMGCommentSectionHeaderFont;
//    label.textColor = [UIColor darkGrayColor];
//    
//    // 第0组 && 有最热评论数据
//    if (section == 0 && self.hotestComments.count) {
//        label.text = @"最热评论";
//    } else { // 其他情况
//        label.text = @"最新评论";
//    }
//    
//    return label;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIButton *button = [[UIButton alloc] init];
//    button.backgroundColor = tableView.backgroundColor;
//    
//    // 内边距
//    button.contentEdgeInsets = UIEdgeInsetsMake(0, XMGMargin, 0, 0);
//    // button.titleEdgeInsets = UIEdgeInsetsMake(0, XMGMargin, 0, 0);
//    // 让按钮内部的内容, 在按钮中左对齐
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    
//    button.titleLabel.font = XMGCommentSectionHeaderFont;
//    
//    // 让label的文字在label内部左对齐
//    // button.titleLabel.textAlignment = NSTextAlignmentLeft;
//    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    // 第0组 && 有最热评论数据
//    if (section == 0 && self.hotestComments.count) {
//        [button setTitle:@"最热评论" forState:UIControlStateNormal];
//    } else { // 其他情况
//        [button setTitle:@"最新评论" forState:UIControlStateNormal];
//    }
//    
//    return button;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    //    if (header == nil) {
//    //        header = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:XMGSectionHeaderlId];
//    //        header.textLabel.textColor = [UIColor darkGrayColor];
//    //    }
//    
//    
//    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XMGSectionHeaderlId];
//    
//    header.textLabel.textColor = [UIColor darkGrayColor];
//    // 第0组 && 有最热评论数据
//    if (section == 0 && self.hotestComments.count) {
//        header.textLabel.text = @"最热评论";
//    } else { // 其他情况
//        header.textLabel.text = @"最新评论";
//    }
//    
//    return header;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XMGCommentSectionHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XMGSectionHeaderlId];
    
    // 第0组 && 有最热评论数据
    if (section == 0 && self.hotestComments.count) {
        header.textLabel.text = @"最热评论";
    } else { // 其他情况
        header.textLabel.text = @"最新评论";
    }
    
    return header;
}

/**
 *  当用户开始拖拽scrollView就会调用一次
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
@end