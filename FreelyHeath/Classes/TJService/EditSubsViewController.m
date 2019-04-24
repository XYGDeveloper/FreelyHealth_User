//
//  EditSubsViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "EditSubsViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "SelectAddressViewController.h"
#import "RMCalendarController.h"
#import "MJExtension.h"
#import "TicketModel.h"
//修改预约
#import "ModifyTJyuyueApi.h"
#import "ModifyTJyuyueRequest.h"
//得到预约详情
#import "GetSubsDetailApi.h"
#import "GetSubsDetailRequest.h"
//
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "SubDetailModel.h"
#import "JGModel.h"
#import "HClActionSheet.h"
#import "AVCaptureViewController.h"
@interface EditSubsViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)SelectTypeTableViewCell *userName;       //姓名
@property (nonatomic,strong)SelectTypeTableViewCell *userSex;        //性别
@property (nonatomic,strong)SelectTypeTableViewCell *userAge;        //年龄
@property (nonatomic,strong)SelectTypeTableViewCell *userPhone;      //手机号
@property (nonatomic,strong)SelectTypeTableViewCell *userIDNumber;  //身份证号
@property (nonatomic,strong)SelectTypeTableViewCell *userDetailAddress;  //详细地址
@property (nonatomic,strong)SelectTypeTableViewCell *userCarNumber;
@property (nonatomic,strong)SelectTypeTableViewCell *userCode;
@property (nonatomic,strong)SelectTypeTableViewCell *pakageType;
@property (nonatomic,strong)SelectTypeTableViewCell *userDate;
@property (nonatomic,strong)SelectTypeTableViewCell *UserAddress;
@property (nonatomic, strong) NSArray *dataArray;
//提交显示
@property (nonatomic,strong)UIButton *editSubs;
@property (nonatomic,strong)HClActionSheet *selectSex;
//
@property (nonatomic, strong) ModifyTJyuyueApi *api;
@property (nonatomic, strong) GetSubsDetailApi *detailapi;
//
@property (nonatomic, strong) NSString  *taocanid;
@property (nonatomic, strong) NSString *jgdetailid;
@property (nonatomic, strong) NSString *yuyueid;
@property (nonatomic, strong) SubDetailModel *model;
@property (nonatomic, strong) UILabel *headView;
@property (nonatomic,strong)UIButton *ocrButton;

@end

@implementation EditSubsViewController

