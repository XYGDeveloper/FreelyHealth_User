//
//  TJPackageViewController.m
//  FreelyHeath
//
//  Created by L on 2018/2/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJPackageViewController.h"
#import "SegmentContainer.h"
#import "TJPackageListViewController.h"
#import "GetListNewRequest.h"
#import "GetSubNewApi.h"
#import "NewModel.h"
#import "TJPackageListViewController.h"
@interface TJPackageViewController ()<SegmentContainerDelegate,ApiRequestDelegate>

@property (nonatomic, strong) SegmentContainer *container;
@property (nonatomic, strong) NSArray *idStatusArray;
@property (nonatomic, strong) NSMutableArray *orderStatusArray;
@property (nonatomic,strong)GetSubNewApi *api;

@end

@implementation TJPackageViewController

- (NSMutableArray *)orderStatusArray{
    if (!_orderStatusArray) {
        _orderStatusArray = [NSMutableArray array];
    }
    return _orderStatusArray;
}

- (GetSubNewApi *)api{
    if (!_api) {
        _api = [[GetSubNewApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"体检套餐";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    SubNewHeader *head = [[SubNewHeader alloc]init];
    head.target = @"tjjyServeControl";
    head.method = @"getTcsListFirst";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    SubNewBody *body = [[SubNewBody alloc]init];
    GetListNewRequest *request = [[GetListNewRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api sublistDetail:request.mj_keyValues.mutableCopy];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    self.orderStatusArray = responsObject;
    _container.minIndicatorWidth = kScreenWidth/self.orderStatusArray.count;
    [self.view addSubview:self.container];
}

#pragma mark - Properties
- (SegmentContainer *)container {
    if (!_container) {
        _container = [[SegmentContainer alloc] initWithFrame:CGRectMake(0,0, kScreenWidth,kScreenHeight)];
        _container.parentVC = self;
        _container.delegate = self;
        _container.titleFont = [UIFont systemFontOfSize:17.0f];
        _container.titleNormalColor = DefaultGrayLightTextClor;
        _container.titleSelectedColor = AppStyleColor;
        _container.indicatorColor = AppStyleColor;
        _container.containerBackgroundColor = [UIColor whiteColor];
    }
    return _container;
}

#pragma mark - SegmentContainerDelegate
- (NSUInteger)numberOfItemsInSegmentContainer:(SegmentContainer *)segmentContainer {
    return self.orderStatusArray.count;
}

- (NSString *)segmentContainer:(SegmentContainer *)segmentContainer titleForItemAtIndex:(NSUInteger)index {
    NewModel *item = [self.orderStatusArray objectAtIndex:index];
    return item.name;
}

- (id)segmentContainer:(SegmentContainer *)segmentContainer contentForIndex:(NSUInteger)index {
    NewModel *item = [self.orderStatusArray objectAtIndex:index];
    TJPackageListViewController *listVC = [[TJPackageListViewController alloc] initWithOrderStatus:item.type name:item.name];
    return listVC;
}

- (void)segmentContainer:(SegmentContainer *)segmentContainer didSelectedItemAtIndex:(NSUInteger)index {
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



@end
