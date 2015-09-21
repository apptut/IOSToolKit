//
//  ITKRefreshFooterView.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/27.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

// 头部下拉刷新状态
typedef enum {
    ITKRefreshFooterStateIdle = 1,      // 闲置
    ITKRefreshFooterStateRefreshing,    // 正在刷新
    ITKRefreshFooterStateNone           // 已经全部加载完毕
} ITKRefreshFooterState;


@interface ITKRefreshFooterView : UIView{
    UIEdgeInsets _scrollViewOriginalInset;
    __weak UIScrollView *_scrollView;

}

@property (strong, nonatomic) UIColor *textColor;           // 状态文字颜色
@property (strong, nonatomic) UIFont *font;                 // 状态文字字体
@property (copy, nonatomic) void (^refreshingBlock)();      // 加载回调block

@property (assign, nonatomic) ITKRefreshFooterState state;  // 当前加载状态

// 滚动到页面底部自动加载
@property (assign, nonatomic, getter=isAutomaticallyRefresh) BOOL automaticallyRefresh;

// 当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
@property (assign, nonatomic) CGFloat appearencePercentTriggerAutoRefresh;


@property (assign, nonatomic, getter=isStateHidden) BOOL stateHidden;


#pragma mark 公共方法接口

// 开始加载
- (void)beginRefreshing;

// 结束加载
- (void)endRefreshing;

// 是否正在加载数据
- (BOOL)isRefreshing;

// 没有更多数据界面提示
- (void)noticeNoMoreData;

// 恢复正常加载状态
- (void)resetNoMoreData;

/**
 * 设置state状态下的状态文字内容title
 */
- (void)setTitle:(NSString *)title forState:(ITKRefreshFooterState)state;


@end
