//
//  MyconponViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyconponViewController.h"
#import "ConponTableViewCell.h"
#import "MyconponListApi.h"
#import "MyconponListRequest.h"
#import "MyconponListModel.h"
@interface MyconponViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)MyconponListApi *myconponApi;
@property (nonatomic,strong)NSMutableArray *myconponArray;

@end

@implementation MyconponViewController

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
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self setLAyout];
    //
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        MyconponListHeader *myconponHead = [[MyconponListHeader alloc]init];
        
        myconponHead.target = @"couponControl";
        
        myconponHead.method = @"myCouponList";
        
        myconponHead.versioncode = Versioncode;
        
        myconponHead.devicenum = Devicenum;
        
        myconponHead.fromtype = Fromtype;
        
        myconponHead.token = [User LocalUser].token;
        
        MyconponListBody *myconponBody = [[MyconponListBody alloc]init];
        
        MyconponListRequest *myconponRequest = [[MyconponListRequest alloc]init];
        
        myconponRequest.head = myconponHead;
        
        myconponRequest.body = myconponBody;
        
        [self.myconponApi getConponList:myconponRequest.mj_keyValues.mutableCopy];
    }];
  
    [self.tableview.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//api
- (MyconponListApi *)myconponApi{
    if (!_myconponApi) {
        _myconponApi = [[MyconponListApi alloc]init];
        _myconponApi.delegate  = self;
    }
    return _myconponApi;
}
- (NSMutableArray *)myconponArray{
    if (!_myconponArray) {
        _myconponArray = [NSMutableArray array];
    }
    return _myconponArray;
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
        [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无优惠券" operationText:nil operationBlock:nil];
    } else {
        [self.myconponArray removeAllObjects];
        [self.myconponArray addObjectsFromArray:responsObject];
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
            return 13;
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
    [cell refreshWithMyconponModel:model];
    return cell;
}

@end
