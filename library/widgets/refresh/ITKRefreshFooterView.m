//
//  ITKRefreshFooterView.m
//  IOSToolKit
//
//  Created by liangqi on 15/5/27.
//  Copyright (c) 2015年 apptut. All rights reserved.
//

#import "ITKRefreshFooterView.h"
#import "UIColor+ITK_HexColor.h"
#import "UIView+ITK_Position.h"
#import "UIScrollView+ITK_Position.h"

static const CGFloat kRefreshStateFooterFontSize = 14;          // 状态文字字体大小
static NSString* const kRereshStateFooterFontColor = @"#333";   // 状态文字字体颜色

const CGFloat ITKRefreshFooterHeight = 44.0;    // footer高度

// 状态文字内容
#define ITKRefreshFooterStateIdleText           NSLocalizedString(@"itk_footer_refresh_idle",nil)
#define ITKRefreshFooterStateRefreshingText     NSLocalizedString(@"itk_footer_refresh_pulling",nil)
#define ITKRefreshFooterStateNoMoreDataText     NSLocalizedString(@"itk_footer_refresh_refreshing",nil)

NSString *const ITKRefreshContentSize = @"contentSize";
NSString *const ITKRefreshPanState = @"pan.state";
static NSString* kOffset = @"contentOffset";

@interface ITKRefreshFooterView()

@property (weak, nonatomic) UILabel *stateLabel;                // 状态文字
@property (weak, nonatomic) UIButton *loadMoreButton;           // 加载更多可点击按钮
@property (weak, nonatomic) UILabel *noMoreLabel;               // 没有更多内容
@property (weak, nonatomic) UIActivityIndicatorView *loading;   // 菊花

 /** 即将要执行的代码 */
@property (strong, nonatomic) NSMutableArray *willExecuteBlocks;

@end
@implementation ITKRefreshFooterView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 基本属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 默认文字颜色和字体大小
        self.textColor = [UIColor itk_colorWithHexString:kRereshStateFooterFontColor];
        self.font = [UIFont systemFontOfSize:kRefreshStateFooterFontSize];

        // 默认底部控件100%出现时才会自动刷新
        self.appearencePercentTriggerAutoRefresh = 1.0;
        
        // 设置为默认状态
        self.automaticallyRefresh = YES;
        self.state = ITKRefreshFooterStateIdle;
        
        // 初始化文字
        [self setTitle:ITKRefreshFooterStateIdleText forState:ITKRefreshFooterStateIdle];
        [self setTitle:ITKRefreshFooterStateRefreshingText forState:ITKRefreshFooterStateRefreshing];
        [self setTitle:ITKRefreshFooterStateNoMoreDataText forState:ITKRefreshFooterStateNone];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(ITKRefreshFooterState)state
{
    if (title == nil) return;
    
    // 刷新当前状态的文字
    switch (state) {
        case ITKRefreshFooterStateIdle:
            [self.loadMoreButton setTitle:title forState:UIControlStateNormal];
            break;
            
        case ITKRefreshFooterStateRefreshing:
            self.stateLabel.text = title;
            break;
            
        case ITKRefreshFooterStateNone:
            self.noMoreLabel.text = title;
            break;
            
        default:
            break;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:kOffset context:nil];
    [self.superview removeObserver:self forKeyPath:ITKRefreshContentSize context:nil];
    [self.superview removeObserver:self forKeyPath:ITKRefreshPanState context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:kOffset options:NSKeyValueObservingOptionNew context:nil];
        
        // 设置宽度
        self.frame = CGRectMake(0, self.frame.origin.y, newSuperview.frame.size.width, ITKRefreshFooterHeight);
        
        // 记录UIScrollView
        _scrollView = (UIScrollView*)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.contentInset;
        
        
        [newSuperview addObserver:self forKeyPath:ITKRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:ITKRefreshPanState options:NSKeyValueObservingOptionNew context:nil];
        
        self.itk_height = ITKRefreshFooterHeight;
        _scrollView.itk_insetBottom += self.itk_height;
        
        // 重新调整frame
        [self adjustFrameWithContentSize];
        
    }else{
        _scrollView.itk_insetBottom -= self.itk_height;
    }
}

- (void)adjustFrameWithContentSize
{
    // 设置位置
    self.itk_y = _scrollView.itk_contentSizeH;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.loadMoreButton.frame = self.bounds;
    self.stateLabel.frame = self.bounds;
    self.noMoreLabel.frame = self.bounds;
    
    CGFloat loadingTop = (self.bounds.size.height - 30) / 2;
    self.loading.frame = CGRectMake(0, loadingTop, 30, 30);
    self.loading.itk_center_x = self.bounds.size.width * 0.5 - 65;
}


#pragma mark - 私有方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    // if (self.state == ITKRefreshFooterStateIdle || self.state == ITKRefreshFooterStateNone) {
    if (self.state == ITKRefreshFooterStateIdle ) {
        // 当是Idle状态时，才需要检测是否要进入刷新状态
        if ([keyPath isEqualToString:ITKRefreshPanState]) {
            if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
                if (_scrollView.itk_insetTop + _scrollView.itk_contentSizeH <= _scrollView.itk_height) {  // 不够一个屏幕
                    if (_scrollView.itk_offsetY > - _scrollView.itk_insetTop) { // 向上拽
                        [self beginRefreshing];
                    }
                } else { // 超出一个屏幕
                    if (_scrollView.itk_offsetY > _scrollView.itk_contentSizeH + _scrollView.itk_insetBottom - _scrollView.itk_height) {
                        [self beginRefreshing];
                    }
                }
            }
        } else if ([keyPath isEqualToString:kOffset]) {
            if (self.state != ITKRefreshFooterStateRefreshing && self.automaticallyRefresh) {
                // 根据contentOffset调整state
                [self adjustStateWithContentOffset];
            }
        }
    }
    
    // 不管是什么状态，都要调整位置
    if ([keyPath isEqualToString:ITKRefreshContentSize]) {
        [self adjustFrameWithContentSize];
    }
}


