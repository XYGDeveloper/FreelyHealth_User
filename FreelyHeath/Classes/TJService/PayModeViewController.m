//
//  PayModeViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PayModeViewController.h"
#import "SelectTypeTableViewCell.h"
#import "PriceDisplayTableViewCell.h"
#import "PayModeTableViewCell.h"
#import "DeleteOrderRequest.h"
#import "OrderCommitApi.h"
#import "OrderCommitRequest.h"
#import "AliModel.h"
#import "AlipayRequest.h"
#import "AlipayApi.h"
#import "AlipayService.h"
#import "CommitOrderModel.h"
#import "PayScuessViewController.h"
#import "OrderDetailModel.h"
#import "WXCreatOrderApi.h"
#import "CreatWXOrderRequest.h"
#import "WXPayService.h"
#import "WXPayReq.h"
#import "WXorderModel.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"
#import "deleteApi.h"
#import "Location_Manager.h"
#import "OrderConponListViewController.h"
#import "priceCounterApi.h"
#import "PriceCounterRequest.h"
#import "MyconponListModel.h"
#import "SumModel.h"
#import "TunorDetail.h"
#import "OrderModel.h"
#import "OrderConponListApi.h"
#import "MyconponListRequest.h"
#import "MyconponListModel.h"
@interface PayModeViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIImageView *imageurl;

@property (nonatomic,strong)UILabel *titleName;

@property (nonatomic,strong)UILabel *desLTitle;

@property (nonatomic,strong)SelectTypeTableViewCell *conpon;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSInteger selcetedIndex;
@property (nonatomic,strong)UIView *bgpriceLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *commitOrder;
//
@property (nonatomic,strong)WXCreatOrderApi *wxOrder;
@property (nonatomic,strong)AlipayApi *alipay;
@property (nonatomic,strong)OrderCommitApi *ordercommitApi;
@property (nonatomic,strong)deleteApi *deleteApi;
@property (nonatomic,strong)priceCounterApi *priceCApi;
@property (nonatomic,strong)SumModel *sumModel;
//
@property (nonatomic,strong)NSString *conponid;
@property (nonatomic,strong)NSString *conponprice;
@property (nonatomic,strong)NSString *sumpriceprice;
@property (nonatomic,strong)NSString *price;
@property (nonatomic,strong)NSString *orderid;
@property (nonatomic,strong)CommitOrderModel *orderModel;
@property (nonatomic,strong)OrderConponListApi *myconponApi;
@property (nonatomic,strong)NSMutableArray *myconponArray;

@end

@implementation PayModeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (UIView *)bgpriceLabel
{
    if (!_bgpriceLabel) {
        _bgpriceLabel = [UIView new];
        _bgpriceLabel.backgroundColor = [UIColor whiteColor];
    }
    return _bgpriceLabel;
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

- (OrderCommitApi *)ordercommitApi
{
    if (!_ordercommitApi) {
        _ordercommitApi = [[OrderCommitApi alloc]init];
        _ordercommitApi.delegate  =self;
    }
    return _ordercommitApi;
}

-(OrderConponListApi *)myconponApi{
    if (!_myconponApi) {
        _myconponApi = [[OrderConponListApi alloc]init];
        _myconponApi.delegate  = self;
    }
    return _myconponApi;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.font = [UIFont systemFontOfSize:16 weight:2];
        _priceLabel.backgroundColor = [UIColor whiteColor];
        _priceLabel.textColor = AppStyleColor;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UIButton *)commitOrder
{
    if (!_commitOrder) {
        _commitOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitOrder setTitle:@"去支付" forState:UIControlStateNormal];
        [_commitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitOrder.backgroundColor = AppStyleColor;
        _commitOrder.titleLabel.font = FontNameAndSize(16);
    }
    return _commitOrder;
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

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate  = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.separatorColor = HexColor(0xe7e7e9);
    }
    return _tableview;
}
- (void)layOutsubview{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-45);
    }];
    [self.bgpriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/3 *2);
        make.height.mas_equalTo(50);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self.bgpriceLabel.mas_centerY);
        make.height.mas_equalTo(25);
    }];
    
    [self.commitOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.bgpriceLabel.mas_right);
        make.height.mas_equalTo(self.bgpriceLabel.mas_height);
    }];
}

