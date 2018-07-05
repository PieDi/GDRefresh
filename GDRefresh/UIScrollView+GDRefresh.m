//
//  UIScrollView+GDRefresh.m
//  OCDemo-3
//
//  Created by piedi on 2018/7/3.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import "UIScrollView+GDRefresh.h"
#import <objc/runtime.h>
#import "GDRefreshHeader.h"
#import "GDRefreshFooter.h"


@implementation NSObject (GDRefresh)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end


@implementation UIScrollView (GDRefresh)

static const char GDRefreshHeaderKey = '\0';

- (void)setGd_header:(GDRefreshHeader *)gd_header{
    if (gd_header != self.gd_header) {
        // 删除旧的，添加新的
        [self.gd_header removeFromSuperview];
        [self insertSubview:gd_header atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"gd_header"]; // KVO
        objc_setAssociatedObject(self, &GDRefreshHeaderKey,
                                 gd_header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"mj_header"]; // KVO
    }
}

- (GDRefreshHeader *)gd_header{
    return objc_getAssociatedObject(self, &GDRefreshHeaderKey);
}


#pragma mark - footer
static const char GDRefreshFooterKey = '\0';

- (void)setGd_footer:(GDRefreshFooter *)gd_footer{
    
    if (gd_footer != self.gd_footer) {
        // 删除旧的，添加新的
        [self.gd_footer removeFromSuperview];
        [self insertSubview:gd_footer atIndex:0];
        
        // 存储新的
        [self willChangeValueForKey:@"gd_footer"]; // KVO
        objc_setAssociatedObject(self, &GDRefreshFooterKey,
                                 gd_footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"gd_footer"]; // KVO
    }
}


- (GDRefreshFooter *)gd_footer{
    return objc_getAssociatedObject(self, &GDRefreshFooterKey);
}






#pragma mark - other
- (NSInteger)GD_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}

static const char GDRefreshReloadDataBlockKey = '\0';

- (void)setGD_reloadDataBlock:(void (^)(NSInteger))GD_reloadDataBlock{
    
    [self willChangeValueForKey:@"GD_reloadDataBlock"]; // KVO
    objc_setAssociatedObject(self, &GDRefreshReloadDataBlockKey, GD_reloadDataBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"GD_reloadDataBlock"]; // KVO
    
}

- (void (^)(NSInteger))GD_reloadDataBlock{
    return objc_getAssociatedObject(self, &GDRefreshReloadDataBlockKey);
}


- (void)executeReloadDataBlock
{
    !self.GD_reloadDataBlock ? : self.GD_reloadDataBlock(self.GD_totalDataCount);
}
@end


@implementation UITableView (GDRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(GD_reloadData)];
}

- (void)GD_reloadData
{
    [self GD_reloadData];
    
    [self executeReloadDataBlock];
}
@end

@implementation UICollectionView (GDRefresh)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(GD_reloadData)];
}

- (void)GD_reloadData
{
    [self GD_reloadData];
    
    [self executeReloadDataBlock];
}
@end

