//
//  MedicalFillOrderViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MedicalFillOrderViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "TJDistriTableViewCell.h"
#import "HClActionSheet.h"
//测试页面
#import "MedicalPayScuessViewController.h"
#import "SubscribeListViewController.h"
#import "GetTJPriceAndNameRequest.h"
#import "GetPriceAndName.h"
#import "PriceModel.h"
#import "CityListApi.h"
#import "GetOrderCityListRequest.h"
#import "CityModel.h"
#import "OrderCommitApi.h"
#import "OrderCommitRequest.h"
#import "CustomShareView.h"
#import "AliModel.h"
#import "AlipayRequest.h"
#import "AlipayApi.h"
#import "AlipayService.h"
#import "WXCreatOrderApi.h"
#import "CreatWXOrderRequest.h"
#import "WXPayService.h"
#import "WXPayReq.h"
#import "WXorderModel.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"
#import "CommitOrderModel.h"
#import "MedicalPayScuessViewController.h"
#import "PriceSelectTableViewCell.h"
#import "priceCounterApi.h"
#import "PriceCounterRequest.h"
#import "SumModel.h"
#import "PriceSelectNoPriceTableViewCell.h"
#import "TJorderCommitRequest.h"
#import "deleteApi.h"
#import "DeleteOrderRequest.h"
#import "AddressTableViewCell.h"
#import "Location_Manager.h"
#import "OrderConponListViewController.h"
#import "PayModeViewController.h"
#import "OrderModel.h"
#import "OrderConponListApi.h"
#import "MyconponListRequest.h"
#import "MyconponListModel.h"
#import "TunorDetail.h"
@interface MedicalFillOrderViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,ApiRequestDelegate,selectPayModelDelegate,CLLocationManagerDelegate>
{
    CustomShareView *_customShareView;
}
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong)PriceSelectTableViewCell *pakageType;

@property (nonatomic,strong)SelectTypeTableViewCell *userName;

@property (nonatomic,strong)SelectTypeTableViewCell *userPhone;

@property (nonatomic,strong)AddressTableViewCell *userDetailAddress;  //详细地址

@property (nonatomic,strong)SelectTypeTableViewCell *userCarNumber;

@property (nonatomic,strong)SelectTypeTableViewCell *UserAddress;

@property (nonatomic,strong)SelectTypeTableViewCell *conpon;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *sectionDataArray;
@property (nonatomic, strong) NSArray *conponArray;
//选择属性
@property (nonatomic,strong)HClActionSheet *selectSex;
@property (nonatomic,strong)HClActionSheet *selectAddress;
//提交订单和价格显示
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *bgpriceLabel;
@property (nonatomic,strong)UIButton *commitOrder;
//api
@property (nonatomic,strong)GetPriceAndName *priceApi;
@property (nonatomic,strong)PriceModel *model;
@property (nonatomic,strong)SumModel *summodel;
//
@property (nonatomic,strong)CityListApi *cityApi;
@property (nonatomic,strong)NSMutableArray *cityList;
@property (nonatomic,strong)NSMutableArray *citysArr;
@property (nonatomic,strong)NSString *cityid;
//
@property (nonatomic,strong)OrderCommitApi *ordercommitApi;
@property (nonatomic,strong)CommitOrderModel *orderModel;
@property (nonatomic,strong)AlipayApi *alipay;
@property (nonatomic,strong)WXCreatOrderApi *wxOrder;
//
@property (nonatomic,strong)priceCounterApi *priceCApi;
@property (nonatomic,assign)int count;
@property (nonatomic,assign)double sumPrice;
@property (nonatomic,strong)deleteApi *deleteApi;
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,assign)float latitude;
@property (nonatomic,assign)float longitude;
@property(nonatomic,strong)Location_Manager *location;
//
@property (nonatomic,strong)OrderConponListApi *myconponApi;
@property (nonatomic,strong)NSMutableArray *myconponArray;
@property (nonatomic,strong)TunorDetail *detailModel;
//
@property (nonatomic,strong)NSString *conponid;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *conponprice;
@property (nonatomic,strong)NSString *sumprice;
//
@property (nonatomic,assign)BOOL isOption;
@end