- (SelectTypeTableViewCell *)conpon {
    if (!_conpon) {
        _conpon = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _conpon.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_conpon setEditAble:NO];
        [_conpon setTypeName:@"优惠券" placeholder:@""];
        _conpon.textField.textColor = AppStyleColor;
        _conpon.textField.textAlignment = NSTextAlignmentRight;
        _conpon.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _conpon;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.priceLabel.text = [NSString stringWithFormat:@"合计: ￥%@",self.model.datailo];
    [self counterPriceWithPid:self.HZid coupondetailid:self.conponid count:1];
    [self findConponWithPid:self.HZid];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    self.view.backgroundColor = DefaultBackgroundColor;
    self.dataArray = @[self.conpon];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.bgpriceLabel];
    [self.bgpriceLabel addSubview:self.priceLabel];
    [self.view addSubview:self.commitOrder];
    [self layOutsubview];
    [self.tableview registerClass:[PriceDisplayTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PriceDisplayTableViewCell class])];
    [self.tableview registerClass:[PayModeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PayModeTableViewCell class])];
    
    [self.commitOrder addTarget:self action:@selector(creatOrder) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0001;
    }else if(section == 2){
        return 52;
    }else{
        return 0.0001;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   if(section == 2){
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
        self.desLTitle.text = @"选择支付方式";
        return content;
        
    }else{
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else if(section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 52;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        PriceDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PriceDisplayTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:self.model];
        return cell;
    }else if(indexPath.section == 1){
        return self.conpon;
    }else{
        PayModeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PayModeTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.paylabel.text = @"支付宝";
            cell.payIMage.image =[UIImage imageNamed:@"alipay-1"];
        }else{
            cell.paylabel.text = @"微信";
            cell.payIMage.image =[UIImage imageNamed:@"weixin"];
        }
        cell.accessoryViewSelected = self.selcetedIndex == indexPath.row;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.myconponArray.count <=0) {
            [Utils postMessage:@"无可用优惠券" onView:self.view];
        }else{
            OrderConponListViewController *con = [OrderConponListViewController new];
            con.cid = self.conponid;
            con.id = self.HZid;
            con.title = @"优惠券";
            con.type = @"3";
            con.zilist = @"0";
            con.conpon = ^(MyconponListModel *model) {
                self.conponid = model.id;
                self.conponprice = model.denominat;
                [self counterPriceWithPid:self.HZid coupondetailid:model.id count:1];
                self.conpon.text = [NSString stringWithFormat:@"-%@",model.denominat];
            };
            [self.navigationController pushViewController:con animated:YES];
        }
    }
    if (indexPath.section ==2) {
        if (self.selcetedIndex == indexPath.row) {
            return;
        }
        self.selcetedIndex = indexPath.row;
        [self.tableview reloadData];
    }
}

