
//
//  NBBannerView.m
//  页面分离
//
//  Created by xxzx on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NBBannerView.h"
#import "NBBannerCell.h"
#import "NBBannerModelProtocol.h"
#import "NBBannerFlowLayout.h"
#import "Masonry.h"
#import "NBBannerConfig.h"

static NSInteger kLength = 10;

@interface NBBannerView()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _currentIndex;    // 当前的index
    CGFloat _dragStartX;        // 拖拽开始的index
    CGFloat _dragEndX;          // 拖拽结束的index
    NSTimer *_timer;            // 定时器
}
// collectionView
@property(nonatomic, strong) UICollectionView *collectionView;
// 虚化背景
@property(nonatomic, strong) UIImageView *imageView;
// 底部指示点
@property(nonatomic, strong) UIPageControl *pageControl;
// layout
@property(nonatomic, strong) NBBannerFlowLayout *layout;
// 属性配置
@property(nonatomic, strong) NBBannerConfig *config;

@property(nonatomic, copy) NBBannerConfigBlock bannarConfigBlock;

@property(nonatomic, copy) NBLoadImageBlock loadImgBlock;

@property(nonatomic, copy) NBLoadImageBlock loadBlurEffectBlock;

@end

@implementation NBBannerView

//
- (void)setBannerModels:(NSArray<id<NBBannerModelProtocol>> *)bannerModels
{
    
    if (bannerModels.count == 0) { return; }
    //处理模型 实现无限滚动
    _bannerModels = bannerModels;
    
    _currentIndex = kLength/2*bannerModels.count;//bannerModels.count * 1000;
    
    // 设置背景等属性
    self.imageView.subviews.firstObject.hidden = !self.config.isShowBlurEffectView;
    self.collectionView.backgroundColor = self.config.bgColor;
    self.imageView.backgroundColor = self.config.blurEffectViewColor;
    // 设置pageControl属性
    self.pageControl.pageIndicatorTintColor = self.config.pageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = self.config.currentPageIndicatorTintColor;
    self.pageControl.numberOfPages = bannerModels.count;
    
    //设置初始位置
    id <NBBannerModelProtocol>model = bannerModels.firstObject;
    if (self.loadBlurEffectBlock && self.config.showBlurEffectView) {
        self.loadBlurEffectBlock(self.imageView, model.adImgURL);
    }
    [self.collectionView reloadData];
    [self layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //开启定时器
    [self stopTimer];
    [self startTimer];

}


+ (instancetype)bannerViewWithConfig:(NBBannerConfigBlock)bannarConfigBlock loadImageBlock:(NBLoadImageBlock)loadImgBlock  loadBlurEffectBlock:(NBLoadImageBlock)loadBlurEffectBlock
{
    NBBannerView *bannerView = [[NBBannerView alloc] init];
    if (bannarConfigBlock) {
        bannarConfigBlock(bannerView.config);
    }
    bannerView.loadImgBlock = loadImgBlock;
    bannerView.loadBlurEffectBlock = loadBlurEffectBlock;
    return bannerView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self collectionView];
    
    [self pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.bannerModels) { return; }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - 私有方法
//配置cell居中
- (void)fixCellToCenter {
    
    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _currentIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collectionView numberOfItemsInSection:0] - 1;
    _currentIndex = _currentIndex <= 0 ? 0 : _currentIndex;
    _currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex;
    
    [self scrollToCenter];
}

