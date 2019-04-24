//
//  AppionmentListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentListViewController.h"
#import "SegmentContainer.h"
#import "AppionmentInnerViewController.h"
static NSString const * statusKey = @"status";
static NSString const * statusNameKey = @"name";
@interface AppionmentListViewController ()<SegmentContainerDelegate>
@property (nonatomic, strong) SegmentContainer *container;
@property (nonatomic, strong) NSArray *orderStatusArray;
@end

@implementation AppionmentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会诊请求";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self configOrderStatus];
    
    [self.view addSubview:self.container];
    
    [self selectOrderStatus];
    
}

#pragma mark - Helper
- (void)configOrderStatus {
    self.orderStatusArray = @[@{statusKey:AppionmentReqStatusAll, statusNameKey:@"全部"},
                              @{statusKey:AppionmentReqStatusWaitReview, statusNameKey:@"待审核"},
                              @{statusKey:AppionmentReqStatusWaitAppionment, statusNameKey:@"待会诊"},
                              @{statusKey:AppionmentReqStatusFinished, statusNameKey:@"已完成"},
                              ];
}

- (void)selectOrderStatus {
    if (!self.orderStatus || self.orderStatus.length <= 0) {
        self.orderStatus = OrderReqStatusAllOrder;
    }
    
    for (NSDictionary *dic in self.orderStatusArray) {
        NSString *status = [dic objectForKey:statusKey];
        if ([status isEqualToString:self.orderStatus]) {
            NSUInteger index = [self.orderStatusArray indexOfObject:dic];
            [self.container setSelectedIndex:index withAnimated:YES];
        }
    }
}

#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.titleFont = [UIFont systemFontOfSize:15.0f];
        _container.titleNormalColor = DefaultGrayLightTextClor;
        _container.titleSelectedColor = AppStyleColor;
        _container.indicatorColor = AppStyleColor;
        _container.minIndicatorWidth = kScreenWidth/8;
        _container.containerBackgroundColor = [UIColor whiteColor];
    }
    return _container;
}

#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.orderStatusArray.count;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    return [dic objectForKey:statusNameKey];
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    NSDictionary *dic = [self.orderStatusArray safeObjectAtIndex:index];
    AppionmentInnerViewController *listVC = [[AppionmentInnerViewController alloc] initWithOrderStatus:[dic objectForKey:statusKey]];
    return listVC;
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
