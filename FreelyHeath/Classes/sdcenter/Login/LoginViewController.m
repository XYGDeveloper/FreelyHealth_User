//
//  LoginViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/18.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "GetCaptchaRequestApi.h"
#import "LoginRequestApi.h"
#import "LoginApi.h"
#import "getAchaApi.h"
#import "User.h"
#import "IMapi.h"
#import "IMTokenRequest.h"
#import "AgreeMmentViewController.h"
#import "Udesk.h"
#import "UdeskManager.h"
#import <JPUSHService.h>
#import "IANActivityIndicatorButton.h"
#import "UIButton+IANActivityView.h"
#import "ModifyProfileViewController.h"
#import "HDAlertView.h"
#import "SecurityUtil.h"
#import "WKWebViewController.h"
typedef NS_ENUM(NSInteger, IsNeedsToSetProfile) {
    IsNeedsToSetProfileLoginToSet, //登录需要设置用户资料
    IsNeedsToSetProfileLoginJump,  //登录时可以暂时跳过，后续再去设置
    IsNeedsToSetProfileLogin,      //可以直接登录
};
@interface LoginViewController ()<UITextFieldDelegate,ApiRequestDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@property (nonatomic,strong)UIView *tellephoneBackgroungView;
@property (nonatomic,strong)UIView *valiBackgroungView;
@property (nonatomic,strong)IANActivityIndicatorButton *loginButton;
@property (nonatomic,strong)UILabel *telephoneLabel;
@property (nonatomic,strong)UITextField *telephone;
@property (nonatomic,strong)UIView *sepLine;
@property (nonatomic,strong)UILabel *valiLabel;
@property (nonatomic,strong)UITextField *valicode;
@property (nonatomic,strong)UIButton *getVlicode;
@property (nonatomic,strong)UIButton *remarkLabel1;
@property (nonatomic,strong)UILabel *remarkLabel;
@property (nonatomic,strong)UIButton *agreement;
@property (nonatomic,strong)getAchaApi *varcodeApi; //获取验证码
@property (nonatomic,strong)LoginApi *loginApi;     //登录
@property (nonatomic,strong)IMapi *lMApi;
@property (nonatomic,strong)User *tempUser;

@end

@implementation LoginViewController

#pragma mark Apirequest_Properties

- (getAchaApi *)varcodeApi
{
    if (!_varcodeApi) {
        _varcodeApi = [[getAchaApi alloc]init];
        _varcodeApi.delegate = self;
    }
    return _varcodeApi;
}

- (LoginApi *)loginApi
{
    if (!_loginApi) {
        _loginApi = [[LoginApi alloc]init];
        _loginApi.delegate = self;
    }
    return _loginApi;
}


- (IMapi *)lMApi
{
    if (!_lMApi) {
        _lMApi = [[IMapi alloc]init];
        _lMApi.delegate = self;
    }
    return _lMApi;
}

