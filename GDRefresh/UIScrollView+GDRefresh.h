//
//  UIScrollView+GDRefresh.h
//  OCDemo-3
//
//  Created by piedi on 2018/7/3.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDRefreshConst.h"


@class GDRefreshHeader, GDRefreshFooter;
@interface UIScrollView (GDRefresh)
@property (strong, nonatomic) GDRefreshHeader *gd_header;

@property (strong, nonatomic) GDRefreshFooter *gd_footer;

- (NSInteger)GD_totalDataCount;
@property (copy, nonatomic) void (^GD_reloadDataBlock)(NSInteger totalDataCount);
@end
