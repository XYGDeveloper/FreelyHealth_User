//
//  CommonPatientsViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CommonPatientsViewController.h"
#import "CaseListTableViewCell.h"
#import "AddCaseViewController.h"
#import "AddPatientsViewController.h"
#import "PatientListTableViewCell.h"
#import "EditPatientsViewController.h"
#import "PatientModel.h"
#import "PatientsListRequest.h"
#import "PatientsApi.h"
#import "EmptyManager.h"
#import "YQAlertView.h"

@interface CommonPatientsViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,YQAlertViewDelegate>
@property (nonatomic,strong)UIView *patientslist;
@property (nonatomic,strong)UITableView *patientsTableview;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIButton *addPatients;
@property (nonatomic,strong)UIButton *creatCases;
@property (nonatomic,strong)PatientsApi *api;
@property (nonatomic,strong)NSMutableArray *patients;

@end

@implementation CommonPatientsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.patientsTableview.mj_header beginRefreshing];
    
}

- (NSMutableArray *)patients{
    if (!_patients) {
        _patients = [NSMutableArray array];
    }
    return _patients;
}
- (PatientsApi *)api{
    if (!_api) {
        _api = [[PatientsApi alloc]init];
        _api.delegate  = self;
    }
    return _api;
}
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [self.patientsTableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] showNetErrorOnView:self.patientsTableview response:command.response operationBlock:^{
        [self.patientsTableview.mj_header beginRefreshing];
    }];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.patientsTableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] removeEmptyFromView:self.patientsTableview];
    NSArray *array = (NSArray *)responsObject;
    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.patientsTableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"没有患者资料" operationText:nil operationBlock:nil];
    } else {
        [self.patients removeAllObjects];
        [self.patients addObjectsFromArray:responsObject];
        [self.patientsTableview reloadData];
    }
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 60)];
        _headerView.backgroundColor = DefaultBackgroundColor;
    }
    return _headerView;
}
- (UIButton *)addPatients{
    if (!_addPatients) {
        _addPatients = [UIButton buttonWithType:UIButtonTypeCustom];
        _addPatients.backgroundColor = [UIColor whiteColor];
        [_addPatients setImage:[UIImage imageNamed:@"add_patient"] forState:UIControlStateNormal];
        [_addPatients setTitle:@"  添加常用患者" forState:UIControlStateNormal];
        [_addPatients setTitleColor:DefaultGrayTextClor forState:UIControlStateNormal];
        _addPatients.titleLabel.font = FontNameAndSize(16);
    }
    return _addPatients;
}

- (UIButton *)creatCases{
    if (!_creatCases) {
        _creatCases = [UIButton buttonWithType:UIButtonTypeCustom];
        _creatCases.backgroundColor = [UIColor whiteColor];
        [_creatCases setImage:[UIImage imageNamed:@"add_case"] forState:UIControlStateNormal];
        [_creatCases setTitle:@"  创建电子病历" forState:UIControlStateNormal];
        [_creatCases setTitleColor:DefaultGrayTextClor forState:UIControlStateNormal];
        _creatCases.titleLabel.font = FontNameAndSize(16);
    }
    return _creatCases;
}

- (UITableView *)patientsTableview{
    if (!_patientsTableview) {
        _patientsTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _patientsTableview.delegate = self;
        _patientsTableview.dataSource = self;
        _patientsTableview.backgroundColor = DefaultBackgroundColor;
        _patientsTableview.separatorColor = DefaultBackgroundColor;
    }
    return _patientsTableview;
}
- (void)layOutsubviews{
    [self.patientsTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(88);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kScreenHeight - 60);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerView addSubview:self.addPatients];
    [self.addPatients addTarget:self action:@selector(addPatientsAction) forControlEvents:UIControlEventTouchUpInside];
    [self.addPatients mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2-0.5);
        make.bottom.mas_equalTo(0);
    }];
    [self.headerView addSubview:self.creatCases];
    [self.creatCases addTarget:self action:@selector(creatCasesAction) forControlEvents:UIControlEventTouchUpInside];
    [self.creatCases mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2-0.5);
        make.bottom.right.mas_equalTo(0);
    }];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.patientsTableview];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.patientsTableview registerClass:[PatientListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PatientListTableViewCell class])];
    [self layOutsubviews];
    
    self.patientsTableview.mj_header  = [MJRefreshHeader headerWithRefreshingBlock:^{
        [Utils addHudOnView:self.view withTitle:@"正在加载..."];
                patientsHeader *header = [[patientsHeader alloc]init];
                header.target = @"bingLiControl";
                header.method = @"blPeoples";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                patientsBody *bodyer = [[patientsBody alloc]init];
                PatientsListRequest *requester = [[PatientsListRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                [self.api getPatientsList:requester.mj_keyValues.mutableCopy];
    }];
    [self.patientsTableview.mj_header beginRefreshing];
}

-(void)addPatientsAction{
    AddPatientsViewController *patients = [AddPatientsViewController new];
    patients.title  = @"新增患者";
    [self.navigationController pushViewController:patients animated:YES];
}

- (void)creatCasesAction{
    AddCaseViewController *cases = [AddCaseViewController new];
    cases.title  = @"新增病历";
    [self.navigationController pushViewController:cases animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.patients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    PatientModel *model = [self.patients objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    cell.add = ^{
        AddCaseViewController *cases = [AddCaseViewController new];
        cases.ptlistEnter = YES;
        cases.id = model.id;
        cases.title  = @"新增病历";
        [self.navigationController pushViewController:cases animated:YES];
    };
    cell.modify = ^{
        EditPatientsViewController *edit = [EditPatientsViewController new];
        edit.id = model.id;
        edit.title  = @"编辑患者资料";
        [self.navigationController pushViewController:edit animated:YES];
    };
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

@end