#pragma mark Apirequest_Delegate
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    if (api == _varcodeApi) {
        [Utils removeHudFromView:self.view];
        [Utils postMessage:command.response.msg onView:self.view];
    }
    if (api == _loginApi) {
        [Utils removeAllHudFromView:self.view];
        [Utils postMessage:command.response.msg onView:self.view];
    }
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    if (api == _varcodeApi) {
        [Utils removeHudFromView:self.view];
        [Utils  postMessage:@"验证码已发送到您的手机" onView:self.view];
    }
    if (api == _loginApi) {
        [Utils removeHudFromView:self.view];
        User *user = [User mj_objectWithKeyValues:responsObject];
        self.tempUser = user;
        if ([user.update isEqualToString:@"0"]) {
            ModifyProfileViewController *profile = [[ModifyProfileViewController alloc]init];
            profile.token = self.tempUser.token;
            profile.user = self.tempUser;
            profile.isLoginEntrance = YES;
            profile.title = @"设置用户资料";
            [self.navigationController pushViewController:profile animated:YES];
        }else if ([user.update isEqualToString:@"1"]){
            IMHeader *head = [[IMHeader alloc]init];
            head.target = @"generalControl";
            head.method = @"getIMToken";
            head.versioncode = Versioncode;
            head.devicenum = Devicenum;
            head.fromtype = Fromtype;
            head.token = self.tempUser.token;
            IMBody *body = [[IMBody alloc]init];
            IMTokenRequest *request = [[IMTokenRequest alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.lMApi getyIMToken:request.mj_keyValues.mutableCopy];
        }else{
            IMHeader *head = [[IMHeader alloc]init];
            head.target = @"generalControl";
            head.method = @"getIMToken";
            head.versioncode = Versioncode;
            head.devicenum = Devicenum;
            head.fromtype = Fromtype;
            head.token = self.tempUser.token;
            IMBody *body = [[IMBody alloc]init];
            IMTokenRequest *request = [[IMTokenRequest alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.lMApi getyIMToken:request.mj_keyValues.mutableCopy];
        }
    }
    if (api == _lMApi) {
        [User setLocalUser:self.tempUser];
        [User LocalUser].IMtoken = responsObject[@"imtoken"];
        [User saveToDisk];
        //初始化Udesk
        [self setUsekWithToken:[User LocalUser].token];
        //设置推送
        [self setJSPushWithToken:[User LocalUser].token];
        [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
            NSLog(@"融云登陆成功：%@",userId);
            [User LocalUser].id = userId;
            [User saveToDisk];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"融云登陆错误：%ld",(long)status);
        } tokenIncorrect:^{
            NSLog(@"融云token错误：");
        }];
        //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
//        switch ([[RCIMClient sharedRCIMClient] getConnectionStatus]) {
//            case ConnectionStatus_Connected:
//                [Utils postMessage:@"已连接" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            case ConnectionStatus_NETWORK_UNAVAILABLE:
//                [Utils postMessage:@"未连接" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            case ConnectionStatus_Connecting:
//                [Utils postMessage:@"连接中" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            case ConnectionStatus_Unconnected:
//                [Utils postMessage:@"连接失败" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            case ConnectionStatus_SignUp:
//                [Utils postMessage:@"已注销" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            case ConnectionStatus_TOKEN_INCORRECT:
//                [Utils postMessage:@"token无效" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            case ConnectionStatus_DISCONN_EXCEPTION:
//                [Utils postMessage:@"与服务器的连接已断开,用户被封禁" onView: [UIApplication sharedApplication].keyWindow];
//                break;
//            default:
//                break;
//        }
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"auScuess" object:nil];
    }
}

- (void)setUsekWithToken:(NSString *)token{
    UdeskOrganization *organization = [[UdeskOrganization alloc] initWithDomain:@"freelyhealth.udesk.cn" appKey:@"ebbbdedbc4f0ecc4004bdc93b5d6d254" appId:@"947947b1f6b28b5a"];
    UdeskCustomer *customer = [UdeskCustomer new];
    customer.sdkToken = [User LocalUser].token;
    customer.nickName = [User LocalUser].nickname;
    customer.email = [NSString stringWithFormat:@"%@@163.com",[User LocalUser].phone];
    customer.cellphone = [User LocalUser].phone;
    customer.customerDescription = @"暂无描述";
    [UdeskManager initWithOrganization:organization customer:customer];
    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
        NSLog(@"客服用户自定义字段：%@",responseObject);
    }];
    //选择类型字段
    UdeskCustomer *updatecustomer = [UdeskCustomer new];
    updatecustomer.sdkToken = token;
    updatecustomer.nickName = [User LocalUser].nickname;
    updatecustomer.email = [NSString stringWithFormat:@"%@@163.com",[User LocalUser].phone];
    updatecustomer.cellphone = [User LocalUser].phone;
    customer.customerDescription = @"暂无描述";
    UdeskCustomerCustomField *textField = [UdeskCustomerCustomField new];
    textField.fieldKey = @"TextField_20157";
    textField.fieldValue = @"暂无留言";
    UdeskCustomerCustomField *ageField = [UdeskCustomerCustomField new];
    ageField.fieldKey = @"TextField_20522";
    ageField.fieldValue = [User LocalUser].age;
    UdeskCustomerCustomField *companyField = [UdeskCustomerCustomField new];
    companyField.fieldKey = @"TextField_21436";
    companyField.fieldValue = [User LocalUser].company;
    //选择类型字段
    UdeskCustomerCustomField *heauoField = [UdeskCustomerCustomField new];
    heauoField.fieldKey = @"SelectField_10791";
    
    if ([[User LocalUser].isvip isEqualToString:@"0"]) {
        heauoField.fieldValue = @[@"1"];
    }else{
        heauoField.fieldValue = @[@"0"];
    }
    UdeskCustomerCustomField *selectField = [UdeskCustomerCustomField new];
    selectField.fieldKey = @"SelectField_10248";
    
    if ([[User LocalUser].sex isEqualToString:@"男"]) {
        selectField.fieldValue = @[@"0"];
    }else{
        selectField.fieldValue = @[@"1"];
    }
    customer.customField = @[textField,ageField,selectField,heauoField,companyField];
    [UdeskManager updateCustomer:customer];
}

