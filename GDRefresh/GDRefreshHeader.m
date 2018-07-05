//
//  GDRefreshHeader.m
//  OCDemo-3
//
//  Created by PieDi on 2018/7/2.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import "GDRefreshHeader.h"
#import "UIScrollView+GDExtension.h"


@interface GDRefreshHeader ()
@property (assign, nonatomic) CGFloat insetTDelta;
@end

@implementation GDRefreshHeader

+ (instancetype)headerWithRefreshingBlock:(GDRefreshComponentRefreshingBlock)refreshingBlock
{
    GDRefreshHeader *cmp = [[self alloc] init];
    cmp.refreshingBlock = refreshingBlock;
    return cmp;
}


- (void)prepare
{
    [super prepare];
    
    // 设置高度
    self.GD_h = GDRefreshHeaderHeight;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
    self.GD_y = - self.GD_h - self.ignoredScrollViewContentInsetTop;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    // 在刷新的refreshing状态
    if (self.state == GDRefreshStateRefreshing) {
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.GD_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.GD_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.GD_h + _scrollViewOriginalInset.top ? self.GD_h + _scrollViewOriginalInset.top : insetT;
        self.scrollView.GD_insetT = insetT;
        
        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.contentInset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.GD_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.GD_h;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.GD_h;
    
    if (self.scrollView.isDragging) { // 如果正在拖拽
        self.pullingPercent = pullingPercent;
        if (self.state == GDRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = GDRefreshStatePulling;
        } else if (self.state == GDRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
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

- (void)setState:(GDRefreshState)state
{
    GDRefreshCheckState
    
    // 根据状态做事情
    if (state == GDRefreshStateIdle) {
        if (oldState != GDRefreshStateRefreshing) return;
        
        // 恢复inset和offset
        [UIView animateWithDuration:GDRefreshSlowAnimationDuration animations:^{
            self.scrollView.GD_insetT += self.insetTDelta;
            
            // 自动调整透明度
            if (self.isAutomaticallyChangeAlpha) self.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.pullingPercent = 0.0;
            
            if (self.endRefreshingCompletionBlock) {
                self.endRefreshingCompletionBlock();
            }
        }];
    } else if (state == GDRefreshStateRefreshing) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:GDRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.GD_h;
                // 增加滚动区域top
                self.scrollView.GD_insetT = top;
                // 设置滚动位置
                [self.scrollView setContentOffset:CGPointMake(0, -top) animated:NO];
            } completion:^(BOOL finished) {
                [self executeRefreshingCallback];
            }];
        });
    }
}

#pragma mark - 公共方法
- (void)endRefreshing
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = GDRefreshStateIdle;
    });
}


@end