@implementation MedicalFillOrderViewController

- (GetPriceAndName *)priceApi{
    if (!_priceApi) {
        _priceApi = [[GetPriceAndName alloc]init];
        _priceApi.delegate = self;
    }
    return _priceApi;
}
- (CityListApi *)cityApi
{
    if (!_cityApi) {
        _cityApi = [[CityListApi alloc]init];
        _cityApi.delegate  =self;
    }
    return _cityApi;
}
- (NSMutableArray *)cityList
{
    if (!_cityList) {
        _cityList = [NSMutableArray array];
    }
    return _cityList;
}
- (NSMutableArray *)citysArr
{
    if (!_citysArr) {
        _citysArr = [NSMutableArray array];
    }
    return _citysArr;
}

-(OrderConponListApi *)myconponApi{
    if (!_myconponApi) {
        _myconponApi = [[OrderConponListApi alloc]init];
        _myconponApi.delegate  = self;
    }
    return _myconponApi;
}

- (OrderCommitApi *)ordercommitApi
{
    if (!_ordercommitApi) {
        _ordercommitApi = [[OrderCommitApi alloc]init];
        _ordercommitApi.delegate  =self;
    }
    return _ordercommitApi;
}
- (AlipayApi *)alipay
{
    if (!_alipay) {
        _alipay = [[AlipayApi alloc]init];
        _alipay.delegate  =self;
    }
    return _alipay;
}

- (WXCreatOrderApi *)wxOrder
{
    if (!_wxOrder) {
        _wxOrder = [[WXCreatOrderApi alloc]init];
        _wxOrder.delegate  = self;
    }
    return _wxOrder;
}

- (priceCounterApi *)priceCApi
{
    if (!_priceCApi) {
        _priceCApi = [[priceCounterApi alloc]init];
        _priceCApi.delegate  =self;
    }
    return _priceCApi;
}