- (void)setJSPushWithToken:(NSString *)token{
    [JPUSHService setAlias:token completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        NSLog(@"iResCode = %ld, iAlias = %@, seq = %ld", iResCode, iAlias, seq);
    } seq:1];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (self.isLoghin == YES) {
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@""] highligthtedImage:[UIImage imageNamed:@""] action:nil];
    }else{
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    }
    self.title = NSLocalizedString(@"login_viewcontroller_title", nil);
    self.view.backgroundColor = DefaultBackgroundColor;
    [self layoutViewcontrollerSubview];
    [self layOutSubviews];
}

- (void)back{
    __weak __typeof(self) weakself= self;
    dispatch_async(dispatch_queue_create(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.navigationController.viewControllers.count > 1) {
                [weakself.navigationController popViewControllerAnimated:YES];
            } else {
                [weakself dismissViewControllerAnimated:YES completion:nil];
            }
        });
    });
}

- (void)layoutViewcontrollerSubview{
    self.tellephoneBackgroungView = [[UIView alloc]init];
    self.tellephoneBackgroungView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tellephoneBackgroungView];
    self.valiBackgroungView = [[UIView alloc]init];
    self.valiBackgroungView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.valiBackgroungView];
    self.agreement = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreement setImage:[UIImage imageNamed:@"vip_sexSelected"] forState:UIControlStateSelected];
    [self.agreement setImage:[UIImage imageNamed:@"vip_sexUnselected"] forState:UIControlStateNormal];
    [self.view addSubview:self.agreement];
    [self.agreement addTarget:self action:@selector(agreementAction:) forControlEvents:UIControlEventTouchUpInside];
    self.agreement.selected = YES;
    self.remarkLabel1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remarkLabel1.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我已阅读《用户协议》"];
    [str addAttribute:NSForegroundColorAttributeName value:DefaultBlueTextClor range:NSMakeRange(4,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:12.0] range:NSMakeRange(4, 6)];
    [self.remarkLabel1 setAttributedTitle:str forState:UIControlStateNormal];
    [self.remarkLabel1 setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
    [self.remarkLabel1 addTarget:self action:@selector(toRead:) forControlEvents:UIControlEventTouchUpInside];
    self.remarkLabel1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.remarkLabel1.titleLabel.font = Font(12);
    [self.view addSubview:self.remarkLabel1];
    self.remarkLabel = [[UILabel alloc]init];
    self.remarkLabel.backgroundColor = [UIColor clearColor];
    self.remarkLabel.textColor = DefaultGrayLightTextClor;
    self.remarkLabel.textAlignment = NSTextAlignmentCenter;
    self.remarkLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
    self.remarkLabel.text = NSLocalizedString(@"login_viewcontroller_remark", nil);
    [self.view addSubview:self.remarkLabel];
    self.loginButton = [[IANActivityIndicatorButton alloc] init];
    [self.view addSubview:self.loginButton];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"navi_background"] forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"login_viewcontroller_title", nil) forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 6;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.alpha = 0.4;
    weakify(self);
    self.loginButton.TouchBlock = ^(IANActivityIndicatorButton *myButton){
        strongify(self);
        [self.telephone resignFirstResponder];
        [self.valicode resignFirstResponder];
        if (self.telephone.text.length <= 0) {
            [Utils postMessage:@"请输入手机号码" onView:self.view];
            return;
        }
        
        if (self.valicode.text.length <= 0) {
            [Utils postMessage:@"请输入验证码" onView:self.view];
            return;
        }
        
        if (self.agreement.selected == NO) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我已阅读直医《用户协议》,同意直医服务协议和隐私政策，登录成功即代表已同意。"];
            [str addAttribute:NSForegroundColorAttributeName value:DefaultBlueTextClor range:NSMakeRange(4,6)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:12.0] range:NSMakeRange(4, 6)];
            UIAlertView *alert = [UIAlertView alertViewWithTitle:nil message:str.string cancelButtonTitle:@"同意并登录" otherButtonTitles:@[@"取消"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    self.agreement.selected = YES;
                    self.loginButton.alpha = 1.0f;
                    self.loginButton.enabled = YES;
                    [Utils addHudOnView:self.view withTitle:@"登录中..."];
                    LoginRequestHeader *head = [[LoginRequestHeader alloc]init];
                    
                    head.target = @"openControl";
                    
                    head.method = @"loginByCaptcha";
                    
                    head.versioncode = Versioncode;
                    
                    head.devicenum = Devicenum;
                    
                    head.fromtype = Fromtype;
                    
                    LoginRequestBody *body = [[LoginRequestBody alloc]init];
                    
                    body.phone = self.telephone.text;
                    
                    body.captcha = self.valicode.text;
                    
                    LoginRequestApi *request = [[LoginRequestApi alloc]init];
                    
                    request.head = head;
                    
                    request.body = body;
                    
                    NSLog(@"%@",request);
                    
                    [self.loginApi loginWithRequest:request.mj_keyValues.mutableCopy];
                }
            }];
            [alert show];
            return;
        }
        
        NSError *error = nil;
        if (![ValidatorUtil isValidMobile:self.telephone.text error:&error]) {
            [self toast:[error localizedDescription]];
            return;
        }
        
        self.loginButton.alpha = 1.0f;
        self.loginButton.enabled = YES;
        
        [Utils addHudOnView:self.view withTitle:@"登录中..."];
        LoginRequestHeader *head = [[LoginRequestHeader alloc]init];
        
        head.target = @"openControl";
        
        head.method = @"loginByCaptcha";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        LoginRequestBody *body = [[LoginRequestBody alloc]init];
        
        body.phone = self.telephone.text;
        
        body.captcha = self.valicode.text;
        
        LoginRequestApi *request = [[LoginRequestApi alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.loginApi loginWithRequest:request.mj_keyValues.mutableCopy];
    };
    