- (void)scrollToCenter {
    
    //如果是最后一张图
    if (_currentIndex == self.bannerModels.count*kLength - 1) {
        _currentIndex = kLength/2*self.bannerModels.count-1;
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        id <NBBannerModelProtocol>model = self.bannerModels[_currentIndex%self.bannerModels.count];
        if (self.loadBlurEffectBlock && self.config.showBlurEffectView) {
            self.loadBlurEffectBlock(self.imageView, model.adImgURL);
        }
        return;
    }
    //第一张图
    else if (_currentIndex == 0) {
        
        _currentIndex = kLength/2*self.bannerModels.count;;
        //        NSLog(@"+++++%ld",_currentIndex);
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        id <NBBannerModelProtocol>model = self.bannerModels[_currentIndex%self.bannerModels.count];
        if (self.loadBlurEffectBlock && self.config.showBlurEffectView) {
            self.loadBlurEffectBlock(self.imageView, model.adImgURL);
        }
        return;
    }
    
    //在这写入要计算时间的代码
//    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    id <NBBannerModelProtocol>model = self.bannerModels[_currentIndex%self.bannerModels.count];
    if (self.loadBlurEffectBlock && self.config.showBlurEffectView) {
        self.loadBlurEffectBlock(self.imageView, model.adImgURL);
    }
    
    self.pageControl.currentPage = _currentIndex%(self.bannerModels.count%kLength);

    
}


#pragma mark - 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bannerModels.count*kLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id <NBBannerModelProtocol>bannarM = self.bannerModels[indexPath.item%self.bannerModels.count];
    NBBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NBBannerCell class]) forIndexPath:indexPath];
    cell.config = self.config;
    cell.bannerModel = bannarM;
    cell.textLabel.text = bannarM.title;
    cell.layer.shadowColor = DefaultGrayLightTextClor.CGColor;//阴影颜色
    cell.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    cell.layer.shadowOpacity = 0.5;//不透明度
    cell.layer.shadowRadius = 7.0;//半径
    if (self.loadImgBlock) {
        self.loadImgBlock(cell.imageView, bannarM.adImgURL);
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width-self.config.midCardEdgeInsets.left-self.config.midCardEdgeInsets.right, collectionView.bounds.size.height-self.config.midCardEdgeInsets.top-self.config.midCardEdgeInsets.bottom);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.config.midCardEdgeInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.config.kCardHorizontalSpace;
}

#pragma mark - UIScrollViewDelegate
//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _dragStartX = scrollView.contentOffset.x;
    [self stopTimer];
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });

    [self startTimer];
}

/*
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _currentIndex = self.collectionView.contentOffset.x / self.collectionView.contentSize.width;
    [self startTimer];
}
 */

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//
//    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
//    CGPoint pInView = [self convertPoint:self.collectionView.center toView:self.collectionView];
//    // 获取这一点的indexPath
//    NSIndexPath *indexPathNow = [self.collectionView indexPathForItemAtPoint:pInView];
//    // 赋值给记录当前坐标的变量
//    _currentIndex = indexPathNow.item;
//
//    [self startTimer];
//    NSLog(@"停止了%zd",_currentIndex);
//}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentIndex = indexPath.row;
    [self scrollToCenter];
    [self stopTimer];
    [self startTimer];
    
    if (self.bannarClickBlock && self.bannerModels.count>0) {
        self.bannarClickBlock(self.pageControl.currentPage);
    }
}


//- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"这是可见的cell%zd",indexPath.item);
//}

#pragma mark - 定时器相关
- (void)startTimer {
    //如果只有一张图片，则直接返回，开启定时器
    if (self.bannerModels.count == 0) return;
    //如果定时器已开启，先停止再重新开启
    if (_timer){
        [self stopTimer];
    }
//    NSTimeInterval timeInterval = _timeInterval ? (_timeInterval >= 1 ?: 1) : DefaultTime;
    _timer = [NSTimer timerWithTimeInterval:self.config.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)nextPage {
    
    _currentIndex += 1;
    
    [self scrollToCenter];
}

#pragma mark - 懒加载
- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        [self addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
    return _pageControl;
}
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
//        _imageView.backgroundColor = [UIColor redColor];
//        [self addSubview:_imageView];
        [self insertSubview:_imageView atIndex:0];
        
        UIBlurEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [_imageView addSubview:effectView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_imageView);
        }];
    }
    return _imageView;
}

-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self addSubview:_collectionView];
        [_collectionView registerClass:[NBBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([NBBannerCell class])];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _collectionView;
}

- (NBBannerFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[NBBannerFlowLayout alloc] init];
        [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    }
    return _layout;
}

- (NBBannerConfig *)config
{
    if (_config == nil) {
        _config = [[NBBannerConfig alloc] init];
    }
    return _config;
}


@end
