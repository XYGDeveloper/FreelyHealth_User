//
//  OrderFillViewController.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderFillViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "HClActionSheet.h"
#import "TunorDetail.h"
#import "PackageRequest.h"
#import "PackageModel.h"
#import "PackageApi.h"
#import "CityListApi.h"
#import "GetOrderCityListRequest.h"
#import "CityModel.h"
#import "DeleteOrderRequest.h"
#import "OrderCommitApi.h"
#import "OrderCommitRequest.h"
#import "PackageModel.h"
#import "AliModel.h"
#import "AlipayRequest.h"
#import "AlipayApi.h"
#import "AlipayService.h"
#import "CommitOrderModel.h"
#import "PayScuessViewController.h"
#import "OrderDetailModel.h"
#import "CustomShareView.h"
#import "WXCreatOrderApi.h"
#import "CreatWXOrderRequest.h"
#import "WXPayService.h"
#import "WXPayReq.h"
#import "WXorderModel.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"
#import "deleteApi.h"
#import "AddressTableViewCell.h"
#import "Location_Manager.h"
#import "OrderConponListViewController.h"
#import "PayModeViewController.h"
//
#import "OrderConponListApi.h"
#import "MyconponListRequest.h"
#import "MyconponListModel.h"
//
#import "priceCounterApi.h"
#import "PriceCounterRequest.h"
//
#import "SumModel.h"
#import "OrderModel.h"
@interface OrderFillViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,ApiRequestDelegate,selectPayModelDelegate,CLLocationManagerDelegate>
{
    CustomShareView *_customShareView;
}

@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong)SelectTypeTableViewCell *type;

@property (nonatomic,strong)SelectTypeTableViewCell *name;

@property (nonatomic,strong)SelectTypeTableViewCell *sex;

@property (nonatomic,strong)SelectTypeTableViewCell *age;

@property (nonatomic,strong)SelectTypeTableViewCell *phone;

@property (nonatomic,strong)SelectTypeTableViewCell *address;

@property (nonatomic,strong)SelectTypeTableViewCell *conpon;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray *sectionDataArray;

@property (nonatomic, strong) NSArray *conponArray;

//
@property (nonatomic,strong)UIImageView *imageurl;

@property (nonatomic,strong)UILabel *titleName;

@property (nonatomic,strong)UILabel *desLTitle;

@property (nonatomic,strong)UILabel *priceLabel;

@property (nonatomic,strong)UILabel *bgpriceLabel;

@property (nonatomic,strong)UIButton *commitOrder;

//选择控件区

@property (nonatomic,strong)HClActionSheet *selectType;

@property (nonatomic,strong)HClActionSheet *selectSex;

@property (nonatomic,strong)HClActionSheet *selectAddress;

@property (nonatomic,strong)PackageApi *packageApi;

@property (nonatomic,strong)NSMutableArray *packageList;

@property (nonatomic,strong)CityListApi *cityApi;

@property (nonatomic,strong)NSMutableArray *cityList;
@property (nonatomic,strong)WXCreatOrderApi *wxOrder;
@property (nonatomic,strong)AlipayApi *alipay;
@property (nonatomic,strong)OrderCommitApi *ordercommitApi;
@property (nonatomic,strong)deleteApi *deleteApi;

//订单相关参数

@property (nonatomic,strong)NSString *planid;

@property (nonatomic,strong)NSString *cityid;

@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)NSMutableArray *citysArr;

@property (nonatomic,strong)CommitOrderModel *orderModel;
//
@property (nonatomic,strong)HClActionSheet *selectPay;

@property (nonatomic,strong)NSString *UserName;

@property (nonatomic,strong)NSString *telephoneNumber;

@property (nonatomic,strong)NSString *orderid;

@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,assign)float latitude;
@property (nonatomic,assign)float longitude;
@property(nonatomic,strong)Location_Manager *location;
//
@property (nonatomic,strong)OrderConponListApi *myconponApi;
@property (nonatomic,strong)NSMutableArray *myconponArray;
//
@property (nonatomic,strong)priceCounterApi *priceCApi;
@property (nonatomic,strong)SumModel *sumModel;
//
@property (nonatomic,strong)NSString *conponid; //优惠券id
@property (nonatomic,strong)NSString *conponPrice; //优惠券价格
@property (nonatomic,strong)NSString *price; //不含优惠券价格
@property (nonatomic,strong)NSString *sumprice;//总价
//
@property (nonatomic,strong)MyconponListModel *componModel;//选择的优惠券