- (deleteApi *)deleteApi
{
    if (!_deleteApi) {
        _deleteApi = [[deleteApi alloc]init];
        _deleteApi.delegate  =self;
    }
    return _deleteApi;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)dealWithPayResult:(NSString *)result {
    
    NSString *msg = nil;
    
    if ([result isEqualToString:PayResultTypeCancel]) {
        msg = @"您取消了支付";
        NSLog(@"%@",msg);
        [Utils postMessage:msg onView:self.view];
    } else if ([result isEqualToString:PayResultTypeFailed]) {
        msg = @"支付失败";
        [Utils postMessage:msg onView:self.view];
    } else if ([result isEqualToString:PayResultTypeSuccess]) {
        msg = @"支付成功";
        [Utils postMessage:msg onView:self.view];
        MedicalPayScuessViewController *scuess = [[MedicalPayScuessViewController alloc]init];
        scuess.orderid = self.orderModel.orderid;
        scuess.title = @"支付成功";
        [self.navigationController pushViewController:scuess animated:YES];
    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeAllHudFromView:self.view];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _deleteApi) {
        
        [Utils removeHudFromView:self.view];
        tjorderCommitHeader *commithead = [[tjorderCommitHeader alloc]init];
        
        commithead.target = @"orderControl";
        
        commithead.method = @"createOrder";
        
        commithead.versioncode = Versioncode;
        
        commithead.devicenum = Devicenum;
        
        commithead.fromtype = Fromtype;
        
        commithead.token = [User LocalUser].token;
        
        tjorderCommitBody *commitOrderbody = [[tjorderCommitBody alloc]init];
        
        commitOrderbody.taocanid = self.id;
        
        commitOrderbody.cityid = self.cityid;
        
        commitOrderbody.patientname  = self.userName.text;
        
        commitOrderbody.patientphone = self.userPhone.text;
        
        commitOrderbody.patientaddress = self.userDetailAddress.text;
        commitOrderbody.type = @"2";
        commitOrderbody.zilist = self.zilist;
        commitOrderbody.count = self.count;
        commitOrderbody.price = self.price;
        commitOrderbody.couponprice = self.conponprice;
        commitOrderbody.sumprice = [self.sumprice doubleValue];
        commitOrderbody.coupondetailid = self.conponid;
        TJorderCommitRequest *cityrequest = [[TJorderCommitRequest alloc]init];
        cityrequest.head = commithead;
        cityrequest.body = commitOrderbody;
        [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];
        
    }
    if (api == _priceApi) {
            PriceModel *model = responsObject;
            self.model = model;
           [self findConponWithPid:self.id];
            self.priceLabel.text = [NSString stringWithFormat:@"合计:￥%@",self.model.price];
            priceHeader *pricehead = [[priceHeader alloc]init];
            pricehead.target = @"noTokenOrderControl";
            pricehead.method = @"sumPrice";
            pricehead.versioncode = Versioncode;
            pricehead.devicenum = Devicenum;
            pricehead.fromtype = Fromtype;
            priceBody *pricebody = [[priceBody alloc]init];
            pricebody.id = self.id;
            pricebody.fuwufei = self.model.fuwufei;
            pricebody.coupondetailid = self.conponid;
            pricebody.count = self.count;
            PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
            pricerequest.head = pricehead;
            pricerequest.body = pricebody;
            [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
    }
  
    if (api == _cityApi) {
        self.citysArr = responsObject;
                for (CityModel *model in responsObject) {
                    [self.cityList addObject:model.name];
                    self.UserAddress.text = self.cityList[0];
                    self.cityid = model.id;
        }
    }

    [self.tableView reloadData];
    if (api==_myconponApi) {
        self.myconponArray = [NSMutableArray array];
        [self.myconponArray removeAllObjects];
        self.myconponArray = responsObject;
        if (self.myconponArray.count<=0) {
            self.conpon.text = @"无优惠券可用";
//            self.conponid = @"";
//            self.price = self.tempPrice;
//            self.sumprice = self.tempPrice;
        }else{
            if (self.isOption == YES) {
                
            }else{
                self.conpon.text = @"有优惠券可用";
            }
            //            MyconponListModel *model =[self.myconponArray firstObject];
            //            self.conpon.text = [NSString stringWithFormat:@"-￥%@",model.denominat];
            //            self.conponid = model.id;
            //            self.conponPrice = model.denominat;
            //            self.componModel = model;
            //            [self counterPriceWithPid:self.planid count:1 fuwufei:@"0" coupondetailid:model.id];
        }
    }
    if (api == _ordercommitApi) {
        [Utils removeAllHudFromView:self.view];
        self.orderModel = responsObject;
        self.orderid = self.orderModel.orderid;
//        [Utils postMessage:@"提交订单成功" onView:self.view];
        [_customShareView showInView:self.view];

    }
    if (api == _alipay) {
        [Utils removeHudFromView:self.view];
        if ([AlipayService isAlipayAppInstalled]) {
            AliModel *model = responsObject;
            [[AlipayService defaultService]payOrderWithInfo:model.info withCompletionBlock:^(NSString *result) {
               [self dealWithPayResult:result];
            }];
        }
    }
    
    if (api == _wxOrder) {
        [Utils removeHudFromView:self.view];
        NSLog(@"%@",responsObject);
        NSString * result = [SecurityUtil decryptAESStringFromBase64:responsObject app_key:@"smart@LYZ0000000"];
        NSData *jsondata = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dic);
        WXorderModel *model = [WXorderModel mj_objectWithKeyValues:dic];
        if ([WXPayService isWXAppInstalled]) {
            WXPayReq * req = [[WXPayReq alloc]init];
            req.partnerid = model.partnerid;
            req.prepayid = model.prepayid;
            req.noncestr = model.noncestr;
            req.timestamp = model.timestamp;
            req.packageValue = model.packageStr;
            req.sign = model.sign;
            NSLog(@"%@",req.mj_keyValues);
            [[WXPayService defaultService]payOrderWithInfo:req comletionBlock:^(NSString *result) {
                [self dealWithPayResult:result];
            }];
        }
    }
    
    if (api == _priceCApi) {
        self.summodel = [SumModel mj_objectWithKeyValues:responsObject];
        self.priceLabel.text = [NSString stringWithFormat:@"合计: ￥%.1f",self.summodel.sumprice];
        self.price = [NSString stringWithFormat:@"%.1f",self.summodel.price];
        self.conponprice = [NSString stringWithFormat:@"%.1f",self.summodel.couponprice];
        self.sumprice = [NSString stringWithFormat:@"%.1f",self.summodel.sumprice];
    }
    
}

