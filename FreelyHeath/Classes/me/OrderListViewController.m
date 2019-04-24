//
//  OrderListViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"
#import "OrderListModel.h"
#import "OrderListRequest.h"
#import "OrderListApi.h"
#import "SubscribOrderViewController.h"
#import "HZOrderDetailViewController.h"
@interface OrderListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *OrderTableView;

@property (nonatomic,strong)OrderListApi *listApi;

@property (nonatomic,strong)NSMutableArray *orderListArray;

@property (nonatomic, copy) NSString *orderStatus;


@end

@implementation OrderListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithOrderStatus:(NSString *)orderStatus {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
        self.orderStatus = orderStatus;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:KNotification_cancel object:nil];

         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationRecieved:) name:kOrderPaySuccessNotify object:nil];
    }
    return self;
}

- (void)notificationRecieved:(NSNotification *)note {
    
    if ([note.name isEqualToString:KNotification_cancel] ||[note.name isEqualToString:KNotification_RefreshList] ||[note.name isEqualToString:kOrderPaySuccessNotify] ) {//跳转到订单列表
        [self.OrderTableView.mj_header beginRefreshing];
        
    }
}



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [self.OrderTableView.mj_footer resetNoMoreData];
    [self.OrderTableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.OrderTableView];
    
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"%@",array);

    if (array.count <= 0) {
        NSString *message;
        if ([self.orderStatus isEqualToString:@"1"]) {
            message = @"暂无未支付订单";
        }else if ([self.orderStatus isEqualToString:@"2"]) {
            message = @"暂无进行中订单";
        }else if ([self.orderStatus isEqualToString:@"3"]) {
            message = @"暂无已完成订单";
        }else{
            message = @"暂无全部订单";
        }
        [[EmptyManager sharedManager] showEmptyOnView:self.OrderTableView withImage:[UIImage imageNamed:@"bingli_empty"] explain:message operationText:nil operationBlock:nil];
    } else {
        [self.orderListArray removeAllObjects];
        [self.orderListArray addObjectsFromArray:responsObject];
        [self.OrderTableView reloadData];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.OrderTableView.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    if (self.orderListArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.OrderTableView response:command.response operationBlock:^{
            strongify(self)
            [self.OrderTableView.mj_header beginRefreshing];
        }];
    }
}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.OrderTableView.mj_footer endRefreshing];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.OrderTableView.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.OrderTableView.mj_footer endRefreshingWithNoMoreData];
}

- (OrderListApi *)listApi
{
    if (!_listApi) {
        _listApi = [[OrderListApi alloc]init];
        _listApi.delegate  =self;
    }
    return _listApi;
}

- (NSMutableArray *)orderListArray
{
    
    if (!_orderListArray) {
        
        _orderListArray = [NSMutableArray array];
    }
    
    return _orderListArray;
    
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
    
    self.title = @"我的订单";
    
    [self.view addSubview:self.OrderTableView];
    
    [self.OrderTableView registerNib:[UINib nibWithNibName:@"OrderListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderListTableViewCell class])];
    
    self.OrderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        OrderListHeader *head = [[OrderListHeader alloc]init];
        
        head.target = @"ownControl";
        
        head.method = @"getOrdersListByCondition";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        OrderListBody *body = [[OrderListBody alloc]init];
        
        body.status = self.orderStatus;
        
        OrderListRequest *request = [[OrderListRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.listApi getOrderList:request.mj_keyValues.mutableCopy];
        
    }];
    
    self.OrderTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        //
    }];
    
    [self.OrderTableView.mj_header beginRefreshing];
    
}

//- (void)layOutSubview{
//
//    [self.OrderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.left.right.bottom.mas_equalTo(0);
//
//    }];
//
//}

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
    
    return 119.5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    OrderListModel *model = [self.orderListArray objectAtIndex:indexPath.row];

    [cell refreshWithModel:model];

    cell.step = ^{
        if ([model.type isEqualToString:@"2"]) {
            SubscribOrderViewController *subdetail = [SubscribOrderViewController new];
            subdetail.orderid = model.id;
            [self.navigationController pushViewController:subdetail animated:YES];
        }else if([model.type isEqualToString:@"1"]){
            OrderDetailViewController *detail = [OrderDetailViewController new];
            detail.ID = model.id;
            [self.navigationController pushViewController:detail animated:YES];
        }else{
            SubscribOrderViewController *subdetail = [SubscribOrderViewController new];
            subdetail.hzDetail = YES;
            subdetail.orderid = model.id;
            [self.navigationController pushViewController:subdetail animated:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListModel *model = [self.orderListArray objectAtIndex:indexPath.row];

    if ([model.type isEqualToString:@"2"]) {
        SubscribOrderViewController *subdetail = [SubscribOrderViewController new];
        subdetail.orderid = model.id;
        [self.navigationController pushViewController:subdetail animated:YES];
    }else if([model.type isEqualToString:@"1"]){
        OrderDetailViewController *detail = [OrderDetailViewController new];
        detail.ID = model.id;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        HZOrderDetailViewController *subdetail = [HZOrderDetailViewController new];
        subdetail.orderid = model.id;
        subdetail.hzDetail = YES;
        [self.navigationController pushViewController:subdetail animated:YES];
    }
    
}




@end
