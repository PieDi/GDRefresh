//
//  GDRefreshFooter.h
//  OCDemo-3
//
//  Created by piedi on 2018/7/4.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import "GDRefreshComponent.h"

@interface GDRefreshFooter : GDRefreshComponent

/** 创建footer */
+ (instancetype)footerWithRefreshingBlock:(GDRefreshComponentRefreshingBlock)refreshingBlock;


- (void)endRefreshingWithNoMoreData;


/** 忽略多少scrollView的contentInset的bottom */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetBottom;

/** 自动根据有无数据来显示和隐藏（有数据就显示，没有数据隐藏。默认是NO） */
@property (assign, nonatomic, getter=isAutomaticallyHidden) BOOL automaticallyHidden;
@end
