//
//  AddCaseViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AddCaseViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "SelectSexCell.h"
#import "BTableViewCell.h"
#import "MTableViewCell.h"
#import "UpDateDetailTableViewCell.h"
#import "CaseProfileViewController.h"
#import "CaseListRequest.h"
#import "AddCaseApi.h"
#import "PreFillPatientsApi.h"
#import "PatientModel.h"
#import "PatientsListRequest.h"
#import "EditPatientApi.h"
//
#import "CaseDetailModel.h"
#import "CaseListRequest.h"
#import "CaseDetailApi.h"
//编辑病历
#import "EditCaseApi.h"
#import "BaseMessageView.h"
#import "AlertView.h"
#define kFetchTag 6000

@interface AddCaseViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)UIView *InfosaveButton;
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong)UIView *head;
@property (nonatomic,strong)SelectTypeTableViewCell *name;
@property (nonatomic, strong) BTableViewCell *sex;
@property (nonatomic,strong)SelectTypeTableViewCell *age;
@property (nonatomic, strong) MTableViewCell *marray;
@property (nonatomic,strong)UpDateDetailTableViewCell *hunyu;
@property (nonatomic,strong)UpDateDetailTableViewCell *jiazu;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)AddCaseApi *addapi;
@property (nonatomic,strong)NSString *issave;
@property (nonatomic,strong)PreFillPatientsApi *fillApi;
@property (nonatomic,strong)CaseDetailApi *detailapi;
@property (nonatomic,strong)EditCaseApi *editCase;
@property (nonatomic,strong)NSString *bid;
@property (nonatomic,strong)CaseDetailModel *model;
@property (nonatomic,strong)EditPatientApi *editApi;

@end

