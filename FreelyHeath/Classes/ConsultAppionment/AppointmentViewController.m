//
//  AppointmentViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppointmentViewController.h"
#import "TJDistriTableViewCell.h"
#import "SelectTypeTableViewCell.h"
#import "BLTableViewCell.h"
#import "CaseListModel.h"
#import <TPKeyboardAvoidingTableView.h>
#import "BLListViewController.h"
#import "ScuessAppionmentViewController.h"
#import "AppionmentSearchViewController.h"
#import "commitAppionmentApi.h"
#import "commitAppionmentRequest.h"
#import "JHTagModel.h"
#import "JHTagView.h"
#import "CaseListModel.h"
#import "CaseListApi.h"
#import "CaseListRequest.h"
#import "CaseListModel.h"
#import "CaseListApi.h"
#import "CaseListRequest.h"
#import "AddCaseViewController.h"
@interface AppointmentViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,JHTagViewDelegate>

@property (nonatomic ,strong) NSMutableArray * tagModels;
@property (nonatomic ,strong) JHTagView * tagView;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *fillTableview;
@property (nonatomic,strong)SelectTypeTableViewCell *blSelect;
@property (nonatomic,strong)BLTableViewCell *isExpert;
@property (nonatomic,strong)SelectTypeTableViewCell *expertName;
@property (nonatomic,strong)SelectTypeTableViewCell *request;
@property (nonatomic,strong)NSArray *noExperts;
@property (nonatomic,strong)NSArray *HaveExperts;
@property (nonatomic,assign)BOOL flag;
@property (nonatomic,strong)UIButton *commitSusButton;
@property (nonatomic,strong)commitAppionmentApi *commit;
//参数
@property (nonatomic,strong)NSString *recordid;
@property (nonatomic,strong)NSString *memberstr;
@property (nonatomic,strong)CaseListApi *api;
@property (nonatomic,strong)NSMutableArray *caselist;

@property (nonatomic,strong)NSString *caseName;
@property (nonatomic,strong)NSString *recorderid;
//
@end

