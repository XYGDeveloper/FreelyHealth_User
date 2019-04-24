//
//  OrderConponListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderConponListViewController.h"
#import "ConponTableViewCell.h"
#import "OrderConponListApi.h"
#import "MyconponListRequest.h"
#import "MyconponListModel.h"
@interface OrderConponListViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)OrderConponListApi *myconponApi;
@property (nonatomic,strong)NSMutableArray *myconponArray;
@property (nonatomic,strong)UIView *headview;

@end

@implementation OrderConponListViewController

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[ConponTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ConponTableViewCell class])];
        self.view.backgroundColor = DefaultBackgroundColor;
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.separatorColor = DefaultBackgroundColor;
    }
    return _tableview;
}

- (void)setLAyout{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headview = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 50)];
    self.headview.backgroundColor = DefaultBackgroundColor;
    UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:DefaultBlackLightTextClor forState:UIControlStateNormal];
    [button setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = DefaultBackgroundColor.CGColor;
    button.layer.borderWidth = 1.0f;
    [self.headview addSubview:button];
    
    [button addTarget:self action:@selector(noUse) forControlEvents:UIControlEventTouchUpInside];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headview.mas_centerX);
        make.width.mas_equalTo(kScreenWidth - 20);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    self.tableview.tableHeaderView = self.headview;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self setLAyout];
    //
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        MyconponListHeader *myconponHead = [[MyconponListHeader alloc]init];
        
        myconponHead.target = @"couponControl";
        
        myconponHead.method = @"myOrderCouponList";
        
        myconponHead.versioncode = Versioncode;
        
        myconponHead.devicenum = Devicenum;
        
        myconponHead.fromtype = Fromtype;
        
        myconponHead.token = [User LocalUser].token;
        
        MyconponListBody *myconponBody = [[MyconponListBody alloc]init];
        
        myconponBody.id = self.id;
        myconponBody.zilist = self.zilist;
        myconponBody.type = self.type;

        MyconponListRequest *myconponRequest = [[MyconponListRequest alloc]init];
        
        myconponRequest.head = myconponHead;
        
        myconponRequest.body = myconponBody;
        
        [self.myconponApi getorderConponList:myconponRequest.mj_keyValues.mutableCopy];
    }];
    
    [self.tableview.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}
- (void)noUse{
    if (self.noconpon) {
        self.noconpon();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//api
- (OrderConponListApi *)myconponApi{
    if (!_myconponApi) {
        _myconponApi = [[OrderConponListApi alloc]init];
        _myconponApi.delegate  = self;
    }
    return _myconponApi;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [self.tableview.mj_header endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
    if (self.myconponArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
            strongify(self)
            [self.tableview.mj_header beginRefreshing];
        }];
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"无优惠券列表" operationText:nil operationBlock:nil];
    } else {
        self.myconponArray  = [NSMutableArray array];
        [self.myconponArray removeAllObjects];
        for (MyconponListModel *model in responsObject) {
            if ([model.id isEqualToString:self.cid]) {
                model.status = @"1";
            }else{
                model.status = @"0";
            }
            [self.myconponArray addObject:model];
        }
      
        [self.tableview reloadData];
    }
}
#pragma mark- UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myconponArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 161;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return 13;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConponTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConponTableViewCell class])];
    cell.backgroundColor = DefaultBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyconponListModel *model = [self.myconponArray objectAtIndex:indexPath.row];
    [cell refreshWithMyOrderconponModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyconponListModel *model = [self.myconponArray objectAtIndex:indexPath.row];
    if (self.conpon) {
        self.conpon(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