//    [self.loginButton addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    self.telephoneLabel = [[UILabel alloc]init];
    
    [self.tellephoneBackgroungView addSubview:self.telephoneLabel];
    
    self.telephoneLabel.text = NSLocalizedString(@"login_viewcontroller_telephonelabel", nil);
    
    self.telephoneLabel.textColor = DefaultGrayLightTextClor;
    
    self.telephoneLabel.textAlignment = NSTextAlignmentLeft;
    
    self.telephoneLabel.font = Font(16);
    
    self.telephone = [[UITextField alloc]init];
    
    [self.tellephoneBackgroungView addSubview:self.telephone];
    
    self.telephone.placeholder = NSLocalizedString(@"login_viewcontroller_telephoneplacehoder", nil);
    
    self.telephone.font = Font(16);
    
    self.telephone.keyboardType = UIKeyboardTypeNumberPad;
    
    self.telephone.delegate = self;
    
    self.telephone.clearButtonMode = UITextFieldViewModeAlways;
    
    self.sepLine = [[UIView alloc]init];
    
    self.sepLine.backgroundColor = DividerGrayColor;
    
    [self.tellephoneBackgroungView addSubview:self.sepLine];
    
    self.getVlicode = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.getVlicode setTitleColor:AppStyleColor forState:UIControlStateNormal];
    
    self.getVlicode.titleLabel.font = Font(16);
    
    [self.tellephoneBackgroungView addSubview:self.getVlicode];
    
    self.getVlicode.backgroundColor = [UIColor clearColor];
     
    [self.getVlicode setTitle:NSLocalizedString(@"login_viewcontroller_postvliacode", nil) forState:UIControlStateNormal];
  
    [self.getVlicode addTarget:self action:@selector(toGetvlicode:) forControlEvents:UIControlEventTouchUpInside];
    
    self.valiLabel = [[UILabel alloc]init];
    
    [self.valiBackgroungView addSubview:self.valiLabel];
    
    self.valiLabel.text = NSLocalizedString(@"login_viewcontroller_valicode", nil);
    
    self.valiLabel.textColor = DefaultGrayLightTextClor;
    
    self.valiLabel.textAlignment = NSTextAlignmentLeft;
    
    self.valiLabel.font = Font(16);
    
    self.valicode = [[UITextField alloc]init];
    
    [self.valiBackgroungView addSubview:self.valicode];
    
    self.valicode.placeholder = NSLocalizedString(@"login_viewcontroller_valicodeplacehoder", nil);
    
    self.valicode.font = Font(16);
    
    self.valicode.delegate = self;
    
    self.valicode.keyboardType = UIKeyboardTypeNumberPad;

    self.valicode.clearButtonMode = UITextFieldViewModeAlways;

    [self.valicode  addTarget:self action:@selector(vartextFieldChange:)forControlEvents:UIControlEventEditingChanged];
    
}

