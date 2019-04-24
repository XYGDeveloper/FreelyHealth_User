//
//  JQFlowView.m
//  JQFlowView
//
//  Created by 韩俊强 on 2017/5/5.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "JQIndexBannerSubview.h"
#import "JQFlowView.h"

@interface JQFlowView ()

@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView *layserview;


@end

@implementation JQFlowView

- (void)initialize
{
    self.clipsToBounds = YES;
    
    self.needsReload = YES;
    self.pageSize = self.bounds.size;
    self.pageCount = 0;
    self.isOpenAutoScroll = YES;
    self.isCarousel = YES;
    _currentPageIndex = 0;
    
    _minimumPageAlpha = 1.0;
    _minimumPageScale = 1.0;
    _autoTime = 3.0;
    
    self.visibleRange = NSMakeRange(0, 0);
    
    self.reusableCells = [[NSMutableArray alloc] initWithCapacity:0];
    self.cells = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
  
    UIView *superViewOfScrollView = [[UIView alloc] initWithFrame:self.bounds];
    [superViewOfScrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [superViewOfScrollView setBackgroundColor:[UIColor clearColor]];
    [superViewOfScrollView addSubview:self.scrollView];
    [self addSubview:superViewOfScrollView];
}

- (void)startTimer
{
    if (self.orginPageCount > 1 && self.isOpenAutoScroll && self.isCarousel) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoTime target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
}

#pragma mark --自动轮播
- (void)autoNextPage
{
    self.page ++;
    
    switch (self.orientation) {
        case JQFlowViewOrientationHorizontal:{
            
            [_scrollView setContentOffset:CGPointMake(self.page * _pageSize.width, 0) animated:YES];
            break;
        }
        case JQFlowViewOrientationVertical:{
            
            [_scrollView setContentOffset:CGPointMake(0, self.page * _pageSize.height) animated:YES];
           
            break;
        }
        default:
            break;
    }
}

- (void)queueReusableCell:(UIView *)cell
{
    [_reusableCells addObject:cell];
}

- (void)removeCellAtIndex:(NSInteger)index
{
    UIView *cell = [_cells objectAtIndex:index];
    if ((NSObject *)cell == [NSNull null]) {
        return;
    }

    [self queueReusableCell:cell];
    
    if (cell.superview) {
        [cell removeFromSuperview];
    }
    
    [_cells replaceObjectAtIndex:index withObject:[NSNull null]];
}

- (void)refreshVisibleCellAppearance
{
    if (_minimumPageAlpha == 1.0 && _minimumPageScale == 1.0) {
        return;
    }
    switch (self.orientation) {
        case JQFlowViewOrientationHorizontal:{
            CGFloat offset = _scrollView.contentOffset.x;
            
            for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
                JQIndexBannerSubview *cell = [_cells objectAtIndex:i];
               
                CGFloat origin = cell.frame.origin.x;
                CGFloat delta = fabs(origin - offset);
                
                CGRect originCellFrame = CGRectMake(_pageSize.width * i, 0, _pageSize.width, _pageSize.height);//如果没有缩小效果的情况下的本该的Frame
                
                if (delta < _pageSize.width) {
                    
                    cell.coverView.alpha = (delta / _pageSize.width) * _minimumPageAlpha;
                    
                    CGFloat inset = (_pageSize.width * (1 - _minimumPageScale)) * (delta / _pageSize.width)/2.0;
                    cell.layer.transform = CATransform3DMakeScale((_pageSize.width-inset*2)/_pageSize.width,(_pageSize.height-inset*2)/_pageSize.height, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                    
                    
                } else {
                    
                    cell.coverView.alpha = _minimumPageAlpha;
                    CGFloat inset = _pageSize.width * (1 - _minimumPageScale) / 2.0 ;
                    cell.layer.transform = CATransform3DMakeScale((_pageSize.width-inset*2)/_pageSize.width,(_pageSize.height-inset*2)/_pageSize.height, 1.0);
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                }
            }
            break;
        }
        case JQFlowViewOrientationVertical:{
            CGFloat offset = _scrollView.contentOffset.y;
            
            for (NSInteger i = self.visibleRange.location; i < self.visibleRange.location + _visibleRange.length; i++) {
                JQIndexBannerSubview *cell = [_cells objectAtIndex:i];
                CGFloat origin = cell.frame.origin.y;
                CGFloat delta = fabs(origin - offset);
                
                CGRect originCellFrame = CGRectMake(0, _pageSize.height * i, _pageSize.width, _pageSize.height);//如果没有缩小效果的情况下的本该的Frame
                
                if (delta < _pageSize.height) {
                    cell.coverView.alpha = (delta / _pageSize.height) * _minimumPageAlpha;
                    
                    CGFloat inset = (_pageSize.height * (1 - _minimumPageScale)) * (delta / _pageSize.height)/2.0;
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                    cell.mainImageView.frame = cell.bounds;
                } else {
                    cell.coverView.alpha = _minimumPageAlpha;
                    CGFloat inset = _pageSize.height * (1 - _minimumPageScale) / 2.0 ;
                    cell.frame = UIEdgeInsetsInsetRect(originCellFrame, UIEdgeInsetsMake(inset, inset, inset, inset));
                    cell.mainImageView.frame = cell.bounds;
                }
            }
        }
        default:
            break;
    }
}

- (void)setPageAtIndex:(NSInteger)pageIndex
{
    NSParameterAssert(pageIndex >= 0 && pageIndex < [_cells count]);
    
    UIView *cell = [_cells objectAtIndex:pageIndex];
    
    if ((NSObject *)cell == [NSNull null]) {
        cell = [_dataSource flowView:self cellForPageAtIndex:pageIndex % self.orginPageCount];
        NSAssert(cell!=nil, @"datasource must not return nil");
        [_cells replaceObjectAtIndex:pageIndex withObject:cell];
        
        //添加点击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
        [cell addGestureRecognizer:singleTap];
        cell.tag = pageIndex % self.orginPageCount;
        
        switch (self.orientation) {
            case JQFlowViewOrientationHorizontal:
                cell.frame = CGRectMake(_pageSize.width * pageIndex, 0, _pageSize.width, _pageSize.height);
                break;
            case JQFlowViewOrientationVertical:
                cell.frame = CGRectMake(0, _pageSize.height * pageIndex, _pageSize.width, _pageSize.height);
                break;
            default:
                break;
        }
        if (!cell.superview) {
            [_scrollView addSubview:cell];
        }
    }
}

- (void)setPagesAtContentOffset:(CGPoint)offset
{
  
    CGPoint startPoint = CGPointMake(offset.x - _scrollView.frame.origin.x, offset.y - _scrollView.frame.origin.y);
    CGPoint endPoint = CGPointMake(startPoint.x + self.bounds.size.width, startPoint.y + self.bounds.size.height);
    
    
    switch (self.orientation) {
        case JQFlowViewOrientationHorizontal:{
            NSInteger startIndex = 0;
            for (int i =0; i < [_cells count]; i++) {
                if (_pageSize.width * (i +1) > startPoint.x) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < [_cells count]; i++) {
              
                if ((_pageSize.width * (i + 1) < endPoint.x && _pageSize.width * (i + 2) >= endPoint.x) || i+ 2 == [_cells count]) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
        
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, [_cells count] - 1);
    
            self.visibleRange = NSMakeRange(startIndex, endIndex - startIndex + 1);
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (int i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        case JQFlowViewOrientationVertical:{
            NSInteger startIndex = 0;
            for (int i =0; i < [_cells count]; i++) {
                if (_pageSize.height * (i +1) > startPoint.y) {
                    startIndex = i;
                    break;
                }
            }
            
            NSInteger endIndex = startIndex;
            for (NSInteger i = startIndex; i < [_cells count]; i++) {
                //如果都不超过则取最后一个
                if ((_pageSize.height * (i + 1) < endPoint.y && _pageSize.height * (i + 2) >= endPoint.y) || i+ 2 == [_cells count]) {
                    endIndex = i + 1;//i+2 是以个数，所以其index需要减去1
                    break;
                }
            }
    
            startIndex = MAX(startIndex - 1, 0);
            endIndex = MIN(endIndex + 1, [_cells count] - 1);
            
            _visibleRange.location = startIndex;
            _visibleRange.length = endIndex - startIndex + 1;
            
            for (NSInteger i = startIndex; i <= endIndex; i++) {
                [self setPageAtIndex:i];
            }
            
            for (NSInteger i = 0; i < startIndex; i ++) {
                [self removeCellAtIndex:i];
            }
            
            for (NSInteger i = endIndex + 1; i < [_cells count]; i ++) {
                [self removeCellAtIndex:i];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark Override Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

#pragma mark JQFlowView API

- (void)reloadData
{
    _needsReload = YES;

    for (UIView *view in self.scrollView.subviews) {
        if ([NSStringFromClass(view.class) isEqualToString:@"PGIndexBannerSubiew"]) {
            [view removeFromSuperview];
        }
    }
    
    [self stopTimer];
    
    if (_needsReload) {
   
        if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfPagesInFlowView:)]) {
  
            self.orginPageCount = [_dataSource numberOfPagesInFlowView:self];
  
            if (self.isCarousel) {
                _pageCount = self.orginPageCount == 1 ? 1: [_dataSource numberOfPagesInFlowView:self] * 3;
            }else {
                _pageCount = self.orginPageCount == 1 ? 1: [_dataSource numberOfPagesInFlowView:self];
            }
      
            if (_pageCount == 0) {
                return;
            }
            if (self.pageControl && [self.pageControl respondsToSelector:@selector(setNumberOfPages:)]) {
                [self.pageControl setNumberOfPages:self.orginPageCount];
            }
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(sizeForPageInFlowView:)]) {
            _pageSize = [_delegate sizeForPageInFlowView:self];
        }
        
        [_reusableCells removeAllObjects];
        _visibleRange = NSMakeRange(0, 0);
  
        [_cells removeAllObjects];
        for (NSInteger index=0; index<_pageCount; index++)
        {
            [_cells addObject:[NSNull null]];
        }
     
        switch (self.orientation) {
            case JQFlowViewOrientationHorizontal://横向
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount,_pageSize.height);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                
                if (self.orginPageCount > 1) {
                    
                    if (self.isCarousel) {
               
                        [_scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                 
                        [self startTimer];
                        
                    }else {
      
                        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                    }
                }
                break;
            case JQFlowViewOrientationVertical:{
                _scrollView.frame = CGRectMake(0, 0, _pageSize.width, _pageSize.height);
                _scrollView.contentSize = CGSizeMake(_pageSize.width ,_pageSize.height * _pageCount);
                CGPoint theCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
                _scrollView.center = theCenter;
                
                if (self.orginPageCount > 1) {
                    
                    if (self.isCarousel) {
           
                        [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * self.orginPageCount) animated:NO];
                        
                        self.page = self.orginPageCount;
            
                        [self startTimer];
                    }else {
          
                        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                        self.page = self.orginPageCount;
                    }
                }
                break;
            }
            default:
                break;
        }
        _needsReload = NO;
    }
    [self setPagesAtContentOffset:_scrollView.contentOffset];//根据当前scrollView的offset设置cell
    [self refreshVisibleCellAppearance];//更新各个可见Cell的显示外貌
}

- (UIView *)dequeueReusableCell
{
    JQIndexBannerSubview *cell = [_reusableCells lastObject];
    if (cell){
        [_reusableCells removeLastObject];
    }
    return cell;
}

- (void)scrollToPage:(NSUInteger)pageNumber
{
    if (pageNumber < _pageCount) {

        [self stopTimer];
        self.page = pageNumber + self.orginPageCount;
        
        switch (self.orientation) {
            case JQFlowViewOrientationHorizontal:
                [_scrollView setContentOffset:CGPointMake(_pageSize.width * (pageNumber + self.orginPageCount), 0) animated:YES];
                break;
            case JQFlowViewOrientationVertical:
                [_scrollView setContentOffset:CGPointMake(0, _pageSize.height * (pageNumber + self.orginPageCount)) animated:YES];
                break;
        }
        
        [self setPagesAtContentOffset:_scrollView.contentOffset];
        
        [self refreshVisibleCellAppearance];
        
        if (self.isCarousel) {
            [self startTimer];
        }
    }
}

#pragma mark hitTest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        CGPoint newPoint = CGPointZero;
        newPoint.x = point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x;
        newPoint.y = point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y;
        if ([_scrollView pointInside:newPoint withEvent:event]) {
            return [_scrollView hitTest:newPoint withEvent:event];
        }
        return _scrollView;
    }
    return nil;
}


