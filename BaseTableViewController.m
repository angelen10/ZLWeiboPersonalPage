//
//  BaseTableViewController.m
//  微博个人主页
//
//  Created by zenglun on 16/5/4.
//  Copyright © 2016年 chengchengxinxi. All rights reserved.
//

#import "BaseTableViewController.h"

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@初始化", self);
    
    self.tableView.showsHorizontalScrollIndicator  = NO;
    
    // 只是一个占位的 table header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerImgHeight + switchBarHeight)];
    headerView.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = headerView;
    
    if (self.tableView.contentSize.height < kScreenHeight + headerImgHeight - topBarHeight ) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight + headerImgHeight - topBarHeight - self.tableView.contentSize.height, 0);
    }
}

- (void)dealloc {
    NSLog(@"%@销毁", self);
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"%f", offsetY);

    if ([self.delegate respondsToSelector:@selector(tableViewScroll:offsetY:)]) {
        [self.delegate tableViewScroll:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDragging:offsetY:)]) {
        [self.delegate tableViewWillBeginDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewWillBeginDecelerating:offsetY:)]) {
        [self.delegate tableViewWillBeginDecelerating:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDragging:offsetY:)]) {
        [self.delegate tableViewDidEndDragging:self.tableView offsetY:offsetY];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(tableViewDidEndDecelerating:offsetY:)]) {
        [self.delegate tableViewDidEndDecelerating:self.tableView offsetY:offsetY];
    }
}




@end