@implementation AddCaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.ptlistEnter == YES) {
        //从患者列表进入，需要先获取患者详细信息，然后新增病历
        [Utils addHudOnView:self.view withTitle:@"正在获取..."];
        patientsHeader *header = [[patientsHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blBrDetail";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        patientsBody *bodyer = [[patientsBody alloc]init];
        bodyer.id = self.id;
        PatientsListRequest *requester = [[PatientsListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.fillApi prefillPatientsList:requester.mj_keyValues.mutableCopy];
    }
    
    if (self.btlistEnter == YES) {
                [Utils addHudOnView:self.view withTitle:@"正在获取..."];
                caseListHeader *header = [[caseListHeader alloc]init];
                header.target = @"bingLiControl";
                header.method = @"blDetail";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                caseListBody *bodyer = [[caseListBody alloc]init];
                bodyer.id = self.id;
                CaseListRequest *requester = [[CaseListRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                [self.detailapi detailCase:requester.mj_keyValues.mutableCopy];
    }
    
}

- (AddCaseApi *)addapi{
    if (!_addapi) {
        _addapi = [[AddCaseApi alloc]init];
        _addapi.delegate  = self;
    }
    return _addapi;
}

- (PreFillPatientsApi *)fillApi{
    if (!_fillApi) {
        _fillApi = [[PreFillPatientsApi alloc]init];
        _fillApi.delegate = self;
    }
    return _fillApi;
}

- (CaseDetailApi *)detailapi{
    if (!_detailapi) {
        _detailapi = [[CaseDetailApi alloc]init];
        _detailapi.delegate = self;
    }
    return _detailapi;
}

- (EditCaseApi *)editCase{
    if (!_editCase) {
        _editCase = [[EditCaseApi alloc]init];
        _editCase.delegate = self;
    }
    return _editCase;
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"取消"]) {
            if (self.name.text.length <= 0) {
                [Utils postMessage:@"请填写姓名" onView:self.view];
                return;
            }
            if (self.sex.sex.length <= 0) {
                [Utils postMessage:@"请选择性别" onView:self.view];
                return;
            }
            if (self.age.text.length <= 0) {
                [Utils postMessage:@"请输入年龄" onView:self.view];
                return;
            }
            if ([self.age.text integerValue] >= 150) {
                [Utils postMessage:@"请输入正确年龄" onView:self.view];
                return;
            }
            if (self.marray.sex.length <= 0) {
                [Utils postMessage:@"请选择婚姻状况" onView:self.view];
                return;
            }
            [Utils addHudOnView:self.view withTitle:@"正在保存..."];
            caseListHeader *header = [[caseListHeader alloc]init];
            header.target = @"bingLiControl";
            header.method = @"blSaveA";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            caseListBody *bodyer = [[caseListBody alloc]init];
            bodyer.name  =self.name.text;
            bodyer.type = @"2";
            NSString *sexstring;
            if ([self.sex.sex isEqualToString:@"1"]) {
                sexstring = @"男";
                bodyer.sex = sexstring;
                bodyer.age = self.age.text;
                bodyer.ismarry = self.marray.sex;
                bodyer.jiazu = self.jiazu.textView.text;
                bodyer.isoften = self.issave;
            }else{
                sexstring = @"女";
                bodyer.sex = sexstring;
                bodyer.age = self.age.text;
                bodyer.ismarry = self.marray.sex;
                bodyer.hun = self.hunyu.textView.text;
                bodyer.jiazu = self.jiazu.textView.text;
                bodyer.isoften = self.issave;
            }
            
            CaseListRequest *requester = [[CaseListRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.addapi addCase:requester.mj_keyValues.mutableCopy];
        }else{
            if (self.name.text.length <= 0) {
                [Utils postMessage:@"请填写姓名" onView:self.view];
                return;
            }
            if (self.sex.sex.length <= 0) {
                [Utils postMessage:@"请选择性别" onView:self.view];
                return;
            }
            if (self.age.text.length <= 0) {
                [Utils postMessage:@"请输入年龄" onView:self.view];
                return;
            }
            if ([self.age.text integerValue] >= 150) {
                [Utils postMessage:@"请输入正确年龄" onView:self.view];
                return;
            }
            if (self.marray.sex.length <= 0) {
                [Utils postMessage:@"请选择婚姻状况" onView:self.view];
                return;
            }
            [Utils addHudOnView:self.view withTitle:@"正在保存..."];
            caseListHeader *header = [[caseListHeader alloc]init];
            header.target = @"bingLiControl";
            header.method = @"blSaveA";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            caseListBody *bodyer = [[caseListBody alloc]init];
            bodyer.name  =self.name.text;
            bodyer.type = @"1";
            NSString *sexstring;
            if ([self.sex.sex isEqualToString:@"1"]) {
                sexstring = @"男";
                bodyer.sex = sexstring;
                bodyer.age = self.age.text;
                bodyer.ismarry = self.marray.sex;
                bodyer.jiazu = self.jiazu.textView.text;
                bodyer.isoften = self.issave;
            }else{
                sexstring = @"女";
                bodyer.sex = sexstring;
                bodyer.age = self.age.text;
                bodyer.ismarry = self.marray.sex;
                bodyer.hun = self.hunyu.textView.text;
                bodyer.jiazu = self.jiazu.textView.text;
                bodyer.isoften = self.issave;
            }
            
            CaseListRequest *requester = [[CaseListRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.addapi addCase:requester.mj_keyValues.mutableCopy];
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

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
//    [Utils postMessage:command.response.msg onView:self.view];
    if ([command.response.code isEqualToString:@"20013"]) {
        NSString *content = @"患者列表中已存在重复患者，是否修改现有患者信息";
        [self showScanMessageTitle:nil content:content leftBtnTitle:@"取消" rightBtnTitle:@"是的，修改信息" tag:kFetchTag];
    }
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    if (api == _addapi) {
        CaseProfileViewController *profile = [CaseProfileViewController new];
        self.bid =  responsObject[@"id"];
        profile.id = self.bid;
        profile.title = @"病史资料";
        profile.hzenter = YES;
        [self.navigationController pushViewController:profile animated:YES];
    }
    if (api == _fillApi) {
        PatientModel *model = responsObject;
        self.bid = model.id;
        self.name.text = model.name;
        //1男 ，0女
        if ([model.sex isEqualToString:@"女"]) {
            self.sex.sex  =@"0";
        }else{
            self.sex.sex  =@"1";
        }
        //0 未婚。 1 已婚
        self.marray.sex  = model.ismarry;
        self.age.text = model.age;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];  //你需要更新的组数中的cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        self.hunyu.textView.text = model.hun;
        self.jiazu.textView.text = model.jiazu;
    }
    
    if (api == _detailapi) {
        CaseDetailModel *model = responsObject;
        self.model = model;
        self.bid = model.id;
        self.name.text = model.name;
        //1男 ，0女
        if ([model.sex isEqualToString:@"女"]) {
            self.sex.sex  = @"0";
        }else{
            self.sex.sex  = @"1";
        }
        NSLog(@"性别标记为：%@",self.sex.sex);
        //0 未婚。 1 已婚
        self.marray.sex  = model.ismarry;
        self.age.text = model.age;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];  //你需要更新的组数中的cell
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        self.hunyu.textView.text = model.hun;
        self.jiazu.textView.text = model.jiazu;
        self.InfosaveButton.hidden = YES;
        self.saveButton.selected = @"0";
    }
    if (api == _editCase) {
        CaseProfileViewController *profile = [CaseProfileViewController new];
        self.bid =  responsObject[@"id"];
        profile.id = self.bid;
        profile.title = @"病史资料";
        profile.isEdit = YES;
        profile.model = self.model;
        [self.navigationController pushViewController:profile animated:YES];
    }
}

- (void)setheader{
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView *stepline = [[UIView alloc]init];
    
    stepline.backgroundColor = DividerDarkGrayColor;
    
    [topView addSubview:stepline];
    
    [stepline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.height.mas_equalTo(1.5);
        
    }];
    
    UIView *normalFlag = [[UIView alloc]init];
    
    normalFlag.backgroundColor = AppStyleColor;
    
    normalFlag.layer.cornerRadius = 10;
    
    normalFlag.layer.masksToBounds = YES;
    
    [topView addSubview:normalFlag];
    
    [normalFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
        
    }];
    
    UIView *normalFlag1 = [[UIView alloc]init];
    
    normalFlag1.backgroundColor = [UIColor whiteColor];
    
    normalFlag1.layer.cornerRadius = 3.5;
    
    normalFlag1.layer.masksToBounds = YES;
    
    [normalFlag addSubview:normalFlag1];
    
    [normalFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(normalFlag.mas_centerX);
        
        make.width.height.mas_equalTo(7);
        
        make.centerY.mas_equalTo(normalFlag.mas_centerY);
    }];
    
    UIView *normalFlag1Line = [[UIView alloc]init];
    
    normalFlag1Line.backgroundColor = AppStyleColor;
    
    normalFlag1Line.layer.cornerRadius = 3.5;
    
    normalFlag1Line.layer.masksToBounds = YES;
    
    [stepline addSubview:normalFlag1Line];
    
    [normalFlag1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.mas_equalTo((kScreenWidth - 80)/4);
        
        make.height.mas_equalTo(1.5);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
        
    }];
    
    
    UILabel *norLabel = [[UILabel alloc]init];
    
    [topView addSubview:norLabel];
    
    norLabel.textColor = AppStyleColor;
    
    norLabel.textAlignment = NSTextAlignmentCenter;
    
    norLabel.text = @"患者信息";
    
    norLabel.font = FontNameAndSize(15);
    
    [norLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(normalFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(normalFlag.mas_centerX);
    }];
    
    //
    
    UIView *authFlag = [[UIView alloc]init];
    
    authFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    authFlag.layer.cornerRadius = 10;
    
    authFlag.layer.masksToBounds = YES;
    
    [topView addSubview:authFlag];
    
    [authFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(stepline.mas_centerX);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UILabel *authLabel = [[UILabel alloc]init];
    
    [topView addSubview:authLabel];
    
    authLabel.textColor = DefaultGrayTextClor;
    authLabel.textAlignment = NSTextAlignmentCenter;
    authLabel.text = @"病史资料";
    authLabel.font = FontNameAndSize(15);
    
    [authLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(authFlag.mas_centerX);
    }];
    
    UIView *noteFlag = [[UIView alloc]init];
    
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    noteFlag.layer.cornerRadius = 10;
    
    noteFlag.layer.masksToBounds = YES;
    
    [topView addSubview:noteFlag];
    
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(stepline.mas_right);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UILabel *noteLabel = [[UILabel alloc]init];
    
    [topView addSubview:noteLabel];
    
    noteLabel.textColor = DefaultGrayTextClor;
    
    noteLabel.textAlignment = NSTextAlignmentCenter;
    
    noteLabel.text = @"病程记录";
    
    noteLabel.font = FontNameAndSize(15);
    
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
    }];

}

- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
        [_name setTypeName:@"姓名" placeholder:@"请编辑姓名"];
    }
    return _name;
}
- (BTableViewCell *)sex {
    if (!_sex) {
        _sex = [[BTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_sex setEditAble:NO];
        [_sex setSex:@"0"];   //0 女。 1 。男
        _sex.selectionStyle = UITableViewCellSelectionStyleNone;
        [_sex setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"性别"];
    }
    return _sex;
}
- (SelectTypeTableViewCell *)age {
    if (!_age) {
        _age = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_age setTypeName:@"年龄" placeholder:@"请编辑年龄"];
        _age.selectionStyle = UITableViewCellSelectionStyleNone;
        _age.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _age;
}
- (MTableViewCell *)marray{
    if (!_marray) {
        _marray = [[MTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_marray setEditAble:NO];
//        [_marray setSex:@"1"];
        _marray.selectionStyle = UITableViewCellSelectionStyleNone;
        [_marray setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"婚姻"];
    }
    return _marray;
}
- (UpDateDetailTableViewCell *)hunyu{
    if (!_hunyu) {
        _hunyu = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _hunyu.label.text = @"婚育史、月经史（女性）";
        _hunyu.textView.placeholder = @"婚否、生育次数。初潮时间，月经周期等。";
        _hunyu.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _hunyu;
}
- (UpDateDetailTableViewCell *)jiazu{
    if (!_jiazu) {
        _jiazu = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _jiazu.label.text = @"家族病史";
        _jiazu.textView.placeholder = @"是否有高血压、糖尿病等遗传性家族病史。";
        _jiazu.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _jiazu;
}
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_tableView focusNextTextField];
        [_tableView scrollToActiveTextField];
    }
    return _tableView;
}

- (UIView *)InfosaveButton
{
    if (!_InfosaveButton) {
        _InfosaveButton = [[UIView alloc]init];
        _InfosaveButton.backgroundColor = [UIColor whiteColor];
    }
    return _InfosaveButton;
}
- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _saveButton.backgroundColor = AppStyleColor;
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveButton;
}

