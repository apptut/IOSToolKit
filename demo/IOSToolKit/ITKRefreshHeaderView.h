//
//  ITKRefreshHeaderView.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

// 头部下拉刷新状态
typedef enum {
    ITKRefreshStateIdle = 1,
    ITKRefreshStatePulling,
    ITKRefreshStateRefreshing,
    ITKRefreshStateWillRefresh
} ITKRefreshHeaderState;

@interface ITKRefreshHeaderView : UIView {
    UIEdgeInsets _scrollViewOriginalInset;
    __weak UIScrollView* _scrollView;
}

#pragma mark - 文字处理

@property (strong, nonatomic) UIColor* textColor;       // 文字颜色
@property (strong, nonatomic) UIFont* font;             // 字体大小
@property (copy, nonatomic) void (^refreshingBlock)();  // 下拉刷新回调


/** 进入刷新状态 */
- (void)beginRefreshing;

/** 结束刷新状态 */
- (void)endRefreshing;

/** 是否正在刷新 */
- (BOOL)isRefreshing;

/**
 * 设置state状态下的状态文字内容title(别直接拿stateLabel修改文字)
 */
- (void)setTitle:(NSString*)title forState:(ITKRefreshHeaderState)state;
/** 刷新控件的状态 */
@property (assign, nonatomic) ITKRefreshHeaderState state;

#pragma mark - 文字控件的可见性处理
/** 是否隐藏状态标签 */
@property (assign, nonatomic, getter=isStateHidden) BOOL stateHidden;

#pragma mark - 交给子类重写
/** 下拉的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;

@end
