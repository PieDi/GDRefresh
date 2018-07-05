//
//  GDRefreshFooter.m
//  OCDemo-3
//
//  Created by piedi on 2018/7/4.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import "GDRefreshFooter.h"
#import "UIScrollView+GDExtension.h"
#import "UIScrollView+GDRefresh.h"


@interface GDRefreshFooter ()

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@end

@implementation GDRefreshFooter

+ (instancetype)footerWithRefreshingBlock:(GDRefreshComponentRefreshingBlock)refreshingBlock
{
    GDRefreshFooter *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}


#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
    // 设置自己的高度
    self.GD_h = GDRefreshFooterHeight;
    
    // 默认不会自动隐藏
    self.automaticallyHidden = NO;
}

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self scrollViewContentSizeDidChange:nil];
}

#pragma mark - 实现父类的方法
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 如果正在刷新，直接返回
    if (self.state == GDRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.GD_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - happenOffsetY) / self.GD_h;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == GDRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = happenOffsetY + self.GD_h;
        
        if (self.state == GDRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = GDRefreshStatePulling;
        } else if (self.state == GDRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = GDRefreshStateIdle;
        }
    } else if (self.state == GDRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.GD_contentH + self.ignoredScrollViewContentInsetBottom;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.GD_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom + self.ignoredScrollViewContentInsetBottom;
    // 设置位置和尺寸
    self.GD_y = MAX(contentHeight, scrollHeight);
}

- (void)setState:(GDRefreshState)state
{
    GDRefreshCheckState
    
    // 根据状态来设置属性
    if (state == GDRefreshStateNoMoreData || state == GDRefreshStateIdle) {
        // 刷新完毕
        if (GDRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:GDRefreshSlowAnimationDuration animations:^{
                self.scrollView.GD_insetB -= self.lastBottomDelta;
                
                // 自动调整透明度
                if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
            }];
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        // 刚刷新完毕
        if (GDRefreshStateRefreshing == oldState && deltaH > 0 && self.scrollView.GD_totalDataCount != self.lastRefreshCount) {
            self.scrollView.GD_offsetY = self.scrollView.GD_offsetY;
        }
    } else if (state == GDRefreshStateRefreshing) {
        // 记录刷新前的数量
        self.lastRefreshCount = self.scrollView.GD_totalDataCount;
        
        [UIView animateWithDuration:GDRefreshFastAnimationDuration animations:^{
            CGFloat bottom = self.GD_h + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.GD_insetB;
            self.scrollView.GD_insetB = bottom;
            self.scrollView.GD_offsetY = [self happenOffsetY] + self.GD_h;
        } completion:^(BOOL finished) {
            [self executeRefreshingCallback];
        }];
    }
}

#pragma mark - 公共方法
- (void)endRefreshing
{
    if ([self.scrollView isKindOfClass:[UICollectionView class]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [super endRefreshing];
        });
    } else {
        [super endRefreshing];
    }
}



#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

#pragma mark - 公共方法
- (void)endRefreshingWithNoMoreData
{
    self.state = GDRefreshStateNoMoreData;
}
@end