#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
//姓名
- (SelectTypeTableViewCell *)userName {
    if (!_userName) {
        _userName = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userName.textField.clearButtonMode = UITextFieldViewModeAlways;
        _userName.text = [User LocalUser].name;
        _userPhone.selectionStyle = UITableViewCellSelectionStyleNone;
        [_userName setTypeName:@"姓        名" placeholder:@"请输入姓名"];
    }
    return _userName;
}

//手机号码
- (SelectTypeTableViewCell *)userPhone {
    if (!_userPhone) {
        _userPhone = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_userPhone setTypeName:@"手机号码" placeholder:@"请输入手机号码"];
        _userPhone.textField.clearButtonMode = UITextFieldViewModeAlways;
        _userPhone.text = [User LocalUser].phone;
        _userPhone.selectionStyle = UITableViewCellSelectionStyleNone;
        _userPhone.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _userPhone;
}

- (AddressTableViewCell *)userDetailAddress {
    if (!_userDetailAddress) {
        _userDetailAddress = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _userDetailAddress.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_userDetailAddress setTypeName:@"地        址" placeholder:@"请输入体检人地址信息"];
        _userDetailAddress.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _userDetailAddress;
}

- (SelectTypeTableViewCell *)UserAddress {
    if (!_UserAddress) {
        _UserAddress = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _UserAddress.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _UserAddress.selectionStyle = UITableViewCellSelectionStyleNone;
        [_UserAddress setTypeName:@"支持城市" placeholder:@"请选择城市"];
        [_UserAddress setEditAble:NO];
    }
    return _UserAddress;
}

- (SelectTypeTableViewCell *)conpon {
    if (!_conpon) {
        _conpon = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _conpon.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _conpon.selectionStyle = UITableViewCellSelectionStyleNone;
        [_conpon setTypeName:@"优惠券" placeholder:@""];
        _conpon.textField.textAlignment = NSTextAlignmentRight;
        _conpon.textField.textColor = AppStyleColor;
        [_conpon setEditAble:NO];
    }
    return _conpon;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [UIFont systemFontOfSize:16 weight:2];
        _priceLabel.backgroundColor = [UIColor whiteColor];
        _priceLabel.textColor = AppStyleColor;
    }
    return _priceLabel;
}

