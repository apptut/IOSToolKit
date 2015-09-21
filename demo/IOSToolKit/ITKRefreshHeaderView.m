//
//  ITKRefreshHeaderView.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/26.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKRefreshHeaderView.h"
#import "UIColor+ITK_HexColor.h"
#import "UIView+ITK_Position.h"
#import "UIScrollView+ITK_Position.h"

// 转菊花 animation key
#define KEY_ANIMAION @"ring_animaiton"

static NSString* kOffset = @"contentOffset";

// 刷新状态文字提示
static NSString* kRefreshStateIdleText = @"下拉刷新";
static NSString* kRefreshStatePullingText = @"释放下拉";
static NSString* kRefreshStateRefreshingText = @"正在加载";

static const CGFloat kRefreshHeaderHeight = 54.0;

static const CGFloat kRefreshFastAnimationDuration = 0.25;
static const CGFloat kRefreshSlowAnimationDuration = 0.4;

// 状态文字字体大小
static const CGFloat kRefreshStateFontSize = 14;

// 状态文字字体颜色
static NSString* const kRereshStateFontColor = @"#333";

@interface ITKRefreshHeaderView ()

/** 记录scrollView刚开始的inset */
@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInset;

/** 父控件 */
@property (weak, nonatomic) UIScrollView* scrollView;

/** 显示状态文字的标签 */
@property (weak, nonatomic) UILabel* stateLabel;

/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary* stateTitles;

// 默认图标
@property (nonatomic, weak) UIImageView* imageIcon;

// loading 动画Layer
@property (nonatomic, weak) CALayer* activityView;

@end

@implementation ITKRefreshHeaderView

#pragma mark - 懒加载
- (NSMutableDictionary*)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel*)stateLabel
{
    if (!_stateLabel) {
        UILabel* stateLabel = [[UILabel alloc] init];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel = stateLabel];
    }
    return _stateLabel;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 基本属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];

        // 默认文字颜色和字体大小
        self.textColor = [UIColor itk_colorWithHexString:kRereshStateFontColor];
        self.font = [UIFont systemFontOfSize:kRefreshStateFontSize];

        // 设置为默认状态
        self.state = ITKRefreshStateIdle;

        // 初始化文字
        [self setTitle:kRefreshStateIdleText forState:ITKRefreshStateIdle];
        [self setTitle:kRefreshStatePullingText forState:ITKRefreshStatePulling];
        [self setTitle:kRefreshStateRefreshingText forState:ITKRefreshStateRefreshing];
    }
    return self;
}

- (void)setFont:(UIFont *)font{
    self.stateLabel.font = font;
}

- (void)drawRect:(CGRect)rect
{
    if (self.state == ITKRefreshStateWillRefresh) {
        self.state = ITKRefreshStateRefreshing;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    // 设置自己的位置
    self.itk_y = -self.itk_height;

    CGFloat stateH = self.itk_height;
    CGFloat stateW = self.itk_width;
    
    // 1.状态标签
    _stateLabel.frame = CGRectMake(0, 0, stateW, stateH);
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    
    // 2. 头像图标位置
    CGFloat arrowX = self.itk_width * 0.5 - 60;
    self.imageIcon.center = CGPointMake(arrowX, self.itk_height * 0.5);
}

#pragma mark - UI控件组装

/**
 *  下拉默认头像
 *
 *  @return 头像控件
 */
- (UIImageView*)imageIcon
{
    if (!_imageIcon) {
        // 头像
        UIImageView* iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dama_refresh"]];

        // 背景图片
        UIImage* iconBg = [UIImage imageNamed:@"icon_ring_default"];
        CALayer* circleImageLayer = [CALayer layer];
        circleImageLayer.frame = iconImage.frame;
        circleImageLayer.contents = (id)iconBg.CGImage;
        [iconImage.layer addSublayer:circleImageLayer];

        // 背景圆圈layer用来做动画使用
        _activityView = circleImageLayer;

        [self addSubview:_imageIcon = iconImage];
    }
    return _imageIcon;
}

#pragma mark KVO属性监听
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden || self.state == ITKRefreshStateRefreshing)
        return;

    // 根据contentOffset调整state
    if ([keyPath isEqualToString:kOffset]) {
        [self adjustStateWithContentOffset];
    }
}

