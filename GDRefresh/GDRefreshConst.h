#import <UIKit/UIKit.h>
#import <objc/message.h>

// 弱引用
#define GDWeakSelf __weak typeof(self) weakSelf = self;



// 过期提醒
#define GDRefreshDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

// 运行时objc_msgSend
#define GDRefreshMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define GDRefreshMsgTarget(target) (__bridge void *)(target)

// RGB颜色
#define GDRefreshColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


// 常量
UIKIT_EXTERN const CGFloat GDRefreshLabelLeftInset;
UIKIT_EXTERN const CGFloat GDRefreshHeaderHeight;
UIKIT_EXTERN const CGFloat GDRefreshFooterHeight;
UIKIT_EXTERN const CGFloat GDRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat GDRefreshSlowAnimationDuration;

UIKIT_EXTERN NSString *const GDRefreshKeyPathContentOffset;
UIKIT_EXTERN NSString *const GDRefreshKeyPathContentSize;
UIKIT_EXTERN NSString *const GDRefreshKeyPathContentInset;
UIKIT_EXTERN NSString *const GDRefreshKeyPathPanState;



// 状态检查
#define GDRefreshCheckState \
GDRefreshState oldState = self.state; \
if (state == oldState) return; \
[super setState:state];
