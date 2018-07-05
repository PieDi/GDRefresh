//
//  GDRefreshHeader.h
//  OCDemo-3
//
//  Created by PieDi on 2018/7/2.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import "GDRefreshComponent.h"

@interface GDRefreshHeader : GDRefreshComponent

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(GDRefreshComponentRefreshingBlock)refreshingBlock;




/** 忽略多少scrollView的contentInset的top */
@property (assign, nonatomic) CGFloat ignoredScrollViewContentInsetTop;

@end