- (ModifyTJyuyueApi *)api{
    if (!_api) {
        _api = [[ModifyTJyuyueApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (GetSubsDetailApi *)detailapi{
    if (!_detailapi) {
        _detailapi = [[GetSubsDetailApi alloc]init];
        _detailapi.delegate = self;
    }
    return _detailapi;
}
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _api) {
        //获取体检详情
        [Utils postMessage:@"修改成功" onView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (api== _detailapi) {
        SubDetailModel *model = responsObject;
        if ([model.status isEqualToString:@"0"]) {
            self.headView.text = @"  ⦿在此状态下您将不能编辑你的预约基本信息，信息有误请联系客服";
        }else{
            self.headView.text = @"  ⦿在此您可以编辑您的部分预约基本信息，体检卡信息将不能编辑";
        }
        self.model = model;
        self.userCarNumber.text = model.tjnum;
        self.userCode.text = model.tjpwd;
        self.pakageType.text = model.taocanname;
        self.userDate.text = model.tjtime;
        self.UserAddress.text = model.jgdetail;
        self.taocanid = model.taocanid;
        self.jgdetailid = model.jgdetailid;
        self.yuyueid = model.yuyueid;
        self.userName.text = model.patientname;
        self.userAge.text = model.patientage;
        self.userSex.text = model.patientsex;
        self.userPhone.text = model.patientphone;
        self.userDetailAddress.text = model.patientaddress;
        self.userIDNumber.text = model.patientidentity;
        //根据返回状态判断是联系客服还是修改预约
        if ([model.status isEqualToString:@"1"]) {
            self.title = @"编辑体检预约信息";
            [self.editSubs setTitle:@"修改预约" forState:UIControlStateNormal];
            [self.editSubs addTarget:self action:@selector(modifyTJyuyue) forControlEvents:UIControlEventTouchUpInside];
        }else{
            self.title = @"查看体检预约信息";
            [self.editSubs setTitle:@"联系客服" forState:UIControlStateNormal];
            [self.editSubs addTarget:self action:@selector(toChat) forControlEvents:UIControlEventTouchUpInside];
            [self.userCarNumber setEditAble:NO];
            [self.userCode setEditAble:NO];
            [self.pakageType setEditAble:NO];
            [self.userName setEditAble:NO];
            [self.userAge setEditAble:NO];
            [self.userSex setEditAble:NO];
            [self.userIDNumber setEditAble:NO];
            [self.userDetailAddress setEditAble:NO];
            [self.userPhone setEditAble:NO];
        }
    }
}

- (void)modifyTJyuyue{
    //调用修改预约接口
    ModifyTJyuyueHeader *head = [[ModifyTJyuyueHeader alloc]init];
    
    head.target = @"orderControl";
    head.method = @"updateYuyue";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    ModifyTJyuyueBody *body = [[ModifyTJyuyueBody alloc]init];

    body.tjnum = self.userCarNumber.text;
    body.tjpwd = self.userCode.text;
    body.taocanid = self.taocanid;
    body.jgdetailid = self.jgdetailid;
    body.tjtime = self.userDate.text;
    body.yuyueid = self.yuyueid;
    body.patientname = self.userName.text;
    body.patientage = self.userAge.text;
    body.patientsex = self.userSex.text;
    body.patientphone = self.userPhone.text;
    body.patientaddress = self.userDetailAddress.text;
    body.patientidentity = self.userIDNumber.text;
    ModifyTJyuyueRequest *request = [[ModifyTJyuyueRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api modifyTJyuyue:request.mj_keyValues.mutableCopy];
    
}
- (void)toChat{
    //联系客服
    UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
    [UdeskManager setupCustomerOnline];
    //设置头像
    [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
    [manager pushUdeskInViewController:self completion:nil];
    //点击留言回调
    [manager leaveMessageButtonAction:^(UIViewController *viewController){
        UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
        [viewController presentViewController:offLineTicket animated:YES completion:nil];
    }];
    
}

#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (SelectTypeTableViewCell *)userCarNumber {
    if (!_userCarNumber) {
        _userCarNumber = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_userCarNumber setTypeName:@"体检卡号" placeholder:@"请输入体检卡号"];
        _userCarNumber.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userCarNumber.selectionStyle = UITableViewCellSelectionStyleNone;
        [_userCarNumber setEditAble:NO];
    }
    return _userCarNumber;
}
- (SelectTypeTableViewCell *)userCode {
    if (!_userCode) {
        _userCode = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_userCode setTypeName:@"验证码" placeholder:@"请输入验证码"];
        [_userCode setEditAble:NO];
        _userCode.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userCode.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _userCode;
}
- (SelectTypeTableViewCell *)pakageType {
    if (!_pakageType) {
        _pakageType = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_pakageType setTypeName:@"体检套餐" placeholder:@"请选择体检套餐"];
        [_pakageType setEditAble:NO];
        _pakageType.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _pakageType;
}

//姓名
- (SelectTypeTableViewCell *)userName {
    if (!_userName) {
        _userName = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userName.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userName.text = [User LocalUser].name;
        [_userName setTypeName:@"姓        名" placeholder:@"请输入姓名"];
        _userName.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _userName;
}
//性别
- (SelectTypeTableViewCell *)userSex {
    if (!_userSex) {
        _userSex = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userSex.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _userSex.text = [User LocalUser].sex;
        [_userSex setTypeName:@"性        别" placeholder:@"请选择性别"];
        [_userSex setEditAble:NO];
        _userSex.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _userSex;
}

//年龄
- (SelectTypeTableViewCell *)userAge {
    if (!_userAge) {
        _userAge = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userAge.textField.keyboardType = UIKeyboardTypeNumberPad;
        _userAge.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userAge.text = [User LocalUser].age;
        [_userAge setTypeName:@"年        龄" placeholder:@"请输入年龄"];
        _userAge.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return _userAge;
}

//手机号码
- (SelectTypeTableViewCell *)userPhone {
    if (!_userPhone) {
        _userPhone = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_userPhone setTypeName:@"手机号码" placeholder:@"请输入手机号码"];
        _userPhone.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userPhone.text = [User LocalUser].phone;
        _userPhone.textField.keyboardType = UIKeyboardTypeNumberPad;
        _userPhone.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _userPhone;
}
//身份证号
- (SelectTypeTableViewCell *)userIDNumber {
    if (!_userIDNumber) {
        _userIDNumber = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_userIDNumber setTypeName:@"身份证号" placeholder:@"请输入身份证号"];
        _userIDNumber.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userIDNumber.selectionStyle = UITableViewCellSelectionStyleNone;
        self.ocrButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ocrButton setImage:[UIImage imageNamed:@"ocr"] forState:UIControlStateNormal];
        self.ocrButton.frame = CGRectMake(0, 0, 25, 25);
        _userIDNumber.accessoryView = self.ocrButton;
    }
    return _userIDNumber;
}
- (SelectTypeTableViewCell *)userDate {
    if (!_userDate) {
        _userDate = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userDate.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_userDate setTypeName:@"预约时间" placeholder:@"请选择预约时间"];
        [_userDate setEditAble:NO];
        _userDate.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _userDate;
}
- (SelectTypeTableViewCell *)UserAddress {
    if (!_UserAddress) {
        _UserAddress = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _UserAddress.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_UserAddress setTypeName:@"体检地址" placeholder:@"请选择体检地址"];
        [_UserAddress setEditAble:NO];
        _UserAddress.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _UserAddress;
}

- (SelectTypeTableViewCell *)userDetailAddress {
    if (!_userDetailAddress) {
        _userDetailAddress = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userDetailAddress.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_userDetailAddress setTypeName:@"地        址" placeholder:@"X省X市X区/县X街道X栋X号X室"];
        _userDetailAddress.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _userDetailAddress;
}
- (UIButton *)editSubs
{
    if (!_editSubs) {
        _editSubs = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editSubs setTitle:@"修改预约" forState:UIControlStateNormal];
        [_editSubs setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editSubs.backgroundColor = AppStyleColor;
        _editSubs.titleLabel.font = Font(20);
    }
    return _editSubs;
}

- (void)layoutsubview{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.editSubs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"编辑体检预约";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"tel"] highligthtedImage:[UIImage imageNamed:@"tel"] action:@selector(telephone)];
    self.headView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    self.headView.textColor = DefaultGrayLightTextClor;
    self.headView.font  =FontNameAndSize(12);
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.editSubs];
    [self layoutsubview];
    self.dataArray = @[self.userCarNumber, self.userCode, self.pakageType,self.userName,self.userSex,self.userAge,self.userPhone,self.userIDNumber,self.userDetailAddress,self.userDate,self.UserAddress];
    SubDetailHeader *head = [[SubDetailHeader alloc]init];
    
    head.target = @"orderControl";
    
    head.method = @"getYuyue";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    SubDetailBody *body = [[SubDetailBody alloc]init];
    body.id = self.id;
    GetSubsDetailRequest *request = [[GetSubsDetailRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.detailapi sublistDetail:request.mj_keyValues.mutableCopy];
    [self.ocrButton addTarget:self action:@selector(toocr:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)toocr:(UIButton *)btn{
    dispatch_async(dispatch_get_main_queue(), ^{
        AVCaptureViewController *AVCaptureVC = [[AVCaptureViewController alloc] init];
        AVCaptureVC.getidnumber = ^(NSString *num) {
            self.userIDNumber.text = num;
        };
        [self.navigationController pushViewController:AVCaptureVC animated:YES];
    });
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 52;
    }else{
        return 52;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,52)];
    content.backgroundColor = [UIColor whiteColor];
    UILabel *desLTitle = [UILabel new];
    desLTitle.textAlignment = NSTextAlignmentLeft;
    desLTitle.font = Font(16);
    desLTitle.textColor = DefaultGrayTextClor;
    [content addSubview:desLTitle];
    [desLTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(40);
    }];
    desLTitle.text = @"联系人信息";
    return content;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataArray safeObjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.model.status isEqualToString:@"1"]) {
        weakify(self);
        if (indexPath.section == 0 && indexPath.row == 4) {
            self.selectSex = [[HClActionSheet alloc] initWithTitle:@"请选择性别" style:HClSheetStyleWeiChat itemTitles:@[@"男",@"女"]];
            self.selectSex.delegate = self;
            self.selectSex.tag = 60;
            self.selectSex.titleTextColor = DefaultBlackLightTextClor;
            self.selectSex.titleTextFont = Font(16);
            self.selectSex.itemTextFont = [UIFont systemFontOfSize:16];
            self.selectSex.itemTextColor = DefaultGrayTextClor;
            self.selectSex.cancleTextFont = [UIFont systemFontOfSize:16];
            self.selectSex.cancleTextColor = DefaultGrayTextClor;
            [self.selectSex didFinishSelectIndex:^(NSInteger index, NSString *title) {
                strongify(self);
                self.userSex.text = title;
            }];
        }
        if (indexPath.section == 0 && indexPath.row == 9) {//选择套餐
            //选择时间
            RMCalendarController *c = [RMCalendarController calendarWithDays:365 showType:CalendarShowTypeMultiple];
            // 此处用到MJ大神开发的框架，根据自己需求调整是否需要
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            //用[NSDate date]可以获取系统当前时间
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
            
            NSLog(@"%@",currentDateStr);
            NSArray *dateStr = [currentDateStr componentsSeparatedByString:@"-"];
            
            int month = [[dateStr objectAtIndex:1] intValue];
            
            int day = [[dateStr objectAtIndex:2] intValue];
            
            NSLog(@"%d,%d",month,day);
            c.modelArr = [TicketModel mj_objectArrayWithKeyValuesArray:@[@{@"year":@2018, @"month":@2, @"day":@14,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@15,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@16,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@17,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@18,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@19,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@20,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@21,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         @{@"year":@2018, @"month":@2, @"day":@22,
                                                                           @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                         ]]; //最后一条数据ticketCount 为0时不显示
            // 是否展现农历
            c.isDisplayChineseCalendar = YES;
            // YES 没有价格的日期可点击
            // NO  没有价格的日期不可点击
            c.isEnable = YES;
            c.title = @"体检选择日期";
            c.calendarBlock = ^(RMCalendarModel *model) {
                if (model.ticketModel.ticketCount) {
                    NSLog(@"%lu-%lu-%lu-票价%.1f",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day, model.ticketModel.ticketPrice);
                } else {
                    NSLog(@"%lu-%lu-%lu",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day);
                    NSString * month;
                    NSString * day;
                    if (model.month < 9) {
                        month = [NSString stringWithFormat:@"0%d",model.month];
                    }else{
                        month = [NSString stringWithFormat:@"%d",model.month];
                    }
                    if (model.day < 9) {
                        day = [NSString stringWithFormat:@"0%d",model.day];
                    }else{
                        day = [NSString stringWithFormat:@"%d",model.day];
                    }
                    self.userDate.text = [NSString stringWithFormat:@"%lu-%@-%@",(unsigned long)model.year,month,day];
                }
                
            };
            
            [self.navigationController pushViewController:c animated:YES];
            
        } else if (indexPath.section == 0 &&indexPath.row == 10) {//选择地区
            //选择地址
            SelectAddressViewController *address = [[SelectAddressViewController alloc]initWithid:self.model.taocanid cityid:self.model.cityid];
            address.hospital = ^(JGModel *model) {
                self.UserAddress.text = model.name;
                self.jgdetailid = model.id;
            };
            [self.navigationController pushViewController:address animated:YES];
        }
    }
}

- (void)telephone{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"拔打：400-900-1169" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-900-1169"]];
    }
}


@end
