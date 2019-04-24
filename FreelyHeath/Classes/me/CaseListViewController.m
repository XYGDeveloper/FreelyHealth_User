//
//  CaseListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseListViewController.h"
#import "CaseListTableViewCell.h"
#import "CaseDetailViewController.h"
#import "CaseEditViewController.h"
#import "CaseListModel.h"
#import "CaseListApi.h"
#import "delApi.h"
#import "CaseListRequest.h"
#import "EmptyManager.h"
#import "AddCaseViewController.h"
#import "YQAlertView.h"
#import "AddCaseViewController.h"
//
#import "AlertView.h"
#import "CommonPatientsViewController.h"
#import "PatientModel.h"
#import "PatientsListRequest.h"
#import "PatientsApi.h"
#define kFetchTag 100

@interface CaseListViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *caselistTableview;
@property (nonatomic,strong)NSMutableArray *caselist;
@property (nonatomic,strong)UIButton *addCase;
@property (nonatomic,strong)CaseListApi *api;
@property (nonatomic,strong)delApi *delapi;
@property (nonatomic,strong)NSString *deleid;
@property (nonatomic,strong)PatientsApi *papi;
@property (nonatomic,strong)NSMutableArray *patients;

@end

@implementation CaseListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.caselistTableview.mj_header beginRefreshing];
}

- (NSMutableArray *)caselist{
    if (!_caselist) {
        _caselist = [NSMutableArray array];
    }
    return _caselist;
}
- (CaseListApi *)api{
    if (!_api) {
        _api = [[CaseListApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (delApi *)delapi{
    if (!_delapi) {
        _delapi = [[delApi alloc]init];
        _delapi.delegate = self;
    }
    return _delapi;
}

- (NSMutableArray *)patients{
    if (!_patients) {
        _patients = [NSMutableArray array];
    }
    return _patients;
}
- (PatientsApi *)papi{
    if (!_papi) {
        _papi = [[PatientsApi alloc]init];
        _papi.delegate  = self;
    }
    return _papi;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [self.caselistTableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
        [[EmptyManager sharedManager] showNetErrorOnView:self.caselistTableview response:command.response operationBlock:^{
            [self.caselistTableview.mj_header beginRefreshing];
        }];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.caselistTableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
    [[EmptyManager sharedManager] removeEmptyFromView:self.caselistTableview];

    if (api == _api) {
        NSArray *array = (NSArray *)responsObject;
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.caselistTableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"现在还没有记录哦，点击下方按钮去添加病历吧" operationText:nil operationBlock:nil];
        } else {
            [self.caselist removeAllObjects];
            [self.caselist addObjectsFromArray:responsObject];
            [self.caselistTableview reloadData];
        }
    }
    if (api == _delapi) {
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
    
    if (api == _papi) {
        self.patients = responsObject;
    }
}
- (UITableView *)caselistTableview{
    if (!_caselistTableview) {
        _caselistTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _caselistTableview.delegate = self;
        _caselistTableview.dataSource = self;
        _caselistTableview.backgroundColor = DefaultBackgroundColor;
        _caselistTableview.separatorColor = DefaultBackgroundColor;
    }
    return _caselistTableview;
}

- (UIButton *)addCase{
    if (!_addCase) {
        _addCase = [UIButton buttonWithType:UIButtonTypeCustom];
        _addCase.backgroundColor = AppStyleColor;
        [_addCase setTitle:@"新增病例" forState:UIControlStateNormal];
        [_addCase setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addCase.titleLabel.font = FontNameAndSize(16);
    }
    return _addCase;
}

- (void)layOutsubviews{
    [self.caselistTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    [self.addCase mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [self.papi getPatientsList:requester.mj_keyValues.mutableCopy];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.caselistTableview];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.caselistTableview registerClass:[CaseListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CaseListTableViewCell class])];
    [self.view addSubview:self.addCase];
    [self.addCase addTarget:self action:@selector(addcase) forControlEvents:UIControlEventTouchUpInside];
    [self layOutsubviews];
    
    self.caselistTableview.mj_header  = [MJRefreshGifHeader headerWithRefreshingBlock:^{
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
    }];
    [self.caselistTableview.mj_header beginRefreshing];
    
}

- (void)addcase{
    if (self.patients.count <= 0) {
        AddCaseViewController *addcase = [[AddCaseViewController alloc]init];
        addcase.title = @"患者信息";
        [self.navigationController pushViewController:addcase animated:YES];
    }else{
        CommonPatientsViewController *comment = [CommonPatientsViewController new];
        comment.title = @"常用患者";
        [self.navigationController pushViewController:comment animated:YES];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 195;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.caselist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CaseListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CaseListTableViewCell class])];
    CaseListModel *model = [self.caselist objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.todetail = ^{
        CaseDetailViewController *detail = [CaseDetailViewController new];
        detail.title = @"病例详情";
        detail.id = model.id;
        [self.navigationController pushViewController:detail animated:YES];
    };
    cell.toedit = ^{
        AddCaseViewController *edit = [AddCaseViewController new];
        edit.btlistEnter = YES;
        edit.title = @"编辑病例";
        edit.id = model.id;
        [self.navigationController pushViewController:edit animated:YES];
    };
    cell.todel = ^{
        
        self.deleid  = model.id;
        NSString *content = @"确认删除此条病历信息";
        [self showScanMessageTitle:nil content:content leftBtnTitle:@"取消" rightBtnTitle:@"确定" tag:kFetchTag];
        
    };
    return cell;
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"取消"]) {
            
        }else{
            [Utils addHudOnView:self.view withTitle:@"正在删除..."];
            caseListHeader *header = [[caseListHeader alloc]init];
            header.target = @"bingLiControl";
            header.method = @"blDelete";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            caseListBody *bodyer = [[caseListBody alloc]init];
            bodyer.id = self.deleid;
            CaseListRequest *requester = [[CaseListRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.delapi delCase:requester.mj_keyValues.mutableCopy];
        }
     
    }
    [messageView hide];
}

-(void)showScanMessageTitle:(NSString *)title content:(NSString *)content leftBtnTitle:(NSString *)left rightBtnTitle:(NSString *)right tag:(NSInteger)tag{
        NSArray  *buttonTitles;
        if (left && right) {
            buttonTitles   =  @[AlertViewNormalStyle(left),AlertViewRedStyle(right)];
        }else{
            buttonTitles = @[AlertViewRedStyle(left)];
        }
        AlertViewMessageObject *messageObject = MakeAlertViewMessageObject(title,content, buttonTitles);
        [AlertView showManualHiddenMessageViewInKeyWindowWithMessageObject:messageObject delegate:self viewTag:tag];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CaseListModel *model = [self.caselist objectAtIndex:indexPath.row];
    CaseDetailViewController *detail = [CaseDetailViewController new];
    detail.title = @"病例详情";
    detail.id = model.id;
    [self.navigationController pushViewController:detail animated:YES];
}

@end
