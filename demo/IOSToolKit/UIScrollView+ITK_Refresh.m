//
//  UIScrollView+ITK_Refresh.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import <objc/runtime.h>
#import "UIScrollView+ITK_Refresh.h"
#import "ITKRefreshHeaderView.h"
#import "ITKRefreshFooterView.h"

@implementation UIScrollView (ITK_Refresh)

#pragma mark 公用方法

- (void)itk_onLoadMoreStart:(void (^)())callback{
    ITKRefreshFooterView* footer = [[ITKRefreshFooterView alloc] init];
    footer.refreshingBlock = callback;
    self.footer = footer;
}

- (void) itk_onRefreshStart:(void (^)()) callback{
    ITKRefreshHeaderView* header = [[ITKRefreshHeaderView alloc] init];
    header.refreshingBlock = callback;
    self.header = header;
}

- (void)itk_footerHidden{
    self.footer.hidden = YES;
}


/**
 *  是否正在下拉刷新
 */
- (BOOL) itk_isHeaderRefreshing{
    return [self.header isRefreshing];
}

/**
 *  是否正在上拉刷新
 */
- (BOOL) itk_isFooterRefreshing{
    return [self.footer isRefreshing];
}

/**
 *  主动触发页面头部下拉刷新动作
 */
- (void) itk_headerRefreshing{
    ITKRefreshHeaderView* headerView = self.header;
    if (!headerView) {
        @throw [[NSException alloc] initWithName:@"Refresh init error" reason:@"You must call itk_onRefreshStart before use itk_headerRefreshing" userInfo:nil];
    }
    [headerView beginRefreshing];
}

/**
 *  停止本次下拉刷新动作
 */
- (void) itk_headerRefreshComplete{
    [self.header endRefreshing];
}

/**
 *  停止加载更多下拉刷新动作
 */
- (void) itk_footerRefreshComplete{
    [self.footer endRefreshing];
}


#pragma mark footer


static char ITKRefreshFooterKey;
- (ITKRefreshFooterView *)footer
{
    return objc_getAssociatedObject(self, &ITKRefreshFooterKey);
}

- (void)setFooter:(ITKRefreshFooterView *)footer
{
    if (footer != self.footer) {
        [self.footer removeFromSuperview];
        
        [self willChangeValueForKey:@"footer"];
        objc_setAssociatedObject(self, &ITKRefreshFooterKey,
                                 footer,
                                 OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"footer"];
        
        [self addSubview:footer];
    }
}

- (void)removeFooter
{
    self.footer = nil;
}



#pragma mark header 

// 使用静态void指针作为关联对象key值
static char ITKRefreshHeaderKey;

/**
 *  绑定关联对象
 *
 *  @param header 需要关联的头不刷新对象
 */
- (void)setHeader:(ITKRefreshHeaderView *)header
{
    if (header != self.header) {
        [self.header removeFromSuperview];
        
        [self willChangeValueForKey:@"header"];
        objc_setAssociatedObject(self, &ITKRefreshHeaderKey,header,OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"header"];
        
        [self addSubview:header];
    }
}

/**
 *  获取当前的关联对象
 *
 *  @return 关联对象本身
 */
- (ITKRefreshHeaderView *)header
{
    return objc_getAssociatedObject(self, &ITKRefreshHeaderKey);
}

- (void)removeHeader
{
    self.header = nil;
}


#pragma mark system method

#pragma mark - swizzle
+ (void)load
{
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod([self class], @selector(deallocSwizzle));
    method_exchangeImplementations(method1, method2);
}

- (void)deallocSwizzle
{
    [self removeFooter];
    [self removeHeader];
    
    [self deallocSwizzle];
}



@end