- (UILabel *)bgpriceLabel{
    if (!_bgpriceLabel) {
        _bgpriceLabel = [[UILabel alloc]init];
        _bgpriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _bgpriceLabel;
}

- (UIButton *)commitOrder
{
    if (!_commitOrder) {
        _commitOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitOrder setTitle:@"订单提交" forState:UIControlStateNormal];
        [_commitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitOrder.backgroundColor = AppStyleColor;
        _commitOrder.titleLabel.font = Font(20);
    }
    return _commitOrder;
}

- (void)layoutsubview{
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.centerY.mas_equalTo(self.bgpriceLabel.mas_centerY);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(0);
    }];
    [self.bgpriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/3 *2);
        make.height.mas_equalTo(50);
    }];
    
    [self.commitOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.bgpriceLabel.mas_right);
        make.height.mas_equalTo(self.bgpriceLabel.mas_height);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    TJpriceHeader *head = [[TJpriceHeader alloc]init];
    head.target = @"noTokenOrderControl";
    head.method = @"getTijian";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    TJpriceBody *body = [[TJpriceBody alloc]init];
    body.id = self.id;
    body.zilist = self.zilist;
    GetTJPriceAndNameRequest *request = [[GetTJPriceAndNameRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.priceApi getPrice:request.mj_keyValues.mutableCopy];
    self.title = @"填写体检订单";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.tableView registerClass:[TJDistriTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TJDistriTableViewCell class])];
    [self.tableView registerClass:[PriceSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PriceSelectTableViewCell class])];
    [self.tableView registerClass:[PriceSelectNoPriceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PriceSelectNoPriceTableViewCell class])];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bgpriceLabel];
    [self.bgpriceLabel addSubview:self.priceLabel];
    [self.view addSubview:self.commitOrder];
    [self.commitOrder addTarget:self action:@selector(toCommit) forControlEvents:UIControlEventTouchUpInside];
    [self layoutsubview];
    self.sectionDataArray = @[self.pakageType];
    self.dataArray = @[self.userName,self.userPhone,self.userDetailAddress,self.UserAddress];
    self.conponArray = @[self.conpon];
    cityHeader *cityhead = [[cityHeader alloc]init];
    cityhead.target = @"noTokenOrderControl";
    cityhead.method = @"getTijianCitys";
    cityhead.versioncode = Versioncode;
    cityhead.devicenum = Devicenum;
    cityhead.fromtype = Fromtype;
    cityhead.token = [User LocalUser].token;
    cityBody *citybody = [[cityBody alloc]init];
    citybody.id = self.id;
    GetOrderCityListRequest *cityrequest = [[GetOrderCityListRequest alloc]init];
    cityrequest.head = cityhead;
    cityrequest.body = citybody;
    [self.cityApi getCityList:cityrequest.mj_keyValues.mutableCopy];
    //选择支付方式
    _customShareView = [[CustomShareView alloc]init];
    [self.view addSubview:_customShareView];
    _customShareView.delegate  =self;
    self.count = 1;
    weakify(self);
    self.userDetailAddress.location = ^{
        strongify(self);
        [self start_locationManager];
    };
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
//            self.addressString = cityArr[0];
            self.userDetailAddress.textField.text = address;
            [self stop_LocationManager];
            //  self.userDetailAddress.text = cityArr[0];
        }
    }];
}