@property (nonatomic,assign)BOOL isOption;//选择的优惠券

@end

@implementation OrderFillViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isOption = NO;
}

- (NSMutableArray *)listArr
{
    if (!_listArr) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (NSMutableArray *)citysArr
{
    if (!_citysArr) {
        _citysArr = [NSMutableArray array];
    }
    return _citysArr;
}


- (PackageApi *)packageApi
{
    if (!_packageApi) {
        _packageApi = [[PackageApi alloc]init];
        _packageApi.delegate  =self;
    }
    return _packageApi;
}

- (deleteApi *)deleteApi
{
    if (!_deleteApi) {
        _deleteApi = [[deleteApi alloc]init];
        _deleteApi.delegate  =self;
    }
    return _deleteApi;
}

- (CityListApi *)cityApi
{
    if (!_cityApi) {
        _cityApi = [[CityListApi alloc]init];
        _cityApi.delegate  =self;
    }
    return _cityApi;
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



- (NSMutableArray *)packageList
{
    if (!_packageList) {
        _packageList = [NSMutableArray array];
    }
    return _packageList;
}


- (NSMutableArray *)cityList
{
    if (!_cityList) {
        _cityList = [NSMutableArray array];
    }
    return _cityList;
}

-(OrderConponListApi *)myconponApi{
    if (!_myconponApi) {
        _myconponApi = [[OrderConponListApi alloc]init];
        _myconponApi.delegate  = self;
    }
    return _myconponApi;
}

- (priceCounterApi *)priceCApi
{
    if (!_priceCApi) {
        _priceCApi = [[priceCounterApi alloc]init];
        _priceCApi.delegate  =self;
    }
    return _priceCApi;
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

- (UILabel *)bgpriceLabel{
    if (!_bgpriceLabel) {
        _bgpriceLabel = [[UILabel alloc]init];
        _bgpriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _bgpriceLabel;
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

- (UIButton *)commitOrder
{

    if (!_commitOrder) {
        
        _commitOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_commitOrder setTitle:@"提交订单" forState:UIControlStateNormal];
        
        [_commitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitOrder.backgroundColor = AppStyleColor;
        
        _commitOrder.titleLabel.font = Font(20);
        
    }
    
  return _commitOrder;
    

}

- (void)layoutsubview{

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
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
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bgpriceLabel];
    [self.bgpriceLabel addSubview:self.priceLabel];
    
    [self.view addSubview:self.commitOrder];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    [self.commitOrder addTarget:self action:@selector(orderCommitAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutsubview];
    
    self.sectionDataArray = @[self.type];
    self.dataArray = @[self.name, self.sex, self.age,self.phone,self.address];
    self.conponArray = @[self.conpon];
    [self.tableView reloadData];
    
        pakageHeader *head = [[pakageHeader alloc]init];
        
        head.target = @"noTokenOrderControl";
        
        head.method = @"getPlansList";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        pakageBody *body = [[pakageBody alloc]init];
        
        body.goodsid = self.model.goodsid;
    
        PackageRequest *request = [[PackageRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
    
       [self.packageApi packagelList:request.mj_keyValues.mutableCopy];
    
    cityHeader *cityhead = [[cityHeader alloc]init];
    
    cityhead.target = @"noTokenOrderControl";
    
    cityhead.method = @"getCityList";
    
    cityhead.versioncode = Versioncode;
    
    cityhead.devicenum = Devicenum;
    
    cityhead.fromtype = Fromtype;
    
    cityhead.token = [User LocalUser].token;
    
    cityBody *citybody = [[cityBody alloc]init];
    
    GetOrderCityListRequest *cityrequest = [[GetOrderCityListRequest alloc]init];
    
    cityrequest.head = cityhead;
    
    cityrequest.body = citybody;
    
    NSLog(@"%@",request);
    
    [self.cityApi getCityList:cityrequest.mj_keyValues.mutableCopy];

    if (self.revireOrder == YES) {
        
        cityHeader *cityhead = [[cityHeader alloc]init];
        
        cityhead.target = @"noTokenOrderControl";
        
        cityhead.method = @"getCityList";
        
        cityhead.versioncode = Versioncode;
        
        cityhead.devicenum = Devicenum;
        
        cityhead.fromtype = Fromtype;
        
        cityhead.token = [User LocalUser].token;
        
        cityBody *citybody = [[cityBody alloc]init];
        
        GetOrderCityListRequest *cityrequest = [[GetOrderCityListRequest alloc]init];
        
        cityrequest.head = cityhead;
        
        cityrequest.body = citybody;
        
        NSLog(@"%@",request);
        
        [self.cityApi getCityList:cityrequest.mj_keyValues.mutableCopy];

        self.titleName.text = self.orderDetailModel.name;
        
        self.name.text = self.orderDetailModel.patientname;
        
        self.sex.text = self.orderDetailModel.patientsex;

        self.age.text = self.orderDetailModel.patientage;

        self.phone.text = self.orderDetailModel.patientphone;

        self.address.text = self.orderDetailModel.cityname;
        
        self.priceLabel.text  = self.orderDetailModel.payment;
        
        self.planid = @"1";
        
    }
    
    //选择支付方式
    
    _customShareView = [[CustomShareView alloc]init];
    
    [self.view addSubview:_customShareView];
    
    _customShareView.delegate  =self;

}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils removeAllHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    if (api == _deleteApi) {
        [Utils addHudOnView:self.view];
        orderCommitHeader *commithead = [[orderCommitHeader alloc]init];
        commithead.target = @"orderControl";
        commithead.method = @"createOrder";
        commithead.versioncode = Versioncode;
        commithead.devicenum = Devicenum;
        commithead.fromtype = Fromtype;
        commithead.token = [User LocalUser].token;
        orderCommitBody *commitOrderbody = [[orderCommitBody alloc]init];
        commitOrderbody.planid = self.planid;
        commitOrderbody.cityid = self.cityid;
        commitOrderbody.patientname  = self.name.text;
        commitOrderbody.patientsex  = self.sex.text;
        commitOrderbody.patientage = self.age.text;
        
        commitOrderbody.patientphone = self.phone.text;
        
        commitOrderbody.hopedid = self.holpId;
        commitOrderbody.type = @"1";
        commitOrderbody.zilist = @"0";
        commitOrderbody.sumprice = self.sumprice;
        commitOrderbody.price = self.price;
        commitOrderbody.couponprice = self.conponPrice;
        commitOrderbody.coupondetailid = self.conponid;
        OrderCommitRequest *cityrequest = [[OrderCommitRequest alloc]init];
        
        cityrequest.head = commithead;
        
        cityrequest.body = commitOrderbody;
        
        [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];
        
    }
    
    if (api == _packageApi) {
        NSLog(@"%@",responsObject);
        self.listArr = responsObject;
        PackageModel *pack = [self.listArr objectAtIndex:0];
        self.type.text = [NSString stringWithFormat:@"%@ ¥%.0f",pack.name,pack.pays];
        NSLog(@"%ld",(long)index);
        self.priceLabel.text  = [NSString stringWithFormat:@"合计：¥%.0f",pack.pays];
        //
        self.price = [NSString stringWithFormat:@"%.0f",pack.pays];
        self.sumprice = [NSString stringWithFormat:@"%.0f",pack.pays];
        self.planid = pack.id;
        [self findConponWithPid:pack.id];
        [self counterPriceWithPid:pack.id coupondetailid:@""];
        self.sex.text = @"男";
        for (PackageModel *model in responsObject) {
            NSString *price = [NSString stringWithFormat:@"%@  ￥%.0f",model.name,model.pays];
            [self.packageList addObject:price];
            
       }
    
          [self.tableView reloadData];
    
    }
    
    if (api == _cityApi) {
        
        NSLog(@"%@",responsObject);

        self.citysArr = responsObject;
        
        for (CityModel *model in responsObject) {
            
            [self.cityList addObject:model.name];
            
            if ([self.orderDetailModel.cityname isEqualToString:model.name]) {
                
                self.cityid = model.id;
                
            }
            

    }
        
        [self.tableView reloadData];

    }
    
    if (api == _ordercommitApi) {
        [Utils removeAllHudFromView:self.view];
        self.orderModel = responsObject;
        [_customShareView showInView:self.view];
    }
    
    if (api==_myconponApi) {
        self.myconponArray = [NSMutableArray array];
        [self.myconponArray removeAllObjects];
         self.myconponArray = responsObject;
        if (self.myconponArray.count<=0) {
            self.conpon.text = @"无优惠券可用";
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
    
    if (api == _priceCApi) {
        
        self.sumModel = [SumModel mj_objectWithKeyValues:responsObject];
        //                self.pakageType.text = [NSString stringWithFormat:@"%@ ￥%@",model.name,model.price];
        self.priceLabel.text = [NSString stringWithFormat:@"合计: ￥%.1f",self.sumModel.sumprice];
        self.sumprice = [NSString stringWithFormat:@"%.1f",self.sumModel.sumprice];
        self.price = [NSString stringWithFormat:@"%.1f",self.sumModel.price];
        self.conponPrice = [NSString stringWithFormat:@"%.1f",self.sumModel.couponprice];
    }
    
    if (api == _alipay) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([AlipayService isAlipayAppInstalled]) {
            
            AliModel *model = responsObject;
            
            [[AlipayService defaultService]payOrderWithInfo:model.info withCompletionBlock:^(NSString *result) {
                
                [self dealWithPayResult:result];
                
            }];
            
        }
        
    }
    
    
    if (api == _wxOrder) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

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
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kOrderPaySuccessNotify object:nil];
        
        PayScuessViewController *scuess = [PayScuessViewController new];
        
        self.titleName.text = self.model.name;
        
        self.desLTitle.text = @"请提前和客服联系，以便及时安排服务";
        
        scuess.service = self.model.name;
        
        scuess.name = self.name.text;
        
        NSRange range = {3,4};
        
        scuess.phone = [self.phone.text stringByReplacingCharactersInRange:range withString:@"****"];
        
        scuess.title = @"支付成功";
    
        [self.navigationController pushViewController:scuess animated:YES];
        
    }
    
}



- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (SelectTypeTableViewCell *)type {
    if (!_type) {
        _type = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _type.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_type setTypeName:@"套餐" placeholder:@"请选择套餐"];
        [_type setEditAble:NO];
        _type.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return _type;
}

- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"姓名" placeholder:@"请输入姓名"];
        _name.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return _name;
}

- (SelectTypeTableViewCell *)sex {
    if (!_sex) {
        _sex = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _sex.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_sex setTypeName:@"性别" placeholder:@"请选择性别"];
        [_sex setEditAble:NO];
        _sex.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return _sex;
}

- (SelectTypeTableViewCell *)age {
    if (!_age) {
        _age = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_age setTypeName:@"年龄" placeholder:@"请输入年龄"];
        _age.textField.keyboardType = UIKeyboardTypeNumberPad;
        _age.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return _age;
    
}

- (SelectTypeTableViewCell *)phone {
    if (!_phone) {
        _phone = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_phone setTypeName:@"手机号" placeholder:@"请输入手机号"];
        _phone.textField.keyboardType = UIKeyboardTypeNumberPad;
        _phone.selectionStyle=UITableViewCellSelectionStyleNone;

    }
    return _phone;
}

- (SelectTypeTableViewCell *)address {
    if (!_address) {
        _address = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _address.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [_address setEditAble:NO];
        _address.selectionStyle=UITableViewCellSelectionStyleNone;
        [_address setTypeName:@"地址" placeholder:@"请选择地址"];
    }
    return _address;
}

- (SelectTypeTableViewCell *)conpon {
    if (!_conpon) {
        _conpon = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _conpon.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_conpon setEditAble:NO];
        _conpon.selectionStyle=UITableViewCellSelectionStyleNone;
        [_conpon setTypeName:@"优惠券" placeholder:@""];
        _conpon.textField.textColor = AppStyleColor;
        _conpon.textField.textAlignment = NSTextAlignmentRight;
    }
    return _conpon;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 100;
    }else if(section == 2){
        return 52;
    }else{
        return 0.0001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        content.backgroundColor = [UIColor whiteColor];
        self.imageurl = [UIImageView new];
        self.imageurl.layer.cornerRadius = 8;
        self.imageurl.layer.masksToBounds = YES;
        
        [content addSubview:self.imageurl];
        
        [self.imageurl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(content.mas_centerY);
            make.width.height.mas_equalTo(60);
        }];
        
        self.titleName = [UILabel new];
        
        self.titleName.textAlignment = NSTextAlignmentLeft;
        
        self.titleName.font = [UIFont systemFontOfSize:16 weight:2];
        
        self.titleName.textColor = DefaultBlackLightTextClor;
        
        [content addSubview:self.titleName];
        
        [self.titleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageurl.mas_top);
            make.left.mas_equalTo(self.imageurl.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(25);
        }];
        
        self.desLTitle = [UILabel new];
        
        self.desLTitle.textAlignment = NSTextAlignmentLeft;
        
        self.desLTitle.font = Font(16);
        
        self.desLTitle.textColor = DefaultGrayTextClor;
        
        [content addSubview:self.desLTitle];
        
        [self.desLTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleName.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(self.imageurl.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(25);
        }];
        
        [self.imageurl sd_setImageWithURL:[NSURL URLWithString:self.model.imagepatho] placeholderImage:[UIImage imageNamed:@""]];
        
        self.titleName.text = self.model.name;

        self.desLTitle.text = @"请提前和客服联系，以便及时安排服务";

        if (self.revireOrder == YES) {

            self.titleName.text = self.orderDetailModel.name;
            
        }
        return content;
        
    }else if(section == 2){
    
        UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        content.backgroundColor = [UIColor whiteColor];
        
        self.desLTitle = [UILabel new];
        
        self.desLTitle.textAlignment = NSTextAlignmentLeft;
        
        self.desLTitle.font = Font(16);
        
        self.desLTitle.textColor = DefaultGrayTextClor;
        
        [content addSubview:self.desLTitle];
        
        [self.desLTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(content.mas_centerY);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
         self.desLTitle.text = @"联系人信息";
        return content;
    
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if(section == 2){
        return 5;
    }else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self.sectionDataArray safeObjectAtIndex:indexPath.row];

    }else if(indexPath.section == 2){
        return [self.dataArray safeObjectAtIndex:indexPath.row];
    }else{
        return [self.conponArray safeObjectAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    weakify(self);
    if (indexPath.section == 0 && indexPath.row == 0) {//选择套餐
        self.selectType = [[HClActionSheet alloc] initWithTitle:@"请选择套餐" style:HClSheetStyleWeiChat itemTitles:self.packageList];
        
        self.selectType.delegate = self;
        self.selectType.tag = 50;
        self.selectType.titleTextColor = DefaultBlackLightTextClor;
        self.selectType.titleTextFont = Font(16);
        self.selectType.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectType.itemTextColor = DefaultGrayTextClor;
        self.selectType.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectType.cancleTextColor = DefaultGrayTextClor;
   
        [self.selectType didFinishSelectIndex:^(NSInteger index, NSString *title) {
             strongify(self);
            self.type.text = title;
             NSLog(@"%ld",(long)index);
             PackageModel *pack = [self.listArr objectAtIndex:index];
             self.priceLabel.text  = [NSString stringWithFormat:@"合计：¥%.0f",pack.pays];
             self.planid = pack.id;
             self.conponid = @"";
             self.price = @"";
             self.sumprice = @"";
             self.conponPrice = @"";
            [self counterPriceWithPid:pack.id coupondetailid:@""];
            [self findConponWithPid:pack.id];
         }];
     } else if (indexPath.section == 2 &&indexPath.row == 1) {//选择地区

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
            self.sex.text = title;
        }];

        
    }else if (indexPath.section == 2 &&indexPath.row == 4) {//选择地区

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
            
            self.address.text = title;

        }];
        
    }else if (indexPath.section == 1){
        if (self.myconponArray.count<=0) {
            [Utils postMessage:@"无可用优惠券" onView:self.view];
        }else{
            self.isOption = YES;
            OrderConponListViewController *conpon = [OrderConponListViewController new];
            conpon.cid = self.conponid;
            conpon.title = @"优惠券";
            conpon.id = self.planid;
            conpon.zilist  = @"0";
            conpon.type = @"1";
            conpon.conpon = ^(MyconponListModel *model) {
                self.conponid = model.id;
                self.conponPrice = model.denominat;
                self.conpon.text = [NSString stringWithFormat:@"-￥%@",model.denominat];
                [self counterPriceWithPid:self.planid coupondetailid:model.id];
            };
            
            conpon.noconpon = ^{
                self.conpon.text = @"不使用优惠券";
            };
            [self.navigationController pushViewController:conpon animated:YES];
        }
      
    }
}

