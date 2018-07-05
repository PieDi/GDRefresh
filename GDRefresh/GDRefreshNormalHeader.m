//
//  GDRefreshNormalHeader.m
//  OCDemo-3
//
//  Created by piedi on 2018/7/3.
//  Copyright © 2018年 PieDi. All rights reserved.
//

#import "GDRefreshNormalHeader.h"


@interface GDRefreshNormalHeader ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *refreshImage;

@property (nonatomic, assign) CGFloat imageviewAngle;

@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation GDRefreshNormalHeader

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        _bgView.backgroundColor = GDRefreshColor(26, 199, 126);
        _bgView.layer.cornerRadius = 18;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)refreshImage{
    if (!_refreshImage) {
        _refreshImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        _refreshImage.image = [UIImage imageNamed:@"superRefresh"];
        _refreshImage.center = self.bgView.center;
    }
    return _refreshImage;
}


#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    self.imageviewAngle = 0;
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.refreshImage];
    self.bgView.GD_centerY = self.GD_size.height/2;
    self.bgView.GD_centerX = self.GD_centerX;
}

- (void)setState:(GDRefreshState)state
{
    GDRefreshCheckState
    
    // 根据状态做事情
    if (state == GDRefreshStateIdle) {
        if (oldState == GDRefreshStateRefreshing) {
//            self.arrowView.transform = CGAffineTransformIdentity;
            
            NSLog(@"11");
            if (self.state != GDRefreshStateIdle) return;
            NSLog(@"22");
            [self stopAnimation];
            
        } else {
            NSLog(@"33");
            [self stopAnimation];

        }
    } else if (state == GDRefreshStatePulling) {
    
        self.isRefresh = YES;
        [self startAnimation];
        
    } else if (state == GDRefreshStateRefreshing) {
        
//        self.isRefresh = YES;
//        [self startAnimation];
    }
}


- (void)startAnimation
{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.imageviewAngle * (M_PI / 180.0f));
    
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.refreshImage.transform = endAngle;
    } completion:^(BOOL finished) {
        self.imageviewAngle += 10;
        if (self.isRefresh) {
            [self startAnimation];
        }
        
    }];
    
}

- (void)stopAnimation
{
    self.isRefresh = NO;
    self.imageviewAngle = 0.0;

    self.refreshImage.transform = CGAffineTransformIdentity;
    
}
@end
