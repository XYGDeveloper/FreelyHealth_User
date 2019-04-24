//
//  AddPatientsViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AddPatientsViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "SelectSexCell.h"
#import "BTableViewCell.h"
#import "MTableViewCell.h"
#import "UpDateDetailTableViewCell.h"
#import "PatientsListRequest.h"
#import "EditPatientApi.h"
#import "EmptyManager.h"
#import "BaseMessageView.h"
#import "AlertView.h"
#import "EditPatientsViewController.h"
#define kFetchTag 5000

@interface AddPatientsViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)SelectTypeTableViewCell *name;
@property (nonatomic, strong) BTableViewCell *sex;
@property (nonatomic,strong)SelectTypeTableViewCell *age;
@property (nonatomic, strong) MTableViewCell *marray;
@property (nonatomic,strong)UpDateDetailTableViewCell *hunyu;
@property (nonatomic,strong)UpDateDetailTableViewCell *jiazu;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)EditPatientApi *api;
@property (nonatomic,strong)EditPatientApi *editApi;
@property (nonatomic,strong)NSString *pid;  //病人id

@end

@implementation AddPatientsViewController
- (EditPatientApi *)api{
    if (!_api) {
        _api = [[EditPatientApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (EditPatientApi *)editApi{
    if (!_editApi) {
        _editApi = [[EditPatientApi alloc]init];
        _editApi.delegate  =self;
    }
    return _editApi;
}
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    NSLog(@"0----%@",command.response.code);
    if ([command.response.code isEqualToString:@"20013"]) {
        NSString *content = @"与该患者姓名相同的患者已经存在";
        self.pid = command.response.msg;
        [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"取消" rightBtnTitle:@"是的，修改信息" tag:kFetchTag];
    }
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    NSLog(@"1----%@",command.response.code);
    if (api == _api) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (api == _editApi) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        [_sex setSex:@"0"];
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
        [_marray setSex:@"1"];
        _marray.selectionStyle = UITableViewCellSelectionStyleNone;
        [_marray setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"婚否"];
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

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _saveButton.backgroundColor = AppStyleColor;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveButton;
}
#pragma mark AutolayOut
- (void)layoutsubview{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.list = @[self.name,self.sex,self.age,self.marray,self.hunyu,self.jiazu];
    [self layoutsubview];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.saveButton addTarget:self action:@selector(tosave) forControlEvents:UIControlEventTouchUpInside];
    self.sex.sex = @"0";
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

- (void)tosave{
    if (self.name.text.length <= 0) {
        [Utils postMessage:@"请输入姓名" onView:self.view];
        return;
    }
    if (self.age.text.length <= 0) {
        [Utils postMessage:@"请选择年龄" onView:self.view];
        return;
    }
    [Utils addHudOnView:self.view withTitle:@"正在添加..."];
    patientsHeader *header = [[patientsHeader alloc]init];
    header.target = @"bingLiControl";
    header.method = @"blBrSave";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    patientsBody *bodyer = [[patientsBody alloc]init];
    bodyer.name = self.name.text;
    NSString *sexstring;
    if ([self.sex.sex isEqualToString:@"0"]) {
        sexstring = @"女";
        bodyer.sex = sexstring;
        bodyer.age  =self.age.text;
        bodyer.ismarry = self.marray.sex;
        bodyer.hun = self.hunyu.textView.text;
        bodyer.jiazu = self.jiazu.textView.text;
    }else{
        sexstring = @"男";
        bodyer.sex = sexstring;
        bodyer.age  =self.age.text;
        bodyer.ismarry = self.marray.sex;
        bodyer.jiazu = self.jiazu.textView.text;
    }
    PatientsListRequest *requester = [[PatientsListRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    [self.api editPatientsList:requester.mj_keyValues.mutableCopy];
    
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"取消"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [Utils addHudOnView:self.view withTitle:@"正在保存..."];
            patientsHeader *header = [[patientsHeader alloc]init];
            header.target = @"bingLiControl";
            header.method = @"blBrUpdate";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            patientsBody *bodyer = [[patientsBody alloc]init];
            bodyer.id = self.pid;
            bodyer.name = self.name.text;
            bodyer.age = self.age.text;
            bodyer.jiazu = self.jiazu.textView.text;
            NSString *sexstring;
            if ([self.sex.sex isEqualToString:@"1"]) {
                sexstring = @"男";
            }else{
                sexstring = @"女";
                bodyer.hun = self.hunyu.textView.text;
            }
            bodyer.sex = sexstring;
            bodyer.ismarry = self.marray.sex;
            PatientsListRequest *requester = [[PatientsListRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.editApi editPatientsList:requester.mj_keyValues.mutableCopy];
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

@end
