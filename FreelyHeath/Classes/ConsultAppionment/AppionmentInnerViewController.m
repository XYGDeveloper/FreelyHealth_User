//
//  AppionmentInnerViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentInnerViewController.h"
#import "AppionmentListTableViewCell.h"
#import "OrderListApi.h"
#import "AppionmentListModel.h"
#import "SubscribOrderViewController.h"
#import "AppionmentListApi.h"
#import "AppionmentListRequest.h"
#import "AuditedViewController.h"
#import "AppionmentFInishViewController.h"
#import "AppionmentReviewViewController.h"
#import "WailtToPayViewController.h"
#import "AuditedViewController.h"
#import "PayFinishViewController.h"
#import "AppionmentDetailViewController.h"
@interface AppionmentInnerViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic,strong)UITableView *OrderTableView;
@property (nonatomic,strong)AppionmentListApi *listApi;
@property (nonatomic,strong)NSMutableArray *AppionmentListArray;
@end

@implementation AppionmentInnerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.orderStatus = orderStatus;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canAppion:) name:@"cancelAppionment" object:nil];
    }
    return self;
}
-(void)canAppion:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"cancelAppionment"]) {
        AppionmentListHeader *head = [[AppionmentListHeader alloc]init];
        head.target = @"userHuizhenControl";
        head.method = @"userHuizhenList";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        AppionmentListBody *body = [[AppionmentListBody alloc]init];
        body.type = self.orderStatus;
        AppionmentListRequest *request = [[AppionmentListRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.listApi getAppionmentList:request.mj_keyValues.mutableCopy];
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [self.OrderTableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.OrderTableView];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"%@",array);
    if (array.count <= 0) {
        NSString *message;
        if ([self.orderStatus isEqualToString:@"1"]) {
            message = @"暂无数据";
        }else if ([self.orderStatus isEqualToString:@"2"]) {
            message = @"暂无待审核会诊记录";
        }else if ([self.orderStatus isEqualToString:@"3"]) {
            message = @"暂无待会诊记录";
        }else{
            message = @"暂无已完成会诊记录";
        }
        [[EmptyManager sharedManager] showEmptyOnView:self.OrderTableView withImage:[UIImage imageNamed:@"bingli_empty"] explain:message operationText:nil operationBlock:nil];
    } else {
        [self.AppionmentListArray removeAllObjects];
        [self.AppionmentListArray addObjectsFromArray:responsObject];
        [self.OrderTableView reloadData];
    }
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.OrderTableView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    if (self.AppionmentListArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.OrderTableView response:command.response operationBlock:^{
            strongify(self)
            [self.OrderTableView.mj_header beginRefreshing];
        }];
    }
}



- (AppionmentListApi *)listApi
{
    if (!_listApi) {
        _listApi = [[AppionmentListApi alloc]init];
        _listApi.delegate  =self;
    }
    return _listApi;
}

- (NSMutableArray *)AppionmentListArray
{
    if (!_AppionmentListArray) {
        _AppionmentListArray = [NSMutableArray array];
    }
    return _AppionmentListArray;
}

- (UITableView *)OrderTableView
{
    if (!_OrderTableView) {
        _OrderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _OrderTableView.delegate = self;
        _OrderTableView.dataSource = self;
        _OrderTableView.backgroundColor = DefaultBackgroundColor;
    }
    return _OrderTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.OrderTableView];
    
    [self.OrderTableView registerClass:[AppionmentListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentListTableViewCell class])];
    
    self.OrderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        AppionmentListHeader *head = [[AppionmentListHeader alloc]init];
        head.target = @"userHuizhenControl";
        head.method = @"userHuizhenList";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        AppionmentListBody *body = [[AppionmentListBody alloc]init];
        body.type = self.orderStatus;
        AppionmentListRequest *request = [[AppionmentListRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.listApi getAppionmentList:request.mj_keyValues.mutableCopy];
    }];
    
    self.OrderTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        //
    }];
    
    [self.OrderTableView.mj_header beginRefreshing];
    
}

- (void)layOutSubview{
    [self.OrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else{
            return 0;
        }
        
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (@available(iOS 11.0, *)) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
    } else {
        
        return nil;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.AppionmentListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppionmentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AppionmentListModel *model = [self.AppionmentListArray objectAtIndex:indexPath.row];
    [cell refreshWithAppionmentModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppionmentListModel *model = [self.AppionmentListArray objectAtIndex:indexPath.row];
    
    AppionmentDetailViewController *detail = [AppionmentDetailViewController new];
    detail.id = model.id;
    detail.title = @"会诊详情";
//    review.type = model.status;
    [self.navigationController pushViewController:detail animated:YES];
//    if ([model.status isEqualToString:@"1"]) { //当前列表状态  1 预约未后台审核2 后台审核 未支付3 支付未完成 4完成
//        AppionmentReviewViewController *review = [AppionmentReviewViewController new];
//        review.id = model.id;
//        review.type = model.status;
//        review.title = @"会诊详情";
//        [self.navigationController pushViewController:review animated:YES];
//
//    }else if ([model.status isEqualToString:@"2"]){
//        //未支付状态页面
//         WailtToPayViewController *review = [WailtToPayViewController new];
//         review.id = model.id;
//         review.type = model.status;
//         review.title = @"会诊详情";
//        [self.navigationController pushViewController:review animated:YES];
//    }else if ([model.status isEqualToString:@"3"]){
//        AuditedViewController *huizhen = [AuditedViewController new];
//        huizhen.id = model.id;
//        huizhen.type = model.status;
//        huizhen.title = @"会诊详情";
//        [self.navigationController pushViewController:huizhen animated:YES];
//    }else{
//
//    }
//        //已支付状态页面
//        PayFinishViewController *review = [PayFinishViewController new];
//        review.id = model.id;
//        review.type = model.status;
//        review.title = @"会诊详情";
//        [self.navigationController pushViewController:review animated:YES];
//    }else if ([model.status isEqualToString:@"5"]){  //待会诊  会诊群聊
//        AuditedViewController *huizhen = [AuditedViewController new];
//        huizhen.id = model.id;
//        huizhen.type = model.status;
//        huizhen.title = @"会诊详情";
//        [self.navigationController pushViewController:huizhen animated:YES];
//    }else if ([model.status isEqualToString:@"4"]){  //已完成
//        //已完成和已取消界面相同，只不过状态不一样
//        AppionmentFInishViewController *finish = [AppionmentFInishViewController new];
//        finish.id = model.id;
//        finish.type = model.status;
//        finish.title = @"会诊详情";
//        [self.navigationController pushViewController:finish animated:YES];
//
//    }else if ([model.status isEqualToString:@"2"]){
//
//    }else if ([model.status isEqualToString:@"2"]){
//
//    }
//    else{
//        AppionmentReviewViewController *review = [AppionmentReviewViewController new];
//        review.id = model.id;
//        review.type = model.status;
//        review.title = @"会诊详情";
//        [self.navigationController pushViewController:review animated:YES];
//    }
}

@end
