//
//  TJPackageListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/2/2.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJPackageListViewController.h"
#import "GetBigItemApi.h"
#import "GetSubNewApi.h"
#import "BigItemModel.h"
#import "TJItemTableviewCell.h"
#import "GetListNewRequest.h"
#import "TJServiceDetailViewController.h"
#import "TJSubMenuViewController.h"
#import "PhysicalTp1ViewController.h"
@interface TJPackageListViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSString *pid;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)GetBigItemApi *api;
@property (nonatomic,strong)UITableView *OrderTableView;
@property (nonatomic,strong)NSMutableArray *orderListArray;
@end

@implementation TJPackageListViewController

- (NSMutableArray *)orderListArray{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}


- (id)initWithOrderStatus:(NSString *)pid name:(NSString *)name{
    if (self = [super initWithNibName:nil bundle:nil]) {
        self.pid = pid;
        self.name = name;
    }
    return self;
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [self.OrderTableView.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.OrderTableView];
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.OrderTableView withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无订单" operationText:nil operationBlock:nil];
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

- (GetBigItemApi *)api
{
    
    if (!_api) {
        
        _api = [[GetBigItemApi alloc]init];
        
        _api.delegate  =self;
        
    }
    
    return _api;
    
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
    
    self.title = self.name;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    [self.view addSubview:self.OrderTableView];
    
    [self.OrderTableView registerClass:[TJItemTableviewCell class] forCellReuseIdentifier:NSStringFromClass([TJItemTableviewCell class])];
    
    self.OrderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        SubNewHeader *head = [[SubNewHeader alloc]init];
        
        head.target = @"tjjyServeControl";
        
        head.method = @"getTcsList";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        SubNewBody *body = [[SubNewBody alloc]init];
        body.type = self.pid;
        GetListNewRequest *request = [[GetListNewRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api sublistDetail:request.mj_keyValues.mutableCopy];
    }];
    [self.OrderTableView.mj_header beginRefreshing];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    return 119.5;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.orderListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TJItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJItemTableviewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BigItemModel *model = [self.orderListArray objectAtIndex:indexPath.row];
    
    [cell refreshWIthModel:model];
  
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BigItemModel *model = [self.orderListArray objectAtIndex:indexPath.row];
    if ([model.id isEqualToString:@"19"]) {
        TJSubMenuViewController *subMenu = [TJSubMenuViewController new];
        subMenu.id = model.id;
        [self.navigationController pushViewController:subMenu animated:YES];
    }else if ([model.id isEqualToString:@"16"]){
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        physical.id = model.id;
        physical.hidesBottomBarWhenPushed = YES;
        physical.title  = model.name;
        [self.navigationController pushViewController:physical animated:YES];
        
    }else if ([model.id isEqualToString:@"17"]){
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        physical.id = model.id;
        physical.hidesBottomBarWhenPushed = YES;
        physical.title  = model.name;
        [self.navigationController pushViewController:physical animated:YES];
    }else if ([model.id isEqualToString:@"18"]){
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        physical.id = model.id;
        physical.hidesBottomBarWhenPushed = YES;
        physical.title  = model.name;
        [self.navigationController pushViewController:physical animated:YES];
    }else{
        TJServiceDetailViewController *detail = [TJServiceDetailViewController new];
        detail.title = model.name;
        detail.id = model.id;
        detail.zilist = model.zilist;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}


@end
