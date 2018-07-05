//
//  GDRefreshComponent.h
//  OCDemo-3
//
//  Created by PieDi on 2018/7/2.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDRefreshConst.h"
#import "UIView+GDExtension.h"


/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, GDRefreshState) {
    /** 普通闲置状态 */
    GDRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    GDRefreshStatePulling,
    /** 正在刷新中的状态 */
    GDRefreshStateRefreshing,
    /** 即将刷新的状态 */
    GDRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    GDRefreshStateNoMoreData
};

/** 进入刷新状态的回调 */
typedef void (^GDRefreshComponentRefreshingBlock)(void);
/** 开始刷新后的回调(进入刷新状态后的回调) */
typedef void (^GDRefreshComponentbeginRefreshingCompletionBlock)(void);
/** 结束刷新后的回调 */
typedef void (^GDRefreshComponentEndRefreshingCompletionBlock)(void);

@interface GDRefreshComponent : UIView
{
    /** 记录scrollView刚开始的inset */
    UIEdgeInsets _scrollViewOriginalInset;
    /** 父控件 */
    __weak UIScrollView *_scrollView;
}
#pragma mark - 刷新回调
/** 正在刷新的回调 */
@property (copy, nonatomic) GDRefreshComponentRefreshingBlock refreshingBlock;



/** 触发回调（交给子类去调用） */
- (void)executeRefreshingCallback;

#pragma mark - 刷新状态控制
/** 进入刷新状态 */
- (void)beginRefreshing;
- (void)beginRefreshingWithCompletionBlock:(void (^)(void))completionBlock;
/** 开始刷新后的回调(进入刷新状态后的回调) */
@property (copy, nonatomic) GDRefreshComponentbeginRefreshingCompletionBlock beginRefreshingCompletionBlock;
/** 结束刷新的回调 */
@property (copy, nonatomic) GDRefreshComponentEndRefreshingCompletionBlock endRefreshingCompletionBlock;
/** 结束刷新状态 */
- (void)endRefreshing;
- (void)endRefreshingWithCompletionBlock:(void (^)(void))completionBlock;
/** 是否正在刷新 */
- (BOOL)isRefreshing;
/** 刷新状态 一般交给子类内部实现 */
@property (assign, nonatomic) GDRefreshState state;

#pragma mark - 交给子类去访问
/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;
/** 父控件 */
@property (weak, nonatomic, readonly) UIScrollView *scrollView;

#pragma mark - 交给子类们去实现
/** 初始化 */
- (void)prepare NS_REQUIRES_SUPER;
/** 摆放子控件frame */
- (void)placeSubviews NS_REQUIRES_SUPER;
/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change NS_REQUIRES_SUPER;


#pragma mark - 其他
/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;

/** 根据拖拽比例自动切换透明度 */
@property (assign, nonatomic, getter=isAutomaticallyChangeAlpha) BOOL automaticallyChangeAlpha;
@end
