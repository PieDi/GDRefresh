//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 小码哥. All rights reserved.
//

#import "UIView+GDExtension.h"

@implementation UIView (MJExtension)


- (void)setGD_x:(CGFloat)GD_x
{
    CGRect frame = self.frame;
    frame.origin.x = GD_x;
    self.frame = frame;
}

- (CGFloat)GD_x
{
    return self.frame.origin.x;
}

- (void)setGD_centerX:(CGFloat)GD_centerX{
    CGRect frame = self.frame;
    frame.origin.x = GD_centerX-self.frame.size.width/2;
    self.frame = frame;
}

-(CGFloat)GD_centerX{
    return self.frame.origin.x+self.frame.size.width/2;
}

- (void)setGD_y:(CGFloat)GD_y
{
    CGRect frame = self.frame;
    frame.origin.y = GD_y;
    self.frame = frame;
}

- (CGFloat)GD_y
{
    return self.frame.origin.y;
}

- (void)setGD_centerY:(CGFloat)GD_centerY{
    
    CGRect frame = self.frame;
    frame.origin.y = GD_centerY-self.frame.size.height/2;
    self.frame = frame;
}

-(CGFloat)GD_centerY{
    return self.frame.origin.y + self.frame.size.height/2;
}

- (void)setGD_w:(CGFloat)GD_w
{
    CGRect frame = self.frame;
    frame.size.width = GD_w;
    self.frame = frame;
}

- (CGFloat)GD_w
{
    return self.frame.size.width;
}

- (void)setGD_h:(CGFloat)GD_h
{
    CGRect frame = self.frame;
    frame.size.height = GD_h;
    self.frame = frame;
}

- (CGFloat)GD_h
{
    return self.frame.size.height;
}

- (void)setGD_size:(CGSize)GD_size
{
    CGRect frame = self.frame;
    frame.size = GD_size;
    self.frame = frame;
}

- (CGSize)GD_size
{
    return self.frame.size;
}

- (void)setGD_origin:(CGPoint)GD_origin
{
    CGRect frame = self.frame;
    frame.origin = GD_origin;
    self.frame = frame;
}

- (CGPoint)GD_origin
{
    return self.frame.origin;
}
@end
