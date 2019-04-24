//
//  ModifyProfileViewController.m
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ModifyProfileViewController.h"
@interface ModifyProfileViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,ApiRequestDelegate,RCIMUserInfoDataSource,RCIMGroupInfoDataSource>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)UIActionSheet *actionsheet1;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,strong)SelectTypeTableViewCell *name;
@property (nonatomic, strong) SelectSexCell *sex;
@property (nonatomic,strong)SelectTypeTableViewCell *age;
@property (nonatomic,strong)SelectTypeTableViewCell *company;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)NSString *nameString;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)NSString  *sexString;
@property (nonatomic,strong)OSSApi *Ossapi;                //请求鉴权
@property (nonatomic,strong)OSSModel *model;
@property (nonatomic,strong)MBProgressHUD *hub;
@property (nonatomic,strong)UIImage *tempImage;
@property (nonatomic,strong)UpdateUserInfoApi *update;     //设置或修改
@property (nonatomic,strong)UpdateUserInfoApi *Jumpupdate; //跳过
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)IMapi *lMApi;
@property (nonatomic,strong)IMapi *lMApi1;
@property (nonatomic,strong)UpdateUserModel *tempmodel;
@end

@implementation ModifyProfileViewController


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

#pragma mark ApiInterface

- (OSSApi *)Ossapi
{
    if (!_Ossapi) {
        _Ossapi = [[OSSApi alloc]init];
        _Ossapi.delegate  =self;
    }
    return _Ossapi;
}
- (UpdateUserInfoApi *)update
{
    if (!_update) {
        _update = [[UpdateUserInfoApi alloc]init];
        _update.delegate  =self;
    }
    return _update;
}
- (UpdateUserInfoApi *)Jumpupdate
{
    if (!_Jumpupdate) {
        _Jumpupdate = [[UpdateUserInfoApi alloc]init];
        _Jumpupdate.delegate  = self;
    }
    return _Jumpupdate;
}

- (IMapi *)lMApi
{
    if (!_lMApi) {
        _lMApi = [[IMapi alloc]init];
        _lMApi.delegate = self;
    }
    return _lMApi;
}
- (IMapi *)lMApi1
{
    if (!_lMApi1) {
        _lMApi1 = [[IMapi alloc]init];
        _lMApi1.delegate = self;
    }
    return _lMApi1;
}
#pragma #pragma mark propertyies

- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _name.selectionStyle = UITableViewCellSelectionStyleNone;
        [_name setTypeName:@"姓名" placeholder:@"请编辑姓名"];
    }
    return _name;
}
- (SelectTypeTableViewCell *)company {
    if (!_company) {
        _company = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _company.selectionStyle = UITableViewCellSelectionStyleNone;
        [_company setTypeName:@"公司" placeholder:@"请填写公司认证码或公司名称(选填)"];
    }
    return _company;
}
- (SelectSexCell *)sex {
    if (!_sex) {
        _sex = [[SelectSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_sex setEditAble:NO];
        _sex.selectionStyle = UITableViewCellSelectionStyleNone;
        [_sex setIcon:[UIImage imageNamed:@""] editedIcon:[UIImage imageNamed:@""] placeholder:@"性别"];
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

- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = RGB(213, 231, 233);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}
#pragma mark AutolayOut
- (void)layoutsubview{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)NextStep{
    if ([self.name.text isEqualToString:@""]) {
        [Utils postMessage:@"请设置姓名" onView:self.view];
        return;
    }
    
    if ([self.age.text isEqualToString:@""]) {
        [Utils postMessage:@"请设置年龄" onView:self.view];
        return;
    }
    [Utils addHudOnView:self.view withTitle:@"正在修改..."];
    updateUserHeader *head = [[updateUserHeader alloc]init];
    head.target = @"ownControl";
    head.method = @"updateUserInfo";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    if (!self.token) {
        head.token = [User LocalUser].token;
    }else{
        head.token = self.token;
    }
    updateUserBody *body = [[updateUserBody alloc]init];
    body.facepath = self.imageUrl;
    body.name = self.name.text;
    body.company = self.company.text;
    body.age = self.age.text;
    body.sex = self.sexString;
    body.type = UpfateProfile;
    UpdateUserInfo *request = [[UpdateUserInfo alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.update updateUser:request.mj_keyValues.mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self layoutsubview];
    self.dataArray = @[self.name,self.company,self.age,self.sex];
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    self.headView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headView;
    if (self.isLoginEntrance == YES) {
        [self setRightNavigationItemWithTitle:@"跳过" action:@selector(jumpStep)];
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(jumpAction)];
        [self.view addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        [self.saveButton addTarget:self action:@selector(NextStep) forControlEvents:UIControlEventTouchUpInside];
        UILabel *des = [[UILabel alloc]init];
        des.text  =@"头像";
        des.userInteractionEnabled = YES;
        des.font = Font(16);
        des.textColor = DefaultGrayTextClor;
        des.textAlignment = NSTextAlignmentLeft;
        [self.headView addSubview:des];
        [des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.headView.mas_centerY);
            make.left.mas_equalTo(20);
        }];
        self.headImage = [[UIImageView alloc]init];
        [self.headView addSubview:self.headImage];
        self.headImage.userInteractionEnabled = YES;
        self.headImage.layer.cornerRadius = 35;
        self.headImage.layer.masksToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headImage.clipsToBounds = YES;
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(des.mas_right).mas_equalTo(0);
            make.width.height.mas_equalTo(70);
            make.centerY.mas_equalTo(self.headView.mas_centerY);
        }];
        self.headImage.image = [UIImage imageNamed:@"Logo"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headView addSubview:button];
        [button setImage:[UIImage imageNamed:@"rrow"] forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.width.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.headView.mas_centerY);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHead)];
        [self.headView addGestureRecognizer:tap];
        self.name.text = [User LocalUser].name;
        self.age.text = [User LocalUser].age;
        self.company.text = [User LocalUser].company;
        if ([[User LocalUser].sex isEqualToString:@"男"]) {
            self.sex.sex = @"1";
        }else{
            self.sex.sex = @"0";
        }
        weakify(self);
        self.sex.type = ^(NSString *type) {
            NSLog(@"%@",type);
            strongify(self);
            if ([type isEqualToString:@"0"]) {
                self.sexString = @"女";
            }else{
                self.sexString = @"男";
            }
        };
        [self.tableView reloadData];
    }else{
        [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
        [self setRightNavigationItemWithTitle:@"保存" action:@selector(NextStep)];
        UILabel *des = [[UILabel alloc]init];
        des.text  =@"头像";
        des.userInteractionEnabled = YES;
        des.font = Font(16);
        des.textColor = DefaultGrayTextClor;
        des.textAlignment = NSTextAlignmentLeft;
        [self.headView addSubview:des];
        [des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.headView.mas_centerY);
            make.left.mas_equalTo(20);
        }];
        self.headImage = [[UIImageView alloc]init];
        [self.headView addSubview:self.headImage];
        self.headImage.userInteractionEnabled = YES;
        self.headImage.layer.cornerRadius = 35;
        self.headImage.layer.masksToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headImage.clipsToBounds = YES;
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(des.mas_right).mas_equalTo(0);
            make.width.height.mas_equalTo(70);
            make.centerY.mas_equalTo(self.headView.mas_centerY);
        }];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.headView addSubview:button];
        [button setImage:[UIImage imageNamed:@"rrow"] forState:UIControlStateNormal];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.width.height.mas_equalTo(25);
            make.centerY.mas_equalTo(self.headView.mas_centerY);
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHead)];
        [self.headView addGestureRecognizer:tap];
        self.name.text = [User LocalUser].name;
        self.age.text = [User LocalUser].age;
        self.company.text = [User LocalUser].company;
        if ([[User LocalUser].sex isEqualToString:@"男"]) {
            self.sex.sex = @"1";
        }else{
            self.sex.sex = @"0";
        }
        weakify(self);
        self.sex.type = ^(NSString *type) {
            NSLog(@"%@",type);
            strongify(self);
            if ([type isEqualToString:@"0"]) {
                self.sexString = @"女";
            }else{
                self.sexString = @"男";
            }
        };
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath] placeholderImage:[UIImage imageNamed:@"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/usertouxiang/logo_120.png"]];
        [self.tableView reloadData];
    }
   
}