@implementation AppointmentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
- (NSMutableArray *)tagModels{
    if (!_tagModels) {
        _tagModels = [[NSMutableArray alloc]init];
    }
    return _tagModels;
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

- (UITableView *)fillTableview{
    if (!_fillTableview) {
        _fillTableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _fillTableview.delegate = self;
        _fillTableview.dataSource = self;
        _fillTableview.backgroundColor = [UIColor whiteColor];
        [_fillTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _fillTableview.separatorColor = HexColor(0xe7e7e9);
    }
    return _fillTableview;
}

- (void)layOutSubview{
    [self.fillTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    [self.commitSusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

- (SelectTypeTableViewCell *)blSelect {
    if (!_blSelect) {
        _blSelect = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_blSelect setTypeName:@"请选择病历" placeholder:@""];
        [_blSelect setEditAble:NO];
        _blSelect.textField.textAlignment = NSTextAlignmentLeft;
        _blSelect.textField.textColor = AppStyleColor;
        _blSelect.selectionStyle = UITableViewCellSelectionStyleNone;
        _blSelect.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _blSelect;
}

- (SelectTypeTableViewCell *)request {
    if (!_request) {
        _request = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_request setTypeName:@"会诊诉求" placeholder:@"所患疾病与会诊诉求"];
        _request.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _request;
}

- (BLTableViewCell *)isExpert {
    if (!_isExpert) {
        _isExpert = [[BLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_isExpert setEditAble:NO];
        _isExpert.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.isLSTD == YES) {
            [_isExpert setSex:@"0"];
        }else{
            [_isExpert setSex:@"1"];
        }
        [_isExpert setIcon:[UIImage imageNamed:@""] editedIcon:[UIImage imageNamed:@""] placeholder:@"指定专家"];
    }
    return _isExpert;
}

- (UIButton *)commitSusButton{
    if (!_commitSusButton) {
        _commitSusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitSusButton.backgroundColor = AppStyleColor;
        [_commitSusButton setTitle:@"提交预约" forState:UIControlStateNormal];
        [_commitSusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitSusButton.titleLabel.font = FontNameAndSize(18);
        [_commitSusButton addTarget:self action:@selector(commitAppoinment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitSusButton;
}

//api---------

- (commitAppionmentApi *)commit{
    if (!_commit) {
        _commit = [[commitAppionmentApi alloc]init];
        _commit.delegate = self;
    }
    return _commit;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _commit) {
        [Utils removeHudFromView:self.view];
        [Utils postMessage:command.response.msg onView:self.view];
        ScuessAppionmentViewController *scuess = [ScuessAppionmentViewController new];
        scuess.hidesBottomBarWhenPushed = YES;
        scuess.isenter = YES;
        scuess.id = responsObject[@"id"];
        scuess.title = @"提交成功";
        [self.navigationController pushViewController:scuess animated:YES];
    }
    
    if (api == _api) {
            [self.caselist removeAllObjects];
            [self.caselist addObjectsFromArray:responsObject];
    }
}

- (void)refreTag:(NSArray *)tagArr{
    //
    [self.tagModels removeAllObjects];
    //展示相同宽度
    for (int i = 0; i<tagArr.count; i++) {
        JHTagModel * model = [JHTagModel randomSameWidth];
        model.text = tagArr[i];
        [model configCornerRadius:4 borderWidth:0.1 normalBorderColor:DefaultBackgroundColor normalTitleColor:DefaultBlackLightTextClor normalBackgroundColor:DefaultBackgroundColor selectTitleColor:AppStyleColor selectBackgroundColor:[UIColor whiteColor]];
        [self.tagModels addObject:model];
    }
    //在最后增加一个自定义样式
    JHTagModel * model = [JHTagModel random];
    model.type = JHTagViewCustom;
    model.text = @"添加 +";
    model.width = ((kScreenWidth - 40)-20)/3;
    [model configCornerRadius:4 borderWidth:1 normalBorderColor:AppStyleColor normalTitleColor:AppStyleColor normalBackgroundColor:[UIColor whiteColor] selectTitleColor:AppStyleColor selectBackgroundColor:[UIColor whiteColor]];
    [self.tagModels addObject:model];
    [_tagView removeFromSuperview];
    
    self.tagView = [[JHTagView alloc]initWithFrame:CGRectMake(0, 10,kScreenWidth, 200)];
    
    [self.tagView configMaxWidth: kScreenWidth-20 horizontalMargin:10 verticalMargin:5];
    
    self.tagView.backgroundColor = [UIColor whiteColor];
    
    //1 算高度
    CGFloat height = [self.tagView getMaxHeightWithModels:self.tagModels];
    //赋值
    self.tagView.tagModels = self.tagModels;
    //重置高度
    self.tagView.frame = CGRectMake(20, 10, kScreenWidth-20, height+10);
    self.tagView.delegate = self;
    self.fillTableview.tableFooterView = self.tagView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.fillTableview];
    [self.view addSubview:self.commitSusButton];
    [self layOutSubview];
    [self.fillTableview registerClass:[TJDistriTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TJDistriTableViewCell class])];
    self.HaveExperts = @[self.request,self.blSelect,self.isExpert];
    [self refreTag:self.teamMember];
    //
    if (self.isLSTD == YES) {
        [self.isExpert setSex:@"0"];
        if ([self.isExpert.sex isEqualToString:@"0"]) {
            self.fillTableview.tableFooterView = nil;
        }
    }
   
    weakify(self);
    self.flag = YES;
    self.isExpert.type = ^(NSString *type) {
        strongify(self);
        if ([type isEqualToString:@"1"]) {
            self.flag = YES;
            self.fillTableview.tableFooterView = self.tagView;
        }else{
            self.flag = NO;
            self.fillTableview.tableFooterView = nil;
        }
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.fillTableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.fillTableview reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return self.HaveExperts.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else{
        return 0.0001;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    footView.backgroundColor = DefaultBackgroundColor;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 52;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,52)];
        content.backgroundColor = [UIColor whiteColor];
        UILabel *desLTitle = [UILabel new];
        desLTitle.textAlignment = NSTextAlignmentLeft;
        desLTitle.font = [UIFont systemFontOfSize:16 weight:0.3f];
        desLTitle.textColor = DefaultGrayTextClor;
        [content addSubview:desLTitle];
        [desLTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(content.mas_centerY);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
        desLTitle.text = @"预约登记";
        UIView *sepview = [[UIView alloc]init];
        sepview.backgroundColor = HexColor(0xe7e7e9);
        [content addSubview:sepview];
        [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.left.mas_equalTo(20);
        }];
        return content;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 52;
    }else{
        return 0.000001;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TJDistriTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJDistriTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.tjImg.image = [UIImage imageNamed:@"Appionment_tjimage"];
        return cell;
    }else{
        return [self.HaveExperts safeObjectAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (self.caselist.count <=0) {
            AddCaseViewController *addcase = [[AddCaseViewController alloc]init];
            addcase.hzEnter = YES;
            addcase.title = @"患者信息";
            [self.navigationController pushViewController:addcase animated:YES];
        }else{
            BLListViewController *list = [BLListViewController new];
            list.id  = self.recordid;
            list.blBlock = ^(CaseListModel *model) {
                self.caseName = model.name;
                self.blSelect.text = model.name;
                self.recordid = model.id;
            };
            list.title = @"病历列表";
            [self.navigationController pushViewController:list animated:YES];
        }
    }
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)commitAppoinment{

    if (self.request.text.length <= 0) {
        [Utils postMessage:@"请填写会诊诉求" onView:self.view];
        return;
    }
    if (self.blSelect.text.length <= 0) {
        [Utils postMessage:@"请选择病历" onView:self.view];
        return;
    }
    [Utils addHudOnView:self.view withTitle:@"提交预约中...."];
    commitAppionmentHeader *head = [[commitAppionmentHeader alloc]init];
    head.target = @"userHuizhenControl";
    head.method = @"createHuizhenYuyue";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    commitAppionmentBody *body = [[commitAppionmentBody alloc]init];
    if (self.flag == YES) {
        NSMutableArray *tempArr = [NSMutableArray array];
        for (JHTagModel *model in self.tagView.tagModels) {
            [tempArr addObject:model.text];
        }
        [tempArr removeLastObject];
        self.memberstr = [tempArr componentsJoinedByString:@","];
    }else{
        self.memberstr = @"";

    }
  
    body.teamid = self.teamid;
    body.recordid = self.recordid;
    body.member = self.memberstr;
    body.topic = self.request.text;
    commitAppionmentRequest *request = [[commitAppionmentRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.commit commitAppionment:request.mj_keyValues.mutableCopy];
    
}

#pragma mark - JHTagViewDelegate
- (void)jh_tagViewClicked:(JHTagModel *)model isSelected:(BOOL)isSelected{
    NSLog(@"点击了%@",model.text);
    if ([model.text isEqualToString:@"添加 +"]) {
        AppionmentSearchViewController *search = [AppionmentSearchViewController new];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (JHTagModel *model in self.tagView.tagModels) {
            [tempArr addObject:model.text];
        }
        [tempArr removeLastObject];
        search.count = [NSString stringWithFormat:@"%ld",self.tagView.tagModels.count - 1];
        search.defaultMember = tempArr;
        search.sure = ^(NSArray *arr) {
            self.teamMember = arr;
            NSLog(@"%@",arr);
            [self refreTag:self.teamMember];
        };
        search.title = @"选择医生";
        [self.navigationController pushViewController:search animated:YES];
    }else{
        [self jh_tagViewRemoved:model];
        [self.tagView reloadData];
    }
}

- (void)jh_tagViewRemoved:(JHTagModel *)model{
    NSLog(@"移除了%@",model.text);
    [self.tagView.tagModels removeObject:model];
    NSLog(@"%@",self.tagView.tagModels);
    [self.tagView reloadData];
}

@end
