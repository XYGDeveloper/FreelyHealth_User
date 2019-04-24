//
//  BLListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BLListViewController.h"
#import "SelectBLTableViewCell.h"
#import "CaseListModel.h"
#import "CaseListApi.h"
#import "CaseListRequest.h"
#import "AddCaseViewController.h"
@interface BLListViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIButton *addBLbutton;
@property (nonatomic,strong)CaseListApi *api;
@property (nonatomic,strong)NSMutableArray *caselist;
@property (nonatomic,strong)NSMutableArray *caselist1;

@end

@implementation BLListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableview.mj_header beginRefreshing];
}

- (CaseListApi *)api{
    if (!_api) {
        _api = [[CaseListApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}
- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.addBLbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

- (UIButton *)addBLbutton{
    if (!_addBLbutton) {
        _addBLbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBLbutton.backgroundColor = AppStyleColor;
        [_addBLbutton setTitle:@"新增病历" forState:UIControlStateNormal];
        [_addBLbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBLbutton.titleLabel.font = FontNameAndSize(18);
        [_addBLbutton addTarget:self action:@selector(addBl:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBLbutton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utils addHudOnView:self.view withTitle:@"正在加载..."];
    caseListHeader *header = [[caseListHeader alloc]init];
    header.target = @"bingLiControl";
    header.method = @"blList";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    caseListBody *bodyer = [[caseListBody alloc]init];
    CaseListRequest *requester = [[CaseListRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    [self.api getCaseList:requester.mj_keyValues.mutableCopy];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.tableview registerClass:[SelectBLTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SelectBLTableViewCell class])];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.addBLbutton];
    [self layOut];
    
}

- (void)refresh{
    [Utils addHudOnView:self.view withTitle:@"正在加载..."];
    caseListHeader *header = [[caseListHeader alloc]init];
    header.target = @"bingLiControl";
    header.method = @"blList";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    caseListBody *bodyer = [[caseListBody alloc]init];
    CaseListRequest *requester = [[CaseListRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    [self.api getCaseList:requester.mj_keyValues.mutableCopy];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CaseListModel *model = [self.caselist objectAtIndex:indexPath.row];
    if (self.blBlock) {
        self.blBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caselist.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 83;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectBLTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectBLTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CaseListModel *model = [self.caselist objectAtIndex:indexPath.row];
  
    cell.editcase = ^{
        AddCaseViewController *edit = [AddCaseViewController new];
        edit.btlistEnter = YES;
        edit.title = @"编辑病例";
        edit.id = model.id;
        [self.navigationController pushViewController:edit animated:YES];
    };
  
    [cell refreshWithModel:model];
    return cell;
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

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] showNetErrorOnView:self.tableview response:command.response operationBlock:^{
        [self.tableview.mj_header beginRefreshing];
    }];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.tableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    if (api == _api) {
        NSArray *array = (NSArray *)responsObject;
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无病历" operationText:nil operationBlock:nil];
        }else{
            self.caselist  = [NSMutableArray array];
            [self.caselist removeAllObjects];
            for (CaseListModel *model in responsObject) {
                if ([model.id isEqualToString:self.id]) {
                    model.select = YES;
                }else{
                    model.select = NO;
                }
                [self.caselist addObject:model];
            }
            for (CaseListModel *model in self.caselist) {
                NSLog(@"%d",model.select);
            }
            [self.tableview reloadData];
        }
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBl:(UIButton *)btn{
    AddCaseViewController *addcase = [[AddCaseViewController alloc]init];
    addcase.hzEnter = YES;
    addcase.title = @"新增病历";
    [self.navigationController pushViewController:addcase animated:YES];
}

@end