- (UIView *)head{
    if (!_head) {
        _head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 72)];
        _head.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth, 26)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = DefaultBlackLightTextClor;
        label.font = [UIFont systemFontOfSize:16 weight:0.3];
        label.text = @"病历资料";
        [_head addSubview:label];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 36, kScreenWidth, 26)];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = DefaultGrayTextClor;
        label1.font = [UIFont systemFontOfSize:14.0];
        label1.text = @"直医将对您的个人信息保密，仅医患双方可见";
        [_head addSubview:label1];
    }
    return _head;
}

#pragma mark AutolayOut
- (void)layoutsubview{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(105);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setheader];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.head;
    self.list = @[self.name,self.sex,self.age,self.marray,self.hunyu,self.jiazu];
    [self layoutsubview];

    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.InfosaveButton];
    [self.InfosaveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.saveButton.mas_top);
    }];
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setImage:[UIImage imageNamed:@"save_s"] forState:UIControlStateSelected];
    [self.selectButton setImage:[UIImage imageNamed:@"save_n"] forState:UIControlStateNormal];
    [self.InfosaveButton addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.InfosaveButton.mas_centerY);
        make.width.height.mas_equalTo(35);
    }];
    UILabel *saveInfoLabel = [[UILabel alloc]init];
    saveInfoLabel.text = @"是否保存患者基本信息到常用患者";
    saveInfoLabel.textColor  =AppStyleColor;
    saveInfoLabel.font  =FontNameAndSize(16);
    [self.InfosaveButton addSubview:saveInfoLabel];
    [saveInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectButton.mas_right).mas_equalTo(5);
        make.centerY.mas_equalTo(self.InfosaveButton.mas_centerY);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    self.selectButton.selected = YES;
    [self.selectButton addTarget:self action:@selector(istosave:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.saveButton addTarget:self action:@selector(tosave) forControlEvents:UIControlEventTouchUpInside];
    self.marray.sex = @"0";
    self.sex.sex = @"0";
    self.issave = @"1";
 
    weakify(self);
    self.sex.type = ^(NSString *type) {
        NSLog(@"%@",type);
        if ([type isEqualToString:@"0"]) {
            strongify(self);
            self.sex.sex = @"0";
            self.hunyu.textView.text = @"";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];  //你需要更新的组数中的cell
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];//collection 相同
        }else{
            strongify(self);
            self.sex.sex = @"1";
            self.hunyu.textView.text = @"";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 inSection:0];  //你需要更新的组数中的cell
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];//collection 相同
        }
    };
    
    self.marray.type = ^(NSString *type) {
        NSLog(@"%@",type);
        if ([type isEqualToString:@"0"]) {
            strongify(self);
            self.marray.sex = @"0";
        }else{
            strongify(self);
            self.marray.sex = @"1";
        }
    };
    
    
}