-(void)toast:(NSString *)title
{
   
    [Utils showErrorMsg:self.view type:0 msg:title];

}


- (void)orderCommitAction{

    NSLog(@"%@   %@  %@",self.price,self.sumprice,self.conponPrice);
    
    if ([Utils showLoginPageIfNeeded]) {
    } else {
        if (self.planid.length == 0) {
            [Utils postMessage:@"请选择套餐类型" onView:self.view];
            return;
        }
        
        if (self.cityid.length == 0) {
            [Utils postMessage:@"请选择城市" onView:self.view];
            return;
        }
        
        if (self.name.text.length == 0) {
            [Utils postMessage:@"请输入购买人姓名" onView:self.view];
            return;
        }
        
        if (self.age.text.length == 0) {
            [Utils postMessage:@"请输入购买人年龄" onView:self.view];
            return;
        }
        
        if (self.sex.text.length == 0) {
            [Utils postMessage:@"请选择购买人性别" onView:self.view];
            return;
        }
        
        if (self.phone.text.length == 0) {
            [Utils postMessage:@"请输入可以联系到购买人的手机号" onView:self.view];
            return;
        }
        
        NSError *error;
        if (![ValidatorUtil isValidMobile:self.phone.text error:&error]) {
            [self toast:@"请输入正确的手机号"];
            return;
        }
        
        [Utils addHudOnView:self.view];
        
        if (self.orderid) {
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
            [Utils removeHudFromView:self.view];

            orderCommitHeader *commithead = [[orderCommitHeader alloc]init];

            commithead.target = @"orderControl";

            commithead.method = @"createOrder";

            commithead.versioncode = Versioncode;

            commithead.devicenum = Devicenum;

            commithead.fromtype = Fromtype;

            commithead.token = [User LocalUser].token;

            orderCommitBody *commitOrderbody = [[orderCommitBody alloc]init];
            commitOrderbody.planid = self.planid;
            commitOrderbody.cityid = self.cityid;
            commitOrderbody.patientname  = self.name.text;
            commitOrderbody.patientsex  = self.sex.text;
            commitOrderbody.patientage = self.age.text;
            commitOrderbody.patientphone = self.phone.text;
            commitOrderbody.hopedid = self.holpId;
            commitOrderbody.type = @"1";
            commitOrderbody.zilist = @"0";
            commitOrderbody.count = 1;
            commitOrderbody.sumprice = self.sumprice;
            commitOrderbody.price = self.price;
            commitOrderbody.couponprice = self.conponPrice;
            commitOrderbody.coupondetailid = self.conponid;
        
            OrderCommitRequest *cityrequest = [[OrderCommitRequest alloc]init];

            cityrequest.head = commithead;

            cityrequest.body = commitOrderbody;

            [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];

        }

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
    
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在加载中...";
        WXRequestHeader *head = [[WXRequestHeader alloc]init];
        
        head.target = @"generalControl";
        
        head.method = @"createWeChatOrder";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        WXRequestBody *body = [[WXRequestBody alloc]init];
        
        body.orderid = self.orderModel.orderid;
        body.zilist = @"0";
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
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在加载中...";
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
        body.zilist = @"0";
        AlipayRequest *request = [[AlipayRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.alipay getAliOrder:request.mj_keyValues.mutableCopy];
    }

}

//查找是否有优惠券
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
    myconponBody.type = @"1";
    myconponBody.zilist = @"0";
    MyconponListRequest *myconponRequest = [[MyconponListRequest alloc]init];
    
    myconponRequest.head = myconponHead;
    
    myconponRequest.body = myconponBody;
    [self.myconponApi getorderConponList:myconponRequest.mj_keyValues.mutableCopy];
}

//计算价格
- (void)counterPriceWithPid:(NSString *)pid
             coupondetailid:(NSString *)coupondetailid
{
    priceHeader *pricehead = [[priceHeader alloc]init];
    pricehead.target = @"noTokenOrderControl";
    pricehead.method = @"sumPriceOne";
    pricehead.versioncode = Versioncode;
    pricehead.devicenum = Devicenum;
    pricehead.fromtype = Fromtype;
    priceBody *pricebody = [[priceBody alloc]init];
    pricebody.id = pid;
    pricebody.coupondetailid = coupondetailid;
    PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
    pricerequest.head = pricehead;
    pricerequest.body = pricebody;
    [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