//计算价格
- (void)counterPriceWithPid:(NSString *)pid
             coupondetailid:(NSString *)coupondetailid
                      count:(int)count
{
    priceHeader *pricehead = [[priceHeader alloc]init];
    pricehead.target = @"noTokenOrderControl";
    pricehead.method = @"sumPriceTwo";
    pricehead.versioncode = Versioncode;
    pricehead.devicenum = Devicenum;
    pricehead.fromtype = Fromtype;
    priceBody *pricebody = [[priceBody alloc]init];
    pricebody.id = pid;
    pricebody.coupondetailid = coupondetailid;
    pricebody.count = count;
    PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
    pricerequest.head = pricehead;
    pricerequest.body = pricebody;
    [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
}

- (void)counterPriceWithPid:(NSString *)pid
                      count:(int)count
                    fuwufei:(NSString *)fuwufei
             coupondetailid:(NSString *)coupondetailid
{
    priceHeader *pricehead = [[priceHeader alloc]init];
    pricehead.target = @"noTokenOrderControl";
    pricehead.method = @"sumPrice";
    pricehead.versioncode = Versioncode;
    pricehead.devicenum = Devicenum;
    pricehead.fromtype = Fromtype;
    priceBody *pricebody = [[priceBody alloc]init];
    pricebody.id = pid;
    pricebody.count = count;
    pricebody.fuwufei = fuwufei;
    pricebody.coupondetailid = coupondetailid;
    PriceCounterRequest *pricerequest = [[PriceCounterRequest alloc]init];
    pricerequest.head = pricehead;
    pricerequest.body = pricebody;
    [self.priceCApi getPrice:pricerequest.mj_keyValues.mutableCopy];
}

- (void)creatOrder{
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
                orderCommitHeader *commithead = [[orderCommitHeader alloc]init];
                commithead.target = @"orderControl";
                commithead.method = @"createOrder";
                commithead.versioncode = Versioncode;
                commithead.devicenum = Devicenum;
                commithead.fromtype = Fromtype;
                commithead.token = [User LocalUser].token;
                orderCommitBody *commitOrderbody = [[orderCommitBody alloc]init];
                commitOrderbody.type = @"3";
                commitOrderbody.count = 1;
                commitOrderbody.price = self.price;
                commitOrderbody.mdtyuyueid = self.HZid;
                commitOrderbody.sumprice = self.sumpriceprice;
                commitOrderbody.couponprice = self.conponprice;
                commitOrderbody.coupondetailid = self.conponid;
                commitOrderbody.zilist = @"0";
                OrderCommitRequest *cityrequest = [[OrderCommitRequest alloc]init];
                cityrequest.head = commithead;
                cityrequest.body = commitOrderbody;
                [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];
    
            }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeAllHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeAllHudFromView:self.view];
    if (api==_myconponApi) {
        self.myconponArray = [NSMutableArray array];
        [self.myconponArray removeAllObjects];
        self.myconponArray = responsObject;
        if (self.myconponArray.count<=0) {
            self.conpon.text = @"无可用优惠券";
        }else{
            self.conpon.text = @"有可用优惠券";
        }
    }
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
        commitOrderbody.type = @"3";
        commitOrderbody.count = 1;
        commitOrderbody.price = self.price;
        commitOrderbody.mdtyuyueid = self.HZid;
        commitOrderbody.sumprice = self.sumpriceprice;
        commitOrderbody.couponprice = self.conponprice;
        commitOrderbody.coupondetailid = self.conponid;
        OrderCommitRequest *cityrequest = [[OrderCommitRequest alloc]init];
        cityrequest.head = commithead;
        cityrequest.body = commitOrderbody;
        [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];
    }
    
    if (api == _priceCApi) {
        self.sumModel = [SumModel mj_objectWithKeyValues:responsObject];
        self.priceLabel.text = [NSString stringWithFormat:@"合计:  ￥%.1f",self.sumModel.sumprice];
        self.sumpriceprice = [NSString stringWithFormat:@"%.1f",self.sumModel.sumprice];
        self.price = [NSString stringWithFormat:@"%.1f",self.sumModel.price];
    }
    if (api ==_ordercommitApi) {
        [Utils removeAllHudFromView:self.view];
        self.orderModel = responsObject;
        self.orderid = self.orderModel.orderid;
        NSLog(@"self.selcetedIndex:%ld",self.selcetedIndex);
        if (self.selcetedIndex == 0) {
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
            body.zilist = @"0";
            AlipayRequest *request = [[AlipayRequest alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.alipay getAliOrder:request.mj_keyValues.mutableCopy];
        }else{
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
            body.zilist = @"0";
            CreatWXOrderRequest *request = [[CreatWXOrderRequest alloc]init];
            request.head = head;
            request.body = body;
            NSLog(@"%@",request);
            [self.wxOrder getWXOrder:request.mj_keyValues.mutableCopy];
            
        }
    }
    if (api == _alipay) {
//        [Utils addHudOnView:self.view];
        if ([AlipayService isAlipayAppInstalled]) {
            AliModel *model = responsObject;
            [[AlipayService defaultService]payOrderWithInfo:model.info withCompletionBlock:^(NSString *result) {
                [self dealWithPayResult:result];
            }];
        }
    }
    
    
    if (api == _wxOrder) {
//        [Utils addHudOnView:self.view];
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
        [Utils removeAllHudFromView:self.view];
    } else if ([result isEqualToString:PayResultTypeFailed]) {
        msg = @"支付失败";
        [Utils postMessage:msg onView:self.view];
        [Utils removeAllHudFromView:self.view];

    } else if ([result isEqualToString:PayResultTypeSuccess]) {
        msg = @"支付成功";
        [Utils postMessage:msg onView:self.view];
        [Utils removeAllHudFromView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:kOrderPaySuccessNotify object:nil];
        PayScuessViewController *scuess = [PayScuessViewController new];
        scuess.hzid = self.HZid;
        scuess.aEnterHZ = YES;
        self.titleName.text = self.model.name;
        self.desLTitle.text = @"请提前和客服联系，以便及时安排服务";
        scuess.service = self.model.name;
        scuess.name = [User LocalUser].name;
        NSRange range = {3,4};
        scuess.phone = [[User LocalUser].phone stringByReplacingCharactersInRange:range withString:@"****"];
        scuess.title = @"支付成功";
        scuess.aEnter = YES;
        [self.navigationController pushViewController:scuess animated:YES];
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
    myconponBody.type = @"3";
    myconponBody.zilist = @"0";
    MyconponListRequest *myconponRequest = [[MyconponListRequest alloc]init];
    
    myconponRequest.head = myconponHead;
    
    myconponRequest.body = myconponBody;
    [self.myconponApi getorderConponList:myconponRequest.mj_keyValues.mutableCopy];
    
}

@end