- (void)istosave:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.selectButton.selected == YES) {
        self.issave = @"1";
    }else{
        self.issave = @"0";
    }
}

- (void)tosave{
   
    if (self.btlistEnter == YES) {
        [Utils addHudOnView:self.view withTitle:@"正在修改..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blUpdateA";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        bodyer.name  =self.name.text;
        NSString *sexstring;
        if ([self.sex.sex isEqualToString:@"1"]) {
            sexstring = @"男";
            bodyer.sex = sexstring;
            bodyer.age = self.age.text;
            bodyer.ismarry = self.marray.sex;
            bodyer.jiazu = self.jiazu.textView.text;
            bodyer.isoften = self.issave;
        }else{
            sexstring = @"女";
            bodyer.sex = sexstring;
            bodyer.age = self.age.text;
            bodyer.ismarry = self.marray.sex;
            bodyer.hun = self.hunyu.textView.text;
            bodyer.jiazu = self.jiazu.textView.text;
            bodyer.isoften = self.issave;
        }
        bodyer.id  = self.bid;
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.editCase editCase:requester.mj_keyValues.mutableCopy];
        
    }else{
        if (!self.bid) {
            if (self.name.text.length <= 0) {
                [Utils postMessage:@"请填写姓名" onView:self.view];
                return;
            }
            if (self.sex.sex.length <= 0) {
                [Utils postMessage:@"请选择性别" onView:self.view];
                return;
            }
            if (self.age.text.length <= 0) {
                [Utils postMessage:@"请输入年龄" onView:self.view];
                return;
            }
            if ([self.age.text integerValue] >= 150) {
                [Utils postMessage:@"请输入正确年龄" onView:self.view];
                return;
            }
            if (self.marray.sex.length <= 0) {
                [Utils postMessage:@"请选择婚姻状况" onView:self.view];
                return;
            }
            [Utils addHudOnView:self.view withTitle:@"正在保存..."];
            caseListHeader *header = [[caseListHeader alloc]init];
            header.target = @"bingLiControl";
            header.method = @"blSaveA";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            caseListBody *bodyer = [[caseListBody alloc]init];
            bodyer.name  =self.name.text;
            bodyer.type = @"0";
            NSString *sexstring;
            bodyer.type = @"0";
            if ([self.sex.sex isEqualToString:@"1"]) {
                sexstring = @"男";
                bodyer.sex = sexstring;
                bodyer.age = self.age.text;
                bodyer.ismarry = self.marray.sex;
                bodyer.jiazu = self.jiazu.textView.text;
                bodyer.isoften = self.issave;
            }else{
                sexstring = @"女";
                bodyer.sex = sexstring;
                bodyer.age = self.age.text;
                bodyer.ismarry = self.marray.sex;
                bodyer.hun = self.hunyu.textView.text;
                bodyer.jiazu = self.jiazu.textView.text;
                bodyer.isoften = self.issave;
            }
            
            CaseListRequest *requester = [[CaseListRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.addapi addCase:requester.mj_keyValues.mutableCopy];
        }else{
            if (self.ptlistEnter == YES) {
                if (self.name.text.length <= 0) {
                    [Utils postMessage:@"请填写姓名" onView:self.view];
                    return;
                }
                if (self.sex.sex.length <= 0) {
                    [Utils postMessage:@"请选择性别" onView:self.view];
                    return;
                }
                if (self.age.text.length <= 0) {
                    [Utils postMessage:@"请输入年龄" onView:self.view];
                    return;
                }
                if ([self.age.text integerValue] >= 150) {
                    [Utils postMessage:@"请输入正确年龄" onView:self.view];
                    return;
                }
                if (self.marray.sex.length <= 0) {
                    [Utils postMessage:@"请选择婚姻状况" onView:self.view];
                    return;
                }
                [Utils addHudOnView:self.view withTitle:@"正在保存..."];
                caseListHeader *header = [[caseListHeader alloc]init];
                header.target = @"bingLiControl";
                header.method = @"blSaveA";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                caseListBody *bodyer = [[caseListBody alloc]init];
                bodyer.name  =self.name.text;
                NSString *sexstring;
                bodyer.type = @"0";
                if ([self.sex.sex isEqualToString:@"1"]) {
                    sexstring = @"男";
                    bodyer.sex = sexstring;
                    bodyer.age = self.age.text;
                    bodyer.ismarry = self.marray.sex;
                    bodyer.jiazu = self.jiazu.textView.text;
                    bodyer.isoften = @"0";
                }else{
                    sexstring = @"女";
                    bodyer.sex = sexstring;
                    bodyer.age = self.age.text;
                    bodyer.ismarry = self.marray.sex;
                    bodyer.hun = self.hunyu.textView.text;
                    bodyer.jiazu = self.jiazu.textView.text;
                    bodyer.isoften = @"0";
                }
                CaseListRequest *requester = [[CaseListRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                [self.addapi addCase:requester.mj_keyValues.mutableCopy];
            }else{
                [Utils addHudOnView:self.view withTitle:@"正在修改..."];
                caseListHeader *header = [[caseListHeader alloc]init];
                header.target = @"bingLiControl";
                header.method = @"blUpdateA";
                header.versioncode = Versioncode;
                header.devicenum = Devicenum;
                header.fromtype = Fromtype;
                header.token = [User LocalUser].token;
                caseListBody *bodyer = [[caseListBody alloc]init];
                bodyer.name  = self.name.text;
                NSString *sexstring;
                if ([self.sex.sex isEqualToString:@"1"]) {
                    sexstring = @"男";
                    bodyer.sex = sexstring;
                    bodyer.age = self.age.text;
                    bodyer.ismarry = self.marray.sex;
                    bodyer.jiazu = self.jiazu.textView.text;
                    bodyer.isoften = self.issave;
                }else{
                    sexstring = @"女";
                    bodyer.sex = sexstring;
                    bodyer.age = self.age.text;
                    bodyer.ismarry = self.marray.sex;
                    bodyer.hun = self.hunyu.textView.text;
                    bodyer.jiazu = self.jiazu.textView.text;
                    bodyer.isoften = self.issave;
                }
                bodyer.id  = self.bid;
                CaseListRequest *requester = [[CaseListRequest alloc]init];
                requester.head = header;
                requester.body = bodyer;
                [self.editCase editCase:requester.mj_keyValues.mutableCopy];
            }
         
        }
       
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5 ) {
        return 133;
    }else if (indexPath.row == 4){
        if ([self.sex.sex isEqualToString:@"1"]) {
            return 0;
        }else{
            return 133;
        }
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.list safeObjectAtIndex:indexPath.row];
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


@end