- (void)agreementAction:(UIButton *)btn{
    btn.selected = !btn.selected;
}


- (void)toRead:(UIButton *)read{
    //temp
    WKWebViewController *agree = [WKWebViewController new];
    [agree loadWebHTMLSring:@"agreement"];
    agree.hidesBottomBarWhenPushed = YES;
    agree.title = @"平台协议";
    [self.navigationController pushViewController:agree animated:YES];
}

-(void)vartextFieldChange:(id)sender
{
    if (self.valicode.text.length > 0) {
        //  1. 登录按钮变为可点击状态
        self.loginButton.alpha = 1.0;
        self.loginButton.enabled = YES;
    }else
    {
        self.loginButton.alpha = 0.4;
        self.loginButton.enabled = NO;
    }
}


- (void)layOutSubviews{

    CGFloat margin = 13.5;
    CGFloat height = 64;
    [self.tellephoneBackgroungView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(margin);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    [self.valiBackgroungView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tellephoneBackgroungView.mas_bottom).mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];

    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.valiBackgroungView.mas_bottom).mas_equalTo(7);
        make.width.mas_equalTo(187);
        make.height.mas_equalTo(14);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).mas_equalTo(60.5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(49);
    }];
    
    [self.agreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.loginButton.mas_top).mas_equalTo(-10);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
        make.left.mas_equalTo(self.valiBackgroungView.mas_left).mas_equalTo(20);
    }];
    
    [self.remarkLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.agreement.mas_centerY);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(14);
        make.left.mas_equalTo(self.agreement.mas_right).mas_equalTo(10);
    }];


    [self.telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(32);
    }];
    
    
    [self.telephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        make.left.mas_equalTo(self.telephoneLabel.mas_right);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(32);
    }];
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        make.left.mas_equalTo(self.telephone.mas_right).mas_equalTo(20);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(32);
    }];
    
    [self.getVlicode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.tellephoneBackgroungView.mas_centerY);
        make.left.mas_equalTo(_sepLine.mas_right).mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(32);
    }];
    
    [self.valiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self.valiBackgroungView.mas_centerY);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(32);
    }];
    
    
    [self.valicode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.valiBackgroungView.mas_centerY);
        make.left.mas_equalTo(self.valiLabel.mas_right);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(32);
    }];
    
}
    
#pragma mark- delegate
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
    
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void)toast:(NSString *)title
{
    [Utils showErrorMsg:self.view type:0 msg:title];
}
    