#pragma mark -
#pragma mark UIScrollView Delegate
//
//
//
//
//
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (self.orginPageCount == 0) {
        return;
    }
    
    NSInteger pageIndex;
    
    switch (self.orientation) {
        case JQFlowViewOrientationHorizontal:
            pageIndex = (int)floor(_scrollView.contentOffset.x / _pageSize.width) % self.orginPageCount;
            break;
        case JQFlowViewOrientationVertical:
            pageIndex = (int)floor(_scrollView.contentOffset.y / _pageSize.height) % self.orginPageCount;
            break;
        default:
            break;
    }
    
    if (self.isCarousel) {
        
        if (self.orginPageCount > 1) {
            switch (self.orientation) {
                case JQFlowViewOrientationHorizontal:
                {
                    if (scrollView.contentOffset.x / _pageSize.width >= 2 * self.orginPageCount) {
                        
                        [scrollView setContentOffset:CGPointMake(_pageSize.width * self.orginPageCount, 0) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                    }
                    
                    if (scrollView.contentOffset.x / _pageSize.width <= self.orginPageCount - 1) {
                        [scrollView setContentOffset:CGPointMake((2 * self.orginPageCount - 1) * _pageSize.width, 0) animated:NO];
                        
                        self.page = 2 * self.orginPageCount;
                    }
                    
                }
                    break;
                case JQFlowViewOrientationVertical:
                {
                    if (scrollView.contentOffset.y / _pageSize.height >= 2 * self.orginPageCount) {
                        
                        [scrollView setContentOffset:CGPointMake(0, _pageSize.height * self.orginPageCount) animated:NO];
                        
                        self.page = self.orginPageCount;
                        
                    }
                    
                    if (scrollView.contentOffset.y / _pageSize.height <= self.orginPageCount - 1) {
                        [scrollView setContentOffset:CGPointMake(0, (2 * self.orginPageCount - 1) * _pageSize.height) animated:NO];
                        self.page = 2 * self.orginPageCount;
                    }
                    
                }
                    break;
                default:
                    break;
            }
            
        }else {
            
            pageIndex = 0;
        }
    }
    
    [self setPagesAtContentOffset:scrollView.contentOffset];
    [self refreshVisibleCellAppearance];
    
    if (self.pageControl && [self.pageControl respondsToSelector:@selector(setCurrentPage:)]) {
        
        [self.pageControl setCurrentPage:pageIndex];
    }
    
    if ([_delegate respondsToSelector:@selector(didScrollToPage:inFlowView:)] && _currentPageIndex != pageIndex) {
        [_delegate didScrollToPage:pageIndex inFlowView:self];
    }
    
    _currentPageIndex = pageIndex;
}
//
//
//
//
//
//
#pragma mark --将要开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
}

//
//
//
//
//
//

#pragma mark --将要结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    if (self.orginPageCount > 1 && self.isOpenAutoScroll && self.isCarousel) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoTime target:self selector:@selector(autoNextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        switch (self.orientation) {
            case JQFlowViewOrientationHorizontal:
            {
                if (self.page == floor(_scrollView.contentOffset.x / _pageSize.width)) {
                    
                    self.page = floor(_scrollView.contentOffset.x / _pageSize.width) + 1;
                    
                }else {
                    
                    self.page = floor(_scrollView.contentOffset.x / _pageSize.width);
                }
            }
                break;
            case JQFlowViewOrientationVertical:
            {
                if (self.page == floor(_scrollView.contentOffset.y / _pageSize.height)) {
                    
                    self.page = floor(_scrollView.contentOffset.y / _pageSize.height) + 1;
                    
                }else {
                    
                    self.page = floor(_scrollView.contentOffset.y / _pageSize.height);
                }
            }
                break;
            default:
                break;
        }
    }
}

//
//
//
//
//
//

- (void)singleCellTapAction:(UIGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector:@selector(didSelectCell:withSubViewIndex:)]) {
        
        [self.delegate didSelectCell:gesture.view withSubViewIndex:gesture.view.tag];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
