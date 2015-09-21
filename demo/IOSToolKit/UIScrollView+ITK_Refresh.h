//
//  UIScrollView+ITK_Refresh.h
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITKRefreshHeaderView,ITKRefreshFooterView;

@interface UIScrollView (ITK_Refresh)

// 上拉刷新header
@property (strong, nonatomic, readonly) ITKRefreshHeaderView *header;

// 下拉刷新footer
@property (strong, nonatomic, readonly) ITKRefreshFooterView *footer;


#pragma mark
#pragma mark 刷新公共方法

/**
 *  头部下拉刷新开始加载数据回调block
 *
 *  @param callback block 回调
 */
- (void) itk_onRefreshStart:(void (^)()) callback;


/**
 *  页面底部下拉加载更多数据回调
 *
 *  @param callback block
 */
- (void) itk_onLoadMoreStart:(void (^)()) callback;

/**
 *  是否正在下拉刷新
 */
- (BOOL) itk_isHeaderRefreshing;

/**
 *  是否正在上拉刷新
 */
- (BOOL) itk_isFooterRefreshing;

/**
 *  主动触发页面头部下拉刷新动作
 */
- (void) itk_headerRefreshing;

/**
 *  停止本次下拉刷新动作
 */
- (void) itk_headerRefreshComplete;

/**
 *  停止加载更多下拉刷新动作
 */
- (void) itk_footerRefreshComplete;


/**
 *  隐藏加载更多
 */
- (void) itk_footerHidden;





@end
