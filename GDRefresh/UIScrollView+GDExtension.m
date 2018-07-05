
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIScrollView+GDExtension.h"
#import <objc/runtime.h>

@implementation UIScrollView (GDExtension)

- (void)setGD_insetT:(CGFloat)GD_insetT{
    UIEdgeInsets inset = self.contentInset;
    inset.top = GD_insetT;
    self.contentInset = inset;
}

- (CGFloat)GD_insetT{
    return self.contentInset.top;
}

- (void)setGD_insetB:(CGFloat)GD_insetB{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = GD_insetB;
    self.contentInset = inset;
}

- (CGFloat)GD_insetB{
    return self.contentInset.bottom;
}


- (void)setGD_insetL:(CGFloat)GD_insetL{
    UIEdgeInsets inset = self.contentInset;
    inset.left = GD_insetL;
    self.contentInset = inset;
}
- (CGFloat)GD_insetL{
    return self.contentInset.left;
}


- (void)setGD_insetR:(CGFloat)GD_insetR{
    UIEdgeInsets inset = self.contentInset;
    inset.right = GD_insetR;
    self.contentInset = inset;
}
- (CGFloat)GD_insetR{
    return self.contentInset.right;
}


- (void)setGD_offsetX:(CGFloat)GD_offsetX{
    CGPoint offset = self.contentOffset;
    offset.x = GD_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)GD_offsetX{
    return self.contentOffset.x;
}

- (void)setGD_offsetY:(CGFloat)GD_offsetY{
    CGPoint offset = self.contentOffset;
    offset.y = GD_offsetY;
    self.contentOffset = offset;
}
- (CGFloat)GD_offsetY{
    return self.contentOffset.y;
}



- (void)setGD_contentW:(CGFloat)GD_contentW
{
    CGSize size = self.contentSize;
    size.width = GD_contentW;
    self.contentSize = size;
}

- (CGFloat)GD_contentW
{
    return self.contentSize.width;
}

- (void)setGD_contentH:(CGFloat)GD_contentH
{
    CGSize size = self.contentSize;
    size.height = GD_contentH;
    self.contentSize = size;
}

- (CGFloat)GD_contentH
{
    return self.contentSize.height;
}
@end