- (void)toGetvlicode:(UIButton *)sender{
     [self.view endEditing:YES];
    if (self.telephone.text.length <= 0) {
        [Utils postMessage:@"请输入手机号码" onView:self.view];
        return;
    }
    NSError *error = nil;
    if (![ValidatorUtil isValidMobile:self.telephone.text error:&error]) {
        [self toast:@"请输入正确的手机号"];
        return;
    }
    [Utils addHudOnView:self.view];
    RequestHeader *head = [[RequestHeader alloc]init];
    head.target = @"openControl";
    head.method = @"getEnter";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    RequestBody *body = [[RequestBody alloc]init];
    NSString * result = [SecurityUtil encryptAESDataToBase64:self.telephone.text app_key:@"smart@LYZ0000000"];
    body.phaes = result;
    GetCaptchaRequestApi *request = [[GetCaptchaRequestApi alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.varcodeApi getAchaCode:request.mj_keyValues.mutableCopy];
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置（倒计时结束后调用）
                [self.getVlicode setTitle:@"发送验证码" forState:UIControlStateNormal];
                //设置不可点击
                self.getVlicode.userInteractionEnabled = YES;
                [self.getVlicode setTitleColor:AppStyleColor forState:UIControlStateNormal];
                
            });
        }else{
           
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
//                NSLog(@"____%@",strTime);
                [self.getVlicode setTitle:[NSString stringWithFormat:@"重新获取%@秒",strTime] forState:UIControlStateNormal];
                //设置可点击
                self.getVlicode.userInteractionEnabled = NO;
                
                self.getVlicode.titleLabel.font = Font(14);

                [self.getVlicode setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)toLogin:(UIButton *)sender{
    
    [self.telephone resignFirstResponder];
    [self.valicode resignFirstResponder];
    if (self.telephone.text.length <= 0) {
        [Utils postMessage:@"请输入手机号码" onView:self.view];
        return;
    }
    
    if (self.valicode.text.length <= 0) {
        [Utils postMessage:@"请输入验证码" onView:self.view];
        return;
    }
    
    
    if (self.agreement.selected == NO) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"我已阅读直医《用户协议》,同意直医服务协议和隐私政策，登录成功即代表已同意。"];
        [str addAttribute:NSForegroundColorAttributeName value:DefaultBlueTextClor range:NSMakeRange(4,6)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:12.0] range:NSMakeRange(4, 6)];
        UIAlertView *alert = [UIAlertView alertViewWithTitle:nil message:str.string cancelButtonTitle:@"同意并登录" otherButtonTitles:@[@"取消"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                self.agreement.selected = YES;
                
                self.loginButton.alpha = 1.0f;
                self.loginButton.enabled = YES;
                
                [Utils addHudOnView:self.view withTitle:@"登录中..."];

                LoginRequestHeader *head = [[LoginRequestHeader alloc]init];
                
                head.target = @"openControl";
                
                head.method = @"loginByCaptcha";
                
                head.versioncode = Versioncode;
                
                head.devicenum = Devicenum;
                
                head.fromtype = Fromtype;
                
                LoginRequestBody *body = [[LoginRequestBody alloc]init];
                
                body.phone = self.telephone.text;
                
                body.captcha = self.valicode.text;
                
                LoginRequestApi *request = [[LoginRequestApi alloc]init];
                
                request.head = head;
                
                request.body = body;
                
                NSLog(@"%@",request);
                
                [self.loginApi loginWithRequest:request.mj_keyValues.mutableCopy];
            }
        }];
        [alert show];

        return;
    }

    NSError *error = nil;
    
    if (![ValidatorUtil isValidMobile:self.telephone.text error:&error]) {
        
        [self toast:[error localizedDescription]];
        
        return;
    }
    
    self.loginButton.alpha = 1.0f;
    self.loginButton.enabled = YES;
    [Utils addHudOnView:self.view withTitle:@"登录中..."];
    LoginRequestHeader *head = [[LoginRequestHeader alloc]init];
    head.target = @"openControl";
    
    head.method = @"loginByCaptcha";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    LoginRequestBody *body = [[LoginRequestBody alloc]init];
    
    body.phone = self.telephone.text;
    
    body.captcha = self.valicode.text;
    
    LoginRequestApi *request = [[LoginRequestApi alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.loginApi loginWithRequest:request.mj_keyValues.mutableCopy];
    
    
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    NSLog(@"------%@",userId);
    if ([userId isEqualToString:[User LocalUser].id]) {
        RCUserInfo *userInfo = [[RCUserInfo alloc]init];
        userInfo.userId = userId;
        userInfo.name = [User LocalUser].name;
        userInfo.portraitUri = [User LocalUser].facepath;
        return completion(userInfo);
    }
    return completion(nil);
}



@end