#pragma mark - 公共方法
- (void)setHidden:(BOOL)hidden
{
    __weak typeof(self) weakSelf = self;
    BOOL lastHidden = weakSelf.isHidden;
    CGFloat h = weakSelf.itk_height;
    [weakSelf.willExecuteBlocks addObject:^{
        if (!lastHidden && hidden) {
            weakSelf.state = ITKRefreshFooterStateIdle;
            _scrollView.itk_insetBottom -= h;
        } else if (lastHidden && !hidden) {
            _scrollView.itk_insetBottom += h;
            
            [weakSelf adjustFrameWithContentSize];
        }
    }];
    
    [weakSelf setNeedsDisplay]; // 放到drawRect是为了延迟执行，防止因为修改了inset，导致循环调用数据源方法
    
    [super setHidden:hidden];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    for (void (^block)() in self.willExecuteBlocks) {
        block();
    }
    [self.willExecuteBlocks removeAllObjects];
}

- (void)beginRefreshing
{
    self.state = ITKRefreshFooterStateRefreshing;
}

- (void)endRefreshing
{
    self.state = ITKRefreshFooterStateIdle;
}


- (BOOL)isRefreshing
{
    return self.state == ITKRefreshFooterStateRefreshing;
}

- (void)noticeNoMoreData
{
    self.state = ITKRefreshFooterStateNone;
}

- (void)resetNoMoreData
{
    self.state = ITKRefreshFooterStateIdle;
}


#pragma mark 根据contentOffset调整state
- (void)adjustStateWithContentOffset
{
    if (self.itk_y == 0) return;
    
    if (_scrollView.itk_insetTop + _scrollView.itk_contentSizeH > _scrollView.itk_height) { // 内容超过一个屏幕
        // 这里的_scrollView.mj_contentSizeH替换掉self.mj_y更为合理
        if (_scrollView.itk_offsetY > _scrollView.itk_contentSizeH - _scrollView.itk_height + self.itk_height * self.appearencePercentTriggerAutoRefresh + _scrollView.itk_insetBottom - self.itk_height) {
            // 当底部刷新控件完全出现时，才刷新
            [self beginRefreshing];
        }
    }
}

- (void)buttonClick
{
    [self beginRefreshing];
}


#pragma mark - 
#pragma mark - 懒加载

// 菊花控件
- (UIActivityIndicatorView *)loading{
    if (!_loading) {
        UIActivityIndicatorView* loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView setHidesWhenStopped:YES];
        
        [self addSubview:_loading = loadingView];
    }
    
    return _loading;
}

- (NSMutableArray *)willExecuteBlocks
{
    if (!_willExecuteBlocks) {
        self.willExecuteBlocks = [NSMutableArray array];
    }
    return _willExecuteBlocks;
}

- (UIButton *)loadMoreButton
{
    if (!_loadMoreButton) {
        UIButton *loadMoreButton = [[UIButton alloc] init];
        loadMoreButton.backgroundColor = [UIColor clearColor];
        [loadMoreButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_loadMoreButton = loadMoreButton];
    }
    return _loadMoreButton;
}

- (UILabel *)noMoreLabel
{
    if (!_noMoreLabel) {
        UILabel *noMoreLabel = [[UILabel alloc] init];
        noMoreLabel.backgroundColor = [UIColor clearColor];
        noMoreLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_noMoreLabel = noMoreLabel];
    }
    return _noMoreLabel;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        UILabel *stateLabel = [[UILabel alloc] init];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel = stateLabel];
    }
    return _stateLabel;
}


- (void)setState:(ITKRefreshFooterState)state
{
    if (_state == state) return;
    
    _state = state;
    
    switch (state) {
        case ITKRefreshFooterStateIdle:{
            self.noMoreLabel.hidden = YES;
            self.stateLabel.hidden = YES;
            self.loadMoreButton.hidden = YES;
            self.loading.hidden = YES;
            [self.loading startAnimating];
            
            //修复传统上拉加载更多在 UITableView 使用 '- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;'方法加载更多数据时露出按钮的的问题
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.loadMoreButton.hidden = self.state != ITKRefreshFooterStateIdle;
            });
        }
            break;
            
        case ITKRefreshFooterStateRefreshing:
        {
            self.loadMoreButton.hidden = YES;
            self.noMoreLabel.hidden = YES;
            if (!self.stateHidden) self.stateLabel.hidden = NO;
            
            self.loading.hidden = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.refreshingBlock) {
                    self.refreshingBlock();
                }
            });
        }
            break;
            
        case ITKRefreshFooterStateNone:
            self.loadMoreButton.hidden = YES;
            self.noMoreLabel.hidden = NO;
            self.stateLabel.hidden = YES;
            self.loading.hidden = YES;
            self.noMoreLabel.text = NSLocalizedString(@"itk_footer_no_more", nil);
            break;
            
        default:
            break;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    self.stateLabel.textColor = textColor;
    [self.loadMoreButton setTitleColor:textColor forState:UIControlStateNormal];
    self.noMoreLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    self.loadMoreButton.titleLabel.font = font;
    self.noMoreLabel.font = font;
    self.stateLabel.font = font;
}

- (void)setStateHidden:(BOOL)stateHidden
{
    _stateHidden = stateHidden;
    
    self.stateLabel.hidden = stateHidden;
    [self setNeedsLayout];
}




@end