#pragma mark 根据contentOffset调整state
- (void)adjustStateWithContentOffset
{
    if (self.state != ITKRefreshStateRefreshing) {
        // 在刷新过程中，跳转到下一个控制器时，contentInset可能会变
        _scrollViewOriginalInset = _scrollView.contentInset;
    }

    // 在刷新的 refreshing 状态，动态设置 content inset
    if (self.state == ITKRefreshStateRefreshing) {
        if (_scrollView.contentOffset.y >= -_scrollViewOriginalInset.top) {
            _scrollView.itk_insetTop = _scrollViewOriginalInset.top;
        }
        else {
            _scrollView.itk_insetTop = MIN(_scrollViewOriginalInset.top + self.itk_height,
                _scrollViewOriginalInset.top - _scrollView.contentOffset.y);
        }
        return;
    }

    // 当前的contentOffset
    CGFloat offsetY = _scrollView.itk_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -_scrollViewOriginalInset.top;

    // 如果是向上滚动到看不见头部控件，直接返回
    if (offsetY >= happenOffsetY)
        return;

    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.itk_height;
    if (_scrollView.isDragging) {
        self.pullingPercent = (happenOffsetY - offsetY) / self.itk_height;

        if (self.state == ITKRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = ITKRefreshStatePulling;
        }
        else if (self.state == ITKRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = ITKRefreshStateIdle;
        }
    }
    else if (self.state == ITKRefreshStatePulling) { // 即将刷新 && 手松开
        self.pullingPercent = 1.0;
        // 开始刷新
        self.state = ITKRefreshStateRefreshing;
    }
    else {
        self.pullingPercent = (happenOffsetY - offsetY) / self.itk_height;
    }
}

#pragma mark - 公共方法
- (void)setTitle:(NSString*)title forState:(ITKRefreshHeaderState)state
{
    if (title == nil)
        return;
    self.stateTitles[@(state)] = title;

    // 刷新当前状态的文字
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

/**
 *  开始下拉
 */
- (void)beginRefreshing
{
    if (self.window) {
        self.state = ITKRefreshStateRefreshing;
    }
    else {
        self.state = ITKRefreshStateWillRefresh;
        // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
        [self setNeedsDisplay];
    }
}

/**
 *  停止下拉刷新
 */
- (void)endRefreshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.state = ITKRefreshStateIdle;
    });
}

/**
 *  检测是否正在下拉刷新
 *
 *  @return YES : 刷新中
 */
- (BOOL)isRefreshing
{
    return self.state == ITKRefreshStateRefreshing;
}

//动画
- (void)spinAnimation;
{
    // 动画时更换图片
    UIImage* animImg = [UIImage imageNamed:@"icon_ring_refresh"];
    _activityView.contents = (id)animImg.CGImage;
    
    CABasicAnimation* animation =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:(360 * M_PI) / 180];
    animation.duration = kRefreshSlowAnimationDuration;
    animation.repeatCount = INFINITY;
    [_activityView addAnimation:animation forKey:KEY_ANIMAION];
}

- (void)setState:(ITKRefreshHeaderState)state
{
    if (_state == state)
        return;

    // 旧状态
    ITKRefreshHeaderState oldState = self.state;

    // 设置状态文字
    _stateLabel.text = _stateTitles[@(state)];

    switch (state) {
    case ITKRefreshStateIdle: {
        if (oldState == ITKRefreshStateRefreshing) {
            self.imageIcon.transform = CGAffineTransformIdentity;
            
            // 暂停老动画
            [self.activityView removeAnimationForKey:KEY_ANIMAION];
            
            UIImage *animImg = [UIImage imageNamed:@"icon_ring_refresh"];
            self.activityView.contents = (id)animImg.CGImage;

            // 恢复inset和offset
            [UIView animateWithDuration:kRefreshSlowAnimationDuration
                                  delay:0.0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                                 // 修复top值不断累加
                                 _scrollView.itk_insetTop -= self.itk_height;
                             }
                             completion:nil];
        }
        else {
            [UIView animateWithDuration:kRefreshFastAnimationDuration
                             animations:^{
                                 self.imageIcon.transform = CGAffineTransformIdentity;
                             }];
        }
        break;
    }

    case ITKRefreshStateRefreshing: {
        [self spinAnimation];
        [UIView animateWithDuration:kRefreshFastAnimationDuration
            delay:0.0
            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
            animations:^{
                // 增加滚动区域
                CGFloat top = _scrollViewOriginalInset.top + self.itk_height;
                _scrollView.itk_insetTop = top;

                // 设置滚动位置
                _scrollView.itk_offsetY = -top;
            }
            completion:^(BOOL finished) {
                // 回调
                if (self.refreshingBlock) {
                    self.refreshingBlock();
                }
            }];
        break;
    }

    default:
        break;
    }

    // 赋值
    _state = state;
}


/**
 *  当头部空间添加到ScrollView控件时，添加KVO监听
 *  观察ContentOffset偏移量来监听当前是否触发下拉刷新
 *
 *  @param newSuperview scrollView 或者子类控件
 */
- (void)willMoveToSuperview:(UIView*)newSuperview
{
    [super willMoveToSuperview:newSuperview];

    [self.superview removeObserver:self forKeyPath:kOffset context:nil];

    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:kOffset options:NSKeyValueObservingOptionNew context:nil];

        // 设置宽度
        self.frame = CGRectMake(0, self.frame.origin.y, newSuperview.frame.size.width, kRefreshHeaderHeight);
        // 记录UIScrollView
        self.scrollView = (UIScrollView*)newSuperview;
        // 设置永远支持垂直弹簧效果
        self.scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        self.scrollViewOriginalInset = self.scrollView.contentInset;
    }
}


@end
