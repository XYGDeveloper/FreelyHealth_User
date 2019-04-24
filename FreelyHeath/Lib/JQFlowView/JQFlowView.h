//
//  JQFlowView.h
//  JQFlowView
#import <UIKit/UIKit.h>

@protocol JQFlowViewDataSource;
@protocol JQFlowViewDelegate;

//说明滚动的方式

typedef enum{
    JQFlowViewOrientationHorizontal = 0,
    JQFlowViewOrientationVertical
}JQFlowViewOrientation;

@interface JQFlowView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) JQFlowViewOrientation orientation;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,assign) BOOL needsReload;


@property (nonatomic,assign) CGSize pageSize;

@property (nonatomic,assign) NSInteger pageCount;

@property (nonatomic,strong) NSMutableArray *cells;
@property (nonatomic,assign) NSRange visibleRange;

@property (nonatomic,strong) NSMutableArray *reusableCells;

@property (nonatomic,assign)   id <JQFlowViewDataSource> dataSource;
@property (nonatomic,assign)   id <JQFlowViewDelegate>   delegate;

@property (nonatomic,retain)  UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat minimumPageAlpha;

@property (nonatomic, assign) CGFloat minimumPageScale;

@property (nonatomic, assign) BOOL isOpenAutoScroll;

@property (nonatomic, assign) BOOL isCarousel;

@property (nonatomic, assign, readonly) NSInteger currentPageIndex;

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) CGFloat autoTime;

@property (nonatomic, assign) NSInteger orginPageCount;

- (void)reloadData;

- (UIView *)dequeueReusableCell;

- (void)scrollToPage:(NSUInteger)pageNumber;

- (void)stopTimer;

@end


@protocol  JQFlowViewDelegate<NSObject>

- (CGSize)sizeForPageInFlowView:(JQFlowView *)flowView;

@optional

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(JQFlowView *)flowView;

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@protocol JQFlowViewDataSource <NSObject>

- (NSInteger)numberOfPagesInFlowView:(JQFlowView *)flowView;

- (UIView *)flowView:(JQFlowView *)flowView cellForPageAtIndex:(NSInteger)index;

@end
