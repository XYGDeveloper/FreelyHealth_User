//
//  ToSubsViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ToSubsViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "SelectAddressViewController.h"
#import "RMCalendarController.h"
#import "MJExtension.h"
#import "TicketModel.h"
#import "TJyuyueApi.h"
#import "TJyuyueRequest.h"
#import "CommitSubsRequest.h"
#import "CommitSubsApi.h"
#import "SubscribeListViewController.h"
#import "JGModel.h"
#import "HClActionSheet.h"
#import "Location_Manager.h"
#import "AddressTableViewCell.h"
#import "AVCaptureViewController.h"
@interface ToSubsViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,UIAlertViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)SelectTypeTableViewCell *userCarNumber;  //体检卡号
@property (nonatomic,strong)SelectTypeTableViewCell *userCode;       //验证码
@property (nonatomic,strong)SelectTypeTableViewCell *pakageType;     //体检套餐
@property (nonatomic,strong)SelectTypeTableViewCell *userName;       //姓名
@property (nonatomic,strong)SelectTypeTableViewCell *userSex;        //性别
@property (nonatomic,strong)SelectTypeTableViewCell *userAge;        //年龄
@property (nonatomic,strong)SelectTypeTableViewCell *userPhone;      //手机号
@property (nonatomic,strong)SelectTypeTableViewCell *userIDNumber;  //身份证号
@property (nonatomic,strong)AddressTableViewCell *userDetailAddress;  //详细地址
@property (nonatomic,strong)SelectTypeTableViewCell *userDate;       //预约时间
@property (nonatomic,strong)SelectTypeTableViewCell *UserAddress;    //体检地址

@property (nonatomic, strong) NSArray *dataArray;
//提交显示
@property (nonatomic,strong)UIButton *commitSubs;
@property (nonatomic,assign)BOOL isMessage;
//
@property (nonatomic,strong)TJyuyueApi *getTJapi;
@property (nonatomic,strong)CommitSubsApi *commitTJapi;
//
@property (nonatomic,strong)NSString *packageName; //套餐名
@property (nonatomic,strong)NSString *packageId; //套餐id
@property (nonatomic,strong)NSString *packageCityId; //套餐城市id
@property (nonatomic,strong)NSString *childsubId; //套餐城市id
@property (nonatomic,strong)NSString *orderId; //套餐城市id

@property (nonatomic,strong)HClActionSheet *selectSex;
@property (nonatomic,strong)UILabel *headView;
@property (nonatomic,strong)UIButton *ocrButton;
@property(nonatomic,strong)Location_Manager *location;

@end

@implementation ToSubsViewController