- (void)stop_LocationManager{
    [_locationManager stopUpdatingLocation];//关闭定位
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (section == 0 || section == 2) {
            return 10;
        }else{
            if ([self.model.fuwufei isEqualToString:@"1"]) {
                return 40;
            }else{
                return 10;
            }
        }
    } else {
        if (section == 0 || section == 2) {
            return 10;
        }else{
            if ([self.model.fuwufei isEqualToString:@"1"]) {
                return 40;
            }else{
                return 10;
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else if (section == 1){
        if ([self.model.fuwufei isEqualToString:@"1"]) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
            contentView.backgroundColor = RGBA(255, 252, 221, 1);
            [footerView addSubview:contentView];
            UIImageView *tipImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 7.5, 15, 15)];
            tipImage.image = [UIImage imageNamed:@"tj_tip"];
            [contentView addSubview:tipImage];
            UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipImage.frame)+10, 0, kScreenWidth - 20, 30)];
            tipLabel.textColor = DefaultBlackLightTextClor;
            tipLabel.textAlignment = NSTextAlignmentLeft;
            tipLabel.font = FontNameAndSize(13);
            tipLabel.text = @"10人以上免上门费用";
            [contentView addSubview:tipLabel];
            return footerView;
        }else{
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
            footerView.backgroundColor = [UIColor clearColor];
            return footerView;
        }
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else if(section == 3){
            return 52;
        }
        else{
            return 0.000001;
        }
    } else {
        if (section == 0) {
            return 0.000001;
        }else if(section == 3){
            return 52;
        }
        else{
            return 0.000001;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else if (section == 1){
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else if (section == 3){
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
        desLTitle.text = @"购买信息";
        return content;
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return self.conponArray.count;
    }
    else{
        return self.dataArray.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 1){
        if ([self.model.fuwufei isEqualToString:@"1"]) {
            return 111;
        }else{
            return 80;
        }
    }else{
        return 52;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
            TJDistriTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TJDistriTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithModel:self.model];
        return cell;
    }else if (indexPath.section == 1){
        if ([self.model.fuwufei isEqualToString:@"1"]) {
            PriceSelectTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PriceSelectTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        self.model.count = 1;
            [cell refreshWithModel:self.model];
            weakify(cell);
            cell.amout = ^(NSInteger num, BOOL increaseStatus) {
                strongify(cell);
                self.count = (int)num;
                NSLog(@"%ld, %d",num,increaseStatus);
                priceHeader *pricehead = [[priceHeader alloc]init];
                pricehead.target = @"noTokenOrderControl";
                pricehead.method = @"sumPrice";
                pricehead.versioncode = Versioncode;
                pricehead.devicenum = Devicenum;
                pricehead.fromtype = Fromtype;
                priceBody *pricebody = [[priceBody alloc]init];
                pricebody.id = self.id;
                pricebody.fuwufei = self.model.fuwufei;
                pricebody.count = (int)num;
                pricebody.coupondetailid = self.conponid;
                PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
                pricerequest.head = pricehead;
                pricerequest.body = pricebody;
                [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
                self.model.count = (int)num;
                [cell refreshWithModel:self.model];
                
            };
            return cell;
        }else{
            PriceSelectNoPriceTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PriceSelectNoPriceTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        self.model.count = 1;
            [cell refreshWithModel:self.model];
            weakify(cell);
            cell.amout = ^(NSInteger num, BOOL increaseStatus) {
                strongify(cell);
                self.count = (int)num;
                NSLog(@"%ld, %d",num,increaseStatus);
                
                priceHeader *pricehead = [[priceHeader alloc]init];
                pricehead.target = @"noTokenOrderControl";
                pricehead.method = @"sumPrice";
                pricehead.versioncode = Versioncode;
                pricehead.devicenum = Devicenum;
                pricehead.fromtype = Fromtype;
                priceBody *pricebody = [[priceBody alloc]init];
                pricebody.id = self.id;
                pricebody.fuwufei = self.model.fuwufei;
                pricebody.count = (int)num;
                pricebody.coupondetailid = self.conponid;
                PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
                pricerequest.head = pricehead;
                pricerequest.body = pricebody;
                [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
                self.model.count = (int)num;
                [cell refreshWithModel:self.model];
                
            };
            return cell;
        }
      
    }else if(indexPath.section == 2){
        return [self.conponArray safeObjectAtIndex:indexPath.row];
    }else{
        return [self.dataArray safeObjectAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    weakify(self);
    if (indexPath.section == 2 ) {
        if (self.myconponArray.count <= 0) {
            [Utils postMessage:@"无优惠券可用" onView:self.view];
        }else{
            OrderConponListViewController *conpon = [OrderConponListViewController new];
            conpon.cid = self.conponid;
            conpon.id = self.id;
            conpon.type = @"2";
            conpon.zilist = self.zilist;
            conpon.conpon = ^(MyconponListModel *model) {
                self.isOption = YES;
                self.conponid = model.id;
                self.conpon.text = [NSString stringWithFormat:@"-￥%@",model.denominat];
                priceHeader *pricehead = [[priceHeader alloc]init];
                pricehead.target = @"noTokenOrderControl";
                pricehead.method = @"sumPrice";
                pricehead.versioncode = Versioncode;
                pricehead.devicenum = Devicenum;
                pricehead.fromtype = Fromtype;
                priceBody *pricebody = [[priceBody alloc]init];
                pricebody.id = self.id;
                pricebody.fuwufei = self.model.fuwufei;
                pricebody.coupondetailid = self.conponid;
                pricebody.count = self.count;
                PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
                pricerequest.head = pricehead;
                pricerequest.body = pricebody;
                [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
            };
            conpon.noconpon = ^{
                self.isOption = YES;
                self.conpon.text = @"不使用优惠券";
                self.conponid = @"";
                priceHeader *pricehead = [[priceHeader alloc]init];
                pricehead.target = @"noTokenOrderControl";
                pricehead.method = @"sumPrice";
                pricehead.versioncode = Versioncode;
                pricehead.devicenum = Devicenum;
                pricehead.fromtype = Fromtype;
                priceBody *pricebody = [[priceBody alloc]init];
                pricebody.id = self.id;
                pricebody.fuwufei = self.model.fuwufei;
                pricebody.coupondetailid = self.conponid;
                pricebody.count = self.count;
                PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
                pricerequest.head = pricehead;
                pricerequest.body = pricebody;
                [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
            };
            [self.navigationController pushViewController:conpon animated:YES];
        }
       
    }else if (indexPath.section == 3 &&indexPath.row == 3) {//选择地区

       //选择城市
        self.selectAddress = [[HClActionSheet alloc] initWithTitle:@"请选择城市" style:HClSheetStyleWeiChat itemTitles:self.cityList];
        self.selectAddress.delegate = self;
        self.selectAddress.tag = 60;
        self.selectAddress.titleTextColor = DefaultBlackLightTextClor;
        self.selectAddress.titleTextFont = Font(16);
        self.selectAddress.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectAddress.itemTextColor = DefaultGrayTextClor;
        self.selectAddress.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectAddress.cancleTextColor = DefaultGrayTextClor;
        [self.selectAddress didFinishSelectIndex:^(NSInteger index, NSString *title) {
            strongify(self);
            CityModel *city = [self.citysArr objectAtIndex:index];
            self.cityid  = city.id;
            self.UserAddress.text = title;
        }];

    }
    
}


-(void)toast:(NSString *)title
{
    [Utils showErrorMsg:self.view type:0 msg:title];
}

- (void)toCommit{
        if (self.userName.text.length == 0) {
            [Utils postMessage:@"请输入体检人姓名" onView:self.view];
            return;
        }
        if (self.userPhone.text.length == 0) {
            [Utils postMessage:@"请输入要接收预订信息的手机号码" onView:self.view];
            return;
        }
    
        NSError *error;
        if (![ValidatorUtil isValidMobile:self.userPhone.text error:&error]) {
            [self toast:@"请输入正确的手机号"];
            return;
        }
    
        NSString *address = self.userDetailAddress.textField.text;
        if (address.length == 0) {
            [Utils postMessage:@"请输入便于接收体验报告的详细地址" onView:self.view];
            return;
        }
    
        if (self.cityid.length == 0) {
            [Utils postMessage:@"请选择体检所支持的城市" onView:self.view];
            return;
        }
  
    
    if (self.orderid) {
        [Utils addHudOnView:self.view];
        deleteHeader *deleheader = [[deleteHeader alloc]init];
        deleheader.target = @"ownControl";
        deleheader.method = @"orderDelete";
        deleheader.versioncode = Versioncode;
        deleheader.devicenum = Devicenum;
        deleheader.fromtype = Fromtype;
        deleheader.token = [User LocalUser].token;
        deleteBody *deletebody = [[deleteBody alloc]init];
        deletebody.id = self.orderid;
        DeleteOrderRequest *deleterequest = [[DeleteOrderRequest alloc]init];
        deleterequest.head = deleheader;
        deleterequest.body = deletebody;
        [self.deleteApi deleteOrderWithId:deleterequest.mj_keyValues.mutableCopy];
    }else{
        [Utils addHudOnView:self.view];
        tjorderCommitHeader *commithead = [[tjorderCommitHeader alloc]init];

        commithead.target = @"orderControl";

        commithead.method = @"createOrder";

        commithead.versioncode = Versioncode;

        commithead.devicenum = Devicenum;

        commithead.fromtype = Fromtype;

        commithead.token = [User LocalUser].token;

        tjorderCommitBody *commitOrderbody = [[tjorderCommitBody alloc]init];

        commitOrderbody.taocanid = self.id;

        commitOrderbody.cityid = self.cityid;

        commitOrderbody.patientname  = self.userName.text;

        commitOrderbody.patientphone = self.userPhone.text;

        commitOrderbody.patientaddress = self.userDetailAddress.textField.text;
        commitOrderbody.type = @"2";
        commitOrderbody.zilist = self.zilist;
        commitOrderbody.count = self.count;
        commitOrderbody.price = self.price;
        commitOrderbody.couponprice = self.conponprice;
        commitOrderbody.sumprice = [self.sumprice doubleValue];
        commitOrderbody.coupondetailid = self.conponid;
        TJorderCommitRequest *cityrequest = [[TJorderCommitRequest alloc]init];
        cityrequest.head = commithead;
        cityrequest.body = commitOrderbody;
        [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];
    }
  
    
}


- (void)selectPayModel:(NSInteger)index
{
    
    NSLog(@"%ld",index);

    if (index == 1) {
        if (![WXPayService isWXAppInstalled]) {
            [Utils postMessage:@"设备未安装微信客户端" onView:self.view];
            return;
        }
        [Utils addHudOnView:self.view];
        WXRequestHeader *head = [[WXRequestHeader alloc]init];
        head.target = @"generalControl";
        head.method = @"createWeChatOrder";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        WXRequestBody *body = [[WXRequestBody alloc]init];
        body.orderid = self.orderModel.orderid;
        body.zilist = self.zilist;
        CreatWXOrderRequest *request = [[CreatWXOrderRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.wxOrder getWXOrder:request.mj_keyValues.mutableCopy];
        
    }else if (index == 2){
       
        if (![AlipayService isAlipayAppInstalled]) {
            [Utils postMessage:@"设备未安装支付宝客户端" onView:self.view];
            return;
        }
        [Utils addHudOnView:self.view];
        //支付宝支付
        AliRequestHeader *head = [[AliRequestHeader alloc]init];
        head.target = @"generalControl";
        head.method = @"createAlipayOrder";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        AliRequestBody *body = [[AliRequestBody alloc]init];
        body.orderid = self.orderModel.orderid;
        body.zilist = self.zilist;
        AlipayRequest *request = [[AlipayRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.alipay getAliOrder:request.mj_keyValues.mutableCopy];
    }
}

- (void)findConponWithPid:(NSString *)pid{
    MyconponListHeader *myconponHead = [[MyconponListHeader alloc]init];
    myconponHead.target = @"couponControl";
    myconponHead.method = @"myOrderCouponList";
    myconponHead.versioncode = Versioncode;
    myconponHead.devicenum = Devicenum;
    myconponHead.fromtype = Fromtype;
    myconponHead.token = [User LocalUser].token;
    MyconponListBody *myconponBody = [[MyconponListBody alloc]init];
    myconponBody.id = pid;
    myconponBody.type = @"2";
    myconponBody.zilist = self.zilist;
    MyconponListRequest *myconponRequest = [[MyconponListRequest alloc]init];
    myconponRequest.head = myconponHead;
    
    myconponRequest.body = myconponBody;
    [self.myconponApi getorderConponList:myconponRequest.mj_keyValues.mutableCopy];
}

@end