- (void)jumpStep{
    [Utils addHudOnView:self.view];
    updateUserHeader *head = [[updateUserHeader alloc]init];
    head.target = @"ownControl";
    head.method = @"updateUserInfo";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = self.token;
    updateUserBody *body = [[updateUserBody alloc]init];
    body.type = JumpNotSet;
    UpdateUserInfo *request = [[UpdateUserInfo alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.Jumpupdate updateUser:request.mj_keyValues.mutableCopy];
}

- (void)jumpAction{
    UIAlertView *alert = [UIAlertView alertViewWithTitle:@"跳过资料设置提示" message:@"跳过资料设置，可在登录后点击头像或手机号设置资料" cancelButtonTitle:@"取消" otherButtonTitles:@[@"跳过设置"] dismissBlock:^(UIAlertView *zg_alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [Utils addHudOnView:self.view];
            updateUserHeader *head = [[updateUserHeader alloc]init];
            head.target = @"ownControl";
            head.method = @"updateUserInfo";
            head.versioncode = Versioncode;
            head.devicenum = Devicenum;
            head.fromtype = Fromtype;
            head.token = self.token;
            updateUserBody *body = [[updateUserBody alloc]init];
            body.type = JumpNotSet;
            UpdateUserInfo *request = [[UpdateUserInfo alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.Jumpupdate updateUser:request.mj_keyValues.mutableCopy];
        }
    }];
    [alert show];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changeHead{
    self.actionsheet1 = [[UIActionSheet alloc] initWithTitle:@"编辑用户头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [self.actionsheet1 showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.actionsheet1) {
        PhotoPickManager *pickManager = [PhotoPickManager shareInstance];
        [pickManager presentPicker:buttonIndex
                            target:self
                     callBackBlock:^(NSDictionary *infoDict, BOOL isCancel) {
                         self.tempImage = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
                         if (!self.tempImage) {
                             [Utils postMessage:@"请选择可编辑的照片" onView:self.view];
                             return;
                         }
                         [Utils addHudOnView:self.view withTitle:@"正在上传中..."];
                         UploadHeader *head = [[UploadHeader alloc]init];
                         
                         head.target = @"generalControl";
                         
                         head.method = @"getOssSign";
                         
                         head.versioncode = Versioncode;
                         
                         head.devicenum = Devicenum;
                         
                         head.fromtype = Fromtype;
                         
                         if (!self.token) {
                             head.token = [User LocalUser].token;
                         }else{
                             head.token = self.token;
                         }
                         UploadBody *body = [[UploadBody alloc]init];
                         
                         UploadToolRequest *request = [[UploadToolRequest alloc]init];
                         
                         request.head = head;
                         
                         request.body = body;
                         
                         NSLog(@"%@",request);
                         
                         [self.Ossapi getoss:request.mj_keyValues.mutableCopy];
                         
                     }];
        
    }else{
        
        PhotoPickManager *pickManager1 = [PhotoPickManager shareInstance];
        [pickManager1 presentPicker:buttonIndex
                             target:self
                      callBackBlock:^(NSDictionary *infoDict, BOOL isCancel) {
                          self.tempImage = [infoDict valueForKey:UIImagePickerControllerOriginalImage];
                          //
                          //请求签名
                          
                          if (!self.tempImage) {
                              [Utils postMessage:@"请选择可编辑的照片" onView:self.view];
                              return;
                          }
                          [Utils addHudOnView:self.view withTitle:@"正在上传中..."];
                          UploadHeader *header = [[UploadHeader alloc]init];
                          
                          header.target = @"generalDControl";
                          
                          header.method = @"getDOssSign";
                          
                          header.versioncode = Versioncode;
                          
                          header.devicenum = Devicenum;
                          
                          header.fromtype = Fromtype;
                          
                          if (!self.token) {
                              header.token = [User LocalUser].token;
                          }else{
                              header.token = self.token;
                          }
                          UploadBody *bodyer = [[UploadBody alloc]init];
                          UploadToolRequest *requester = [[UploadToolRequest alloc]init];
                          requester.head = header;
                          requester.body = bodyer;
                          NSLog(@"%@",requester);
                          [self.Ossapi getoss:requester.mj_keyValues.mutableCopy];
                      }];
        
    }
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeAllHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    if (api == _Ossapi) {
        OSSModel *model = responsObject;
        NSLog(@"%@",responsObject);
        [Utils removeAllHudFromView:self.view];
        [Utils postMessage:@"上传成功" onView:self.view];
        [OSSImageUploader asyncUploadImages:@[self.tempImage] access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            for (NSString *name in names) {
                NSString *url = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,name];
                self.imageUrl = url;
                [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl]];
            }
            
        }];
    }
    
    if (api == _update) {
        self.tempmodel = [UpdateUserModel mj_objectWithKeyValues:responsObject];
        if (self.isLoginEntrance == YES) {
            [Utils removeAllHudFromView:self.view];
            IMHeader *head = [[IMHeader alloc]init];
            head.target = @"generalControl";
            head.method = @"getIMToken";
            head.versioncode = Versioncode;
            head.devicenum = Devicenum;
            head.fromtype = Fromtype;
            head.token = self.token;
            IMBody *body = [[IMBody alloc]init];
            IMTokenRequest *request = [[IMTokenRequest alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.lMApi getyIMToken:request.mj_keyValues.mutableCopy];
            
        }else{
            [User LocalUser].facepath = self.tempmodel.facepath;
            [User LocalUser].name = self.tempmodel.name;
            [User LocalUser].age = self.tempmodel.age;
            [User LocalUser].sex = self.tempmodel.sex;
            [User LocalUser].isvip = self.tempmodel.isvip;
            [User LocalUser].company = self.tempmodel.company;
            [User saveToDisk];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
            [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
        }
    }
    
    if (api == _Jumpupdate) {
        IMHeader *head = [[IMHeader alloc]init];
        head.target = @"generalControl";
        head.method = @"getIMToken";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = self.token;
        IMBody *body = [[IMBody alloc]init];
        IMTokenRequest *request = [[IMTokenRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.lMApi1 getyIMToken:request.mj_keyValues.mutableCopy];
    }
    
    if (api == _lMApi1) {
        [User setLocalUser:self.user];
        [User LocalUser].IMtoken = responsObject[@"imtoken"];
        [User saveToDisk];
        [[RCIM sharedRCIM] connectWithToken:responsObject[@"imtoken"] success:^(NSString *userId) {
            NSLog(@"融云登陆成功：%@",userId);
            [User LocalUser].id = userId;
            [User saveToDisk];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"融云登陆错误：%ld",(long)status);
        } tokenIncorrect:^{
            NSLog(@"融云token错误：");
        }];
        [Utils removeHudFromView:self.view];
        [Utils postMessage:@"设置成功" onView:self.view];
        [User LocalUser].IMtoken = responsObject[@"imtoken"];
        [User saveToDisk];
        [self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"设置成功");
        }];
     
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
    }
    
    if (api == _lMApi) {
        [Utils removeAllHudFromView:self.view];
        [User setLocalUser:self.user];
        [User LocalUser].IMtoken = responsObject[@"imtoken"];
        [User saveToDisk];
        [self dismissViewControllerAnimated:YES completion:^{
            [Utils postMessage:@"设置成功" onView:self.view];
            NSLog(@"设置成功");
        }];
        [User LocalUser].facepath = self.tempmodel.facepath;
        [User LocalUser].name = self.tempmodel.name;
        [User LocalUser].age = self.tempmodel.age;
        [User LocalUser].sex = self.tempmodel.sex;
        [User LocalUser].isvip = self.tempmodel.isvip;
        [User LocalUser].company = self.tempmodel.company;
        [User saveToDisk];
        [[RCIM sharedRCIM] connectWithToken:[User LocalUser].IMtoken success:^(NSString *userId) {
            NSLog(@"融云登陆成功：%@",userId);
            [User LocalUser].id = userId;
            [User saveToDisk];
        } error:^(RCConnectErrorCode status) {
            NSLog(@"融云登陆错误：%ld",(long)status);
        } tokenIncorrect:^{
            NSLog(@"融云token错误：");
        }];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];

        //选择类型字段
        UdeskCustomer *updatecustomer = [UdeskCustomer new];
        updatecustomer.sdkToken = [User LocalUser].token;
        updatecustomer.nickName = self.tempmodel.name;
        updatecustomer.customerDescription = @"暂无描述";
        UdeskCustomerCustomField *textField = [UdeskCustomerCustomField new];
        textField.fieldKey = @"TextField_20157";
        textField.fieldValue = @"暂无留言";
        UdeskCustomerCustomField *ageField = [UdeskCustomerCustomField new];
        ageField.fieldKey = @"TextField_20522";
        ageField.fieldValue = self.tempmodel.age;
        
        UdeskCustomerCustomField *companyField = [UdeskCustomerCustomField new];
        companyField.fieldKey = @"TextField_21436";
        companyField.fieldValue = self.tempmodel.company;
        
        //选择类型字段
        UdeskCustomerCustomField *heauoField = [UdeskCustomerCustomField new];
        heauoField.fieldKey = @"SelectField_10791";
        if ([self.tempmodel.isvip isEqualToString:@"0"]) {
            heauoField.fieldValue = @[@"1"];
        }else{
            heauoField.fieldValue = @[@"0"];
        }
        
        UdeskCustomerCustomField *selectField = [UdeskCustomerCustomField new];
        selectField.fieldKey = @"SelectField_10248";
        
        if ([self.tempmodel.sex isEqualToString:@"男"]) {
            
            selectField.fieldValue = @[@"0"];
            
        }else{
            
            selectField.fieldValue = @[@"1"];
            
        }
        updatecustomer.customField = @[textField,ageField,selectField,heauoField,companyField];
        
        [UdeskManager updateCustomer:updatecustomer];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
        
    }
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataArray safeObjectAtIndex:indexPath.row];
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0)
            return CGFLOAT_MIN;
        return 10;
    }else{
        if (section == 0)
            return CGFLOAT_MIN;
        return 10;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