- (TJyuyueApi *)getTJapi{
    if (!_getTJapi) {
        _getTJapi = [[TJyuyueApi alloc]init];
        _getTJapi.delegate = self;
    }
    return _getTJapi;
}
- (CommitSubsApi *)commitTJapi{
    if (!_commitTJapi) {
        _commitTJapi = [[CommitSubsApi alloc]init];
        _commitTJapi.delegate = self;
    }
    return _commitTJapi;
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
        _userCarNumber.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userCarNumber.selectionStyle = UITableViewCellSelectionStyleNone;
        [_userCarNumber setTypeName:@"体检卡号" placeholder:@"请输入体检卡号"];
        _userCarNumber.textField.textColor = DefaultGrayTextClor;
    }
    return _userCarNumber;
}
- (SelectTypeTableViewCell *)userCode {
    if (!_userCode) {
        _userCode = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userCode.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_userCode setTypeName:@"验证码" placeholder:@"请输入体检卡验证码"];
        _userCode.selectionStyle = UITableViewCellSelectionStyleNone;
        [_userCode setEditAble:NO];
        _userCode.textField.textColor = DefaultGrayTextClor;
    }
    return _userCode;
}
- (SelectTypeTableViewCell *)pakageType {
    if (!_pakageType) {
        _pakageType = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_pakageType setTypeName:@"体检套餐" placeholder:@"填写完体检卡信息自动获得"];
        [_pakageType setEditAble:NO];
        _pakageType.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _pakageType;
}
//姓名
- (SelectTypeTableViewCell *)userName {
    if (!_userName) {
        _userName = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userName.textField.clearButtonMode = UITextFieldViewModeAlways;
        _userName.text = [User LocalUser].name;
        [_userName setTypeName:@"姓        名" placeholder:@"请输入体检人姓名"];
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
        [_userSex setTypeName:@"性        别" placeholder:@"请选择体检人性别"];
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
        _userAge.textField.clearButtonMode = UITextFieldViewModeAlways;
        _userAge.text = [User LocalUser].age;
        [_userAge setTypeName:@"年        龄" placeholder:@"请输入体检人年龄"];
        _userAge.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _userAge;
}

//手机号码
- (SelectTypeTableViewCell *)userPhone {
    if (!_userPhone) {
        _userPhone = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_userPhone setTypeName:@"手机号码" placeholder:@"请输入接受预定信息手机号码"];
        _userPhone.textField.clearButtonMode = UITextFieldViewModeAlways;
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

- (AddressTableViewCell *)userDetailAddress {
    if (!_userDetailAddress) {
        _userDetailAddress = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userDetailAddress.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_userDetailAddress setTypeName:@"地        址" placeholder:@"便于接收体检报告"];
        _userDetailAddress.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _userDetailAddress;
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
- (UIButton *)commitSubs
{
    if (!_commitSubs) {
        _commitSubs = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitSubs setTitle:@"提交预约" forState:UIControlStateNormal];
        [_commitSubs setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitSubs.backgroundColor = AppStyleColor;
        _commitSubs.titleLabel.font = Font(20);
    }
    return _commitSubs;
}

//- (BOOL)isEditTextfield{
//
//
//}

- (void)layoutsubview{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];

    [self.commitSubs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  =@"体检预约";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"tel"] highligthtedImage:[UIImage imageNamed:@"tel"] action:@selector(telephone)];
    [self.view addSubview:self.tableView];
    self.headView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    self.headView.textColor = DefaultGrayLightTextClor;
    self.headView.numberOfLines = 0;
    self.headView.font  =FontNameAndSize(12);
    self.headView.text = @"  ⦿1.请查收手机短信，在此填写您的体检卡号和验证码\n  ⦿2.体检套餐自动获取，无需填写，其他信息需要填写";
    self.tableView.tableHeaderView = self.headView;
    [self.view addSubview:self.commitSubs];
    [self.commitSubs addTarget:self action:@selector(tocommit) forControlEvents:UIControlEventTouchUpInside];
    [self layoutsubview];
    self.dataArray = @[self.userCarNumber, self.userCode, self.pakageType,self.userName,self.userSex,self.userAge,self.userPhone,self.userIDNumber,self.userDetailAddress,self.userDate,self.UserAddress];
    [self.userCarNumber.textField  addTarget:self action:@selector(cartextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    [self.userCode.textField  addTarget:self action:@selector(vartextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    weakify(self);
    self.userDetailAddress.location = ^{
        strongify(self);
        [self start_locationManager];
    };
    
    [self.ocrButton addTarget:self action:@selector(toocr:) forControlEvents:UIControlEventTouchUpInside];
 
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
-(void)cartextFieldChange:(id)sender
{
    if (self.userCarNumber.textField.text.length <= 0 ||[self.userCarNumber.text isEqualToString:@""]) {
        [self.userCode setEditAble:NO];
        self.isMessage = NO;
        self.userCode.text = @"";
    }else{
        [self.userCode setEditAble:YES];
        self.isMessage = YES;
    }
}
-(void)vartextFieldChange:(id)sender
{
    if (self.userCode.textField.text.length >= 6) {
        [self.userCode.textField resignFirstResponder];
        //请求获得套餐名接口
        TJyuyueHeader *tjhead = [[TJyuyueHeader alloc]init];
        tjhead.target = @"orderControl";
        tjhead.method = @"getTaocan";
        tjhead.versioncode = Versioncode;
        tjhead.devicenum = Devicenum;
        tjhead.fromtype = Fromtype;
        tjhead.token = [User LocalUser].token;
        TJyuyueBody *tjbody = [[TJyuyueBody alloc]init];
        tjbody.num = self.userCarNumber.text;
        tjbody.pwd = self.userCode.text;
        TJyuyueRequest *tjrequest = [[TJyuyueRequest alloc]init];
        tjrequest.head = tjhead;
        tjrequest.body = tjbody;
        [self.getTJapi TJyuyue:tjrequest.mj_keyValues.mj_keyValues];
    }else{
        [self.userCode setEditAble:YES];
    }
    
}

-(void)toast:(NSString *)title
{
    [Utils showErrorMsg:self.view type:0 msg:title];
}

- (void)tocommit{
    //提交预约订单填写
    if (self.userCarNumber.text.length <= 0) {
        [Utils postMessage:@"请输入体检卡号" onView:self.view];
        return;
    }
    if (self.userCode.text.length <= 0) {
        [Utils postMessage:@"请输入体检卡号短信验证码" onView:self.view];
        return;
    }
    if (self.userName.text.length <= 0) {
        [Utils postMessage:@"请输入体检人姓名" onView:self.view];
        return;
    }
    if (self.userSex.text.length <= 0) {
        [Utils postMessage:@"请选择体检人性别" onView:self.view];
        return;
    }
    if (self.userAge.text.length <= 0) {
        [Utils postMessage:@"请输入体检人年龄" onView:self.view];
        return;
    }
    if (self.userPhone.text.length <= 0) {
        [Utils postMessage:@"请输入便于接受体检信息的体检人手机号码" onView:self.view];
        return;
    }
    
    NSError *error;
    if (![ValidatorUtil isValidMobile:self.userPhone.text error:&error]) {
            [self toast:@"请输入正确的手机号"];
            return;
        }
    if (self.userIDNumber.text.length < 16) {
        [Utils postMessage:@"请输入正确的体检人的身份证号" onView:self.view];
        return;
    }
    if (self.userIDNumber.text.length <= 0) {
        [Utils postMessage:@"请输入体检人身份证号" onView:self.view];
        return;
    }
    if (self.userDetailAddress.text.length <= 0) {
        [Utils postMessage:@"请输入体检人详细地址" onView:self.view];
        return;
    }
    if (self.UserAddress.text.length <= 0) {
        [Utils postMessage:@"请选择体检地址" onView:self.view];
        return;
    }
    if (self.userDate.text.length <= 0) {
        [Utils postMessage:@"请选择可选的体检预约时间" onView:self.view];
        return;
    }
            CommitTJyuyueHeader *tjhead = [[CommitTJyuyueHeader alloc]init];
            tjhead.target = @"orderControl";
            tjhead.method = @"yuyue";
            tjhead.versioncode = Versioncode;
            tjhead.devicenum = Devicenum;
            tjhead.fromtype = Fromtype;
            tjhead.token = [User LocalUser].token;
            CommitTJyuyueBody *tjbody = [[CommitTJyuyueBody alloc]init];
            tjbody.tjnum = self.userCarNumber.text;
            tjbody.tjpwd = self.userCode.text;
            tjbody.taocanid = self.packageId;
            tjbody.jgdetailid = self.childsubId;
            tjbody.tjtime = self.userDate.text;
            tjbody.id = self.orderId;
            tjbody.patientname = self.userName.text;
            tjbody.patientage = self.userAge.text;
            tjbody.patientphone = self.userPhone.text;
            tjbody.patientsex = self.userSex.text;
            tjbody.patientname = self.userName.text;
            tjbody.patientaddress = self.userDetailAddress.textField.text;
            tjbody.patientidentity = self.userIDNumber.text;
            CommitSubsRequest *tjrequest = [[CommitSubsRequest alloc]init];
            tjrequest.head = tjhead;
            tjrequest.body = tjbody;
            [self.commitTJapi toCommit:tjrequest.mj_keyValues.mutableCopy];
    
}
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _getTJapi) {
        //获得体检
        self.packageId = responsObject[@"id"];
        self.packageCityId = responsObject[@"cityid"];
        self.pakageType.text = responsObject[@"name"];
        self.orderId = responsObject[@"orderid"];
        self.userName.text = responsObject[@"patientname"];
        self.userPhone.text = responsObject[@"patientphone"];
        self.userDetailAddress.textField.text = responsObject[@"patientaddress"];
    }
    if (api == _commitTJapi) {
        
        if (self.orderEnter == YES) {
            //提交预约体检
            SubscribeListViewController *sublist = [SubscribeListViewController new];
            sublist.orderEnter = YES;
            sublist.title = @"体检预约列表";
            [self.navigationController pushViewController:sublist animated:YES];
        }else{
            //提交预约体检
            SubscribeListViewController *sublist = [SubscribeListViewController new];
            sublist.title = @"体检预约列表";
            [self.navigationController pushViewController:sublist animated:YES];
        }
      
        
    }
}
- (void)back{
    if (self.orderEnter == YES) {
        [Utils jumpToHomepage];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    if (indexPath.section == 0 && indexPath.row == 8) {
        return 52;
    }else{
        return 52.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dataArray safeObjectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
        c.modelArr = [TicketModel mj_objectArrayWithKeyValuesArray:@[@{@"year":@2018, @"month":@(month), @"day":@(day + 0),
                                                                       @"ticketCount":@194, @"ticketPrice":@"不可预约"},
                                                                     @{@"year":@2018, @"month":@(month), @"day":@(day + 1),
                                                                       @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                     @{@"year":@2018, @"month":@(month), @"day":@(day + 2),
                                                                       @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                     @{@"year":@2018, @"month":@(month), @"day":@(day -1),
                                                                       @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                     @{@"year":@2018, @"month":@(month), @"day":@(day +3),
                                                                       @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                     @{@"year":@2018, @"month":@(month), @"day":@(day +4),
                                                                       @"ticketCount":@91, @"ticketPrice":@"不可预约"},
                                                                     @{@"year":@2018, @"month":@2, @"day":@14,
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
                NSLog(@"%lu-%lu-%lu-票价%@",(unsigned long)model.year,(unsigned long)model.month,(unsigned long)model.day, model.ticketModel.ticketPrice);
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
        if (self.packageCityId.length <= 0) {
            [Utils postMessage:@"需要先获得套餐！" onView:self.view];
            return;
        }
        SelectAddressViewController *address = [[SelectAddressViewController alloc]initWithid:self.packageId cityid:self.packageCityId];
        NSLog(@"%@\n%@",self.packageId,self.packageCityId);
        address.hospital = ^(JGModel *model) {
            self.UserAddress.text = model.name;
            self.childsubId = model.id;
        };
        
        [self.navigationController pushViewController:address animated:YES];
        
    } else if (indexPath.section == 0 &&indexPath.row == 1) {
        if (self.isMessage == NO) {
            [Utils postMessage:@"请先输入体检卡号！" onView:self.view];
            return;
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

- (void)start_locationManager{
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.desiredAccuracy  =  kCLLocationAccuracyBest;       //最精确模式
        [_locationManager requestAlwaysAuthorization];                      //iOS8需要加上，不然定位失败
        _locationManager.delegate = self;                                   //代理
        _locationManager.distanceFilter = 5.0f;                             //至少5米才请求一次数据
        [_locationManager startUpdatingLocation];                           //开始定位
        
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
        //        Utils postMessage:@"请打开定位才能使用，否则你将无法上传信息" onView:[];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
    [_locationManager stopUpdatingLocation];//关闭定位
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"定位成功");
    CLLocation *newLocation = locations[0];
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude, newLocation.coordinate.longitude]);
    _latitude = newLocation.coordinate.latitude;
    _longitude = newLocation.coordinate.longitude;
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            // Country(国家) State(城市) SubLocality(区)
            NSArray *cityArr = [test objectForKey:@"FormattedAddressLines"];
            NSLog(@"-------%@", cityArr[0]);
            NSString *address = cityArr[0];
            self.addressString = cityArr[0];
            self.userDetailAddress.textField.text = address;
            [self stop_LocationManager];
//            self.userDetailAddress.text = cityArr[0];
            NSLog(@",,,,,,,,%@",self.addressString);
        }
    }];
}

- (void)stop_LocationManager{
    [_locationManager stopUpdatingLocation];//关闭定位
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
