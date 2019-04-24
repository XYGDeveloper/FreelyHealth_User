//
//  SubscribeListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SubscribeListViewController.h"
#import "SubscribTableViewCell.h"
#import "EditSubsViewController.h"
#import "SubModel.h"
#import "MySubListRequest.h"
#import "GetSubListApi.h"
#import "EmptyManager.h"
#import "ToSubsViewController.h"
@interface SubscribeListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *subTableView;
@property (nonatomic,strong)NSMutableArray *orderListArray;
@property (nonatomic,strong)GetSubListApi *api;
@end

@implementation SubscribeListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.subTableView.mj_header beginRefreshing];
}

- (GetSubListApi *)api{
    if (!_api) {
        _api = [[GetSubListApi alloc]init];
        _api.delegate =self;
    }
    return _api;
}
- (NSMutableArray *)orderListArray{
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}

- (void)toYuyue{
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        ToSubsViewController *tosubs = [[ToSubsViewController alloc]init];
        [self.navigationController pushViewController:tosubs animated:YES];
    }
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self setRightNavigationItemWithTitle:@"预约" action:@selector(toYuyue)];
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.title = @"我的体检预约";
    
    [self.view addSubview:self.subTableView];
    
    [self.subTableView registerClass:[SubscribTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SubscribTableViewCell class])];
    
    self.subTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        SubListHeader *head = [[SubListHeader alloc]init];

        head.target = @"orderControl";

        head.method = @"myYuyues";

        head.versioncode = Versioncode;

        head.devicenum = Devicenum;

        head.fromtype = Fromtype;

        head.token = [User LocalUser].token;

        SubListBody *body = [[SubListBody alloc]init];

        MySubListRequest *request = [[MySubListRequest alloc]init];

        request.head = head;

        request.body = body;

        NSLog(@"%@",request);

        [self.api sublist:request.mj_keyValues.mutableCopy];

    }];


    [self.subTableView.mj_header beginRefreshing];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.subTableView.mj_header endRefreshing];
    
    if (self.orderListArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.subTableView response:command.response operationBlock:^{
            strongify(self)
            [self.subTableView.mj_header beginRefreshing];
        }];
    }
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.subTableView.mj_header endRefreshing];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.subTableView];
    
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.subTableView withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无预约列表" operationText:@"去预约" operationBlock:^{
            ToSubsViewController *tosubs = [[ToSubsViewController alloc]init];
            [self.navigationController pushViewController:tosubs animated:YES];
        }];
        
    } else {
        [self.orderListArray removeAllObjects];
        [self.orderListArray addObjectsFromArray:responsObject];
        [self.subTableView reloadData];
    }

}

- (void)back{
    
    if (self.orderEnter == YES) {
        [Utils jumpToHomepage];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (UITableView *)subTableView
{
    
    if (!_subTableView) {
        
        _subTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        
        _subTableView.delegate = self;
        
        _subTableView.dataSource = self;
        
        _subTableView.backgroundColor = DefaultBackgroundColor;
        
    }
    
    return _subTableView;
    
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
    
    return 137.5;
//    return [tableView fd_heightForCellWithIdentifier:@"TeamDesTableViewCell" cacheByIndexPath:indexPath configuration: ^(TeamDesTableViewCell *cell) {
//
//        [cell refreshSubviewWithModel:self.model];
//
//    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscribTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubscribTableViewCell class])];
    SubModel *model = [self.orderListArray objectAtIndex:indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.et = ^{
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            EditSubsViewController *edit = [[EditSubsViewController alloc]init];
            edit.id = model.id;
            [self.navigationController pushViewController:edit animated:YES];
        }
       
    };

    [cell refreshWithModel:model];

    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        SubModel *model = [self.orderListArray objectAtIndex:indexPath.row];
        EditSubsViewController *edit = [[EditSubsViewController alloc]init];
        edit.id = model.id;
        [self.navigationController pushViewController:edit animated:YES];
    }

}

@end
