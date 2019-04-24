//
//  OrderDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "IndexStyleTableViewCell.h"
#import "FirstWaves.h"
#import "SecondWaves.h"
#import "OrderDetailStepStyleTableViewCell.h"
#import "OrderListModel.h"
#import "OrderDetailModel.h"
#import "OrderDetailApi.h"
#import "OrderDetailRequest.h"
#import "OrderFillViewController.h"
#import "CustomShareView.h"
#import "AlipayApi.h"
#import "AlipayRequest.h"
#import "AlipayService.h"
#import "AliModel.h"
#import "PayScuessViewController.h"
#import "CancelOrderApi.h"
#import "CancelOrderRequest.h"
#import "WXCreatOrderApi.h"
#import "CreatWXOrderRequest.h"
#import "WXPayService.h"
#import "WXPayReq.h"
#import "WXorderModel.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"
#import "TableViewCell.h"
#import "AlertView.h"

#define kFetchTag 7000

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,selectPayModelDelegate,BaseMessageViewDelegate,UIAlertViewDelegate>
{
    CustomShareView *_customShareView;
}
@property (nonatomic,strong)FirstWaves *firstWare;

@property (nonatomic,strong)SecondWaves *secondWare;

@property (nonatomic,strong)UITableView *weightTableview;

@property (nonatomic,strong)NSMutableArray *weightArray;

@property (nonatomic,strong)UIButton *updateDate;

@property (nonatomic,strong)UIButton *cancelOrder;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UILabel *OrderType;

@property (nonatomic,strong)UILabel *priceString;

@property (nonatomic,strong)UILabel *userInfo;

@property (nonatomic,strong)UILabel *orderConponPrice;

@property (nonatomic,strong)UILabel *realPay;

@property (nonatomic,strong)UILabel *orderState;

@property (nonatomic,strong)OrderDetailApi *api;

@property (nonatomic,strong)OrderDetailModel *model;

@property (nonatomic,strong)NSArray *listArr;

@property (nonatomic,strong)AlipayApi *alipay;

@property (nonatomic,strong)CancelOrderApi *canOrderApi;

@property (nonatomic,strong)WXCreatOrderApi *wxOrder;

@end

@implementation OrderDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
}

- (OrderDetailApi *)api
{

    if (!_api) {
        
        _api = [[OrderDetailApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (AlipayApi *)alipay
{
    
    if (!_alipay) {
        
        _alipay = [[AlipayApi alloc]init];
        
        _alipay.delegate  = self;
        
    }
    
    return _alipay;
    
}


- (CancelOrderApi *)canOrderApi
{

    if (!_canOrderApi) {
        
        _canOrderApi = [[CancelOrderApi alloc]init];
        
        _canOrderApi.delegate  = self;
        
    }
    
    return _canOrderApi;
    

}

- (WXCreatOrderApi *)wxOrder
{
    
    if (!_wxOrder) {
        
        _wxOrder = [[WXCreatOrderApi alloc]init];
        
        _wxOrder.delegate  = self;
        
    }
    
    return _wxOrder;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [self.weightTableview.mj_header endRefreshing];

    [LSProgressHUD hide];
    
    [Utils postMessage:command.response.msg onView:self.view];
   
    if (api == _alipay) {
        
        NSLog(@"ffffff");
        
    }
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    [self.weightTableview.mj_header endRefreshing];

    [LSProgressHUD hide];

    if (api == _alipay) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        AliModel *model = responsObject;
        
        if ([AlipayService isAlipayAppInstalled]) {
            
            weakify(self);
            
            [[AlipayService defaultService]payOrderWithInfo:model.info withCompletionBlock:^(NSString *result) {
                
                strongify(self);
                
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
            
            __weak typeof(self) wself = self;

            [[WXPayService defaultService]payOrderWithInfo:req comletionBlock:^(NSString *result) {
                
                NSLog(@"asddddd=== %@",result);
//                
//                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payScuess:) name:kOrderPaySuccessNotify object:nil];
                
                [wself dealWithPayResult:result];

            }];
            
        }else
        {
        
        }

    }
    
    if (api == _api) {
        
        [LSProgressHUD hide];
        
        self.model = responsObject;
        
        self.listArr  = [itemModel mj_objectArrayWithKeyValuesArray:self.model.items];
        
        self.OrderType.text = self.model.name;
        
        self.priceString.text = [NSString stringWithFormat:@"￥%@",self.model.payment];
        
        self.userInfo.text = [NSString stringWithFormat:@"服务对象:%@,%@,%@岁,%@,%@",self.model.patientname,self.model.patientsex,self.model.patientage,self.model.patientphone,self.model.cityname];
        NSLog(@"--------%@",self.model);
        if (self.model.sumprice) {
            int price = [self.model.payment intValue] - [self.model.sumprice intValue];
            self.orderConponPrice.text = [NSString stringWithFormat:@"订单优惠：-￥%d",price];
            self.realPay.text = [NSString stringWithFormat:@"实际支付：￥%@",self.model.sumprice];
        }else{
            self.orderConponPrice.text = @"订单优惠：-￥0";
            self.realPay.text = [NSString stringWithFormat:@"实际支付：￥%@",self.model.payment];
        }
    }
    
    if (self.model.status == 1) {
        
        self.orderState.text = @"订单状态：待支付";
        [self.updateDate setTitle:@"立即支付" forState:UIControlStateNormal];
        
        self.updateDate.hidden = YES;
        
        UIButton *cancelOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        cancelOrder.backgroundColor = [UIColor colorWithRed:169/255.0 green:225/255.0 blue:236/255.0 alpha:1.0f];
        [self.view addSubview:cancelOrder];
        [cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(50);
        }];
        
        [cancelOrder addTarget:self action:@selector(CancelOrder) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton *payOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [payOrder setTitle:@"立即支付" forState:UIControlStateNormal];
        
        payOrder.backgroundColor = AppStyleColor;
        
        [self.view addSubview:payOrder];
        
        [payOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cancelOrder.mas_right);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(50);
        }];
        
        [payOrder addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (self.model.status == 2){
        
        self.orderState.text = @"订单状态：进行中";
        
        self.updateDate.hidden = YES;
        
    }else if (self.model.status == 3){
        
        self.orderState.text = @"订单状态：已完成";
        
        [self.updateDate setTitle:@"再次下单" forState:UIControlStateNormal];
        
    }else if (self.model.status == 4){
        
        self.orderState.text = @"订单状态：已取消";
        [self.updateDate setTitle:@"重新预定" forState:UIControlStateNormal];
        
    }
    
    if (api == _canOrderApi) {
        [Utils removeHudFromView:self.view];
         [Utils postMessage:@"取消订单成功" onView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_cancel object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self.weightTableview reloadData];
   
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

        PayScuessViewController *scuess = [PayScuessViewController new];
        
        scuess.service = self.model.name;
        
        scuess.name = self.model.patientname;
        
        NSRange range = {3,4};
        
        scuess.phone = [self.model.patientphone stringByReplacingCharactersInRange:range withString:@"****"];
        
        scuess.title = @"支付成功";
        
        [self.navigationController pushViewController:scuess animated:YES];

    }
    
}

- (UITableView *)weightTableview
{
    
    if (!_weightTableview) {
        
        _weightTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _weightTableview.delegate  =self;
        
        _weightTableview.dataSource = self;
        
        _weightTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _weightTableview.backgroundColor = DefaultBackgroundColor;
        _weightTableview.showsVerticalScrollIndicator = NO;
        
    }
    
    return _weightTableview;
    
}



- (void)setHeadView{
    
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    //第一个波浪
    self.firstWare = [[FirstWaves alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    
    self.firstWare.alpha= 0.6;
    
    //第二个波浪
    self.secondWare = [[SecondWaves alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 250)];
    
    self.secondWare.alpha=0.9;
    
    [self.headView addSubview:self.firstWare];
    
    [self.headView addSubview:self.secondWare];
    
    //
    self.OrderType = [[UILabel alloc]init];
    
    self.OrderType.font = Font(18);
    
    self.OrderType.textColor = [UIColor whiteColor];
    
    self.OrderType.textAlignment = NSTextAlignmentLeft;
    
    
    [self.secondWare addSubview:self.OrderType];
    
    self.priceString = [[UILabel alloc]init];
    
    self.priceString.font = Font(18);
    
    self.priceString.textColor = [UIColor whiteColor];
    
    self.priceString.textAlignment = NSTextAlignmentRight;
    
    
    [self.secondWare addSubview:self.priceString];
    
    self.userInfo = [[UILabel alloc]init];
    
    self.userInfo.font = Font(14);
    
    self.userInfo.textColor = [UIColor whiteColor];
    
    self.userInfo.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.userInfo];
    
    
    //
    self.orderConponPrice = [[UILabel alloc]init];
    
    self.orderConponPrice.font = Font(14);
    
    self.orderConponPrice.textColor = [UIColor whiteColor];
    
    self.orderConponPrice.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.orderConponPrice];
    //
    self.realPay = [[UILabel alloc]init];
    
    self.realPay.font = Font(14);
    
    self.realPay.textColor = [UIColor whiteColor];
    
    self.realPay.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.realPay];
    
    
    self.orderState = [[UILabel alloc]init];
    
    self.orderState.font = Font(14);
    
    self.orderState.textColor = [UIColor whiteColor];
    
    self.orderState.textAlignment = NSTextAlignmentLeft;
    
    [self.secondWare addSubview:self.orderState];
    
    UILabel *historyLabel= [[UILabel alloc]init];
    
    historyLabel.font = Font(16);
    historyLabel.textAlignment = NSTextAlignmentCenter;
    historyLabel.text  =@"服务流程";
    historyLabel.textColor = DefaultGrayLightTextClor;
    
    [self.headView addSubview:historyLabel];
    
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-15);
    }];
    
    
}


- (void)layOutSubView{
    
    [self.weightTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.updateDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.OrderType mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        
        make.left.mas_equalTo(16);
        
        make.width.mas_equalTo(kScreenWidth/2);
        
        make.height.mas_equalTo(25);
    }];
    
    [self.priceString mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        
        make.right.mas_equalTo(-15);
        
        make.width.mas_equalTo(kScreenWidth/2);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.OrderType.mas_bottom).mas_equalTo(0);
        
        make.left.mas_equalTo(self.OrderType.mas_left);
        
        make.width.mas_equalTo(kScreenWidth- 26);
        
        make.height.mas_equalTo(25);
        
    }];
    
    [self.orderConponPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.userInfo.mas_bottom).mas_equalTo(0);
        
        make.left.mas_equalTo(self.OrderType.mas_left);
        
        make.width.mas_equalTo(kScreenWidth- 26);
        
        make.height.mas_equalTo(25);
    }];
    [self.realPay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.orderConponPrice.mas_bottom).mas_equalTo(0);
        
        make.left.mas_equalTo(self.OrderType.mas_left);
        
        make.width.mas_equalTo(kScreenWidth- 26);
        
        make.height.mas_equalTo(25);
    }];
    
    [self.orderState mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.realPay.mas_bottom).mas_equalTo(0);
        
        make.left.mas_equalTo(16);
        
        make.width.mas_equalTo(kScreenWidth);
        
        make.height.mas_equalTo(25);
        
    }];
    
    
}

- (UIButton *)updateDate
{
    
    if (!_updateDate) {
        
        _updateDate = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _updateDate.backgroundColor = AppStyleColor;
        
        [_updateDate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _updateDate.titleLabel.font = Font(20);
        
    }
    
    return _updateDate;
    
}


- (UIButton *)cancelOrder
{
    
    if (!_cancelOrder) {
        
        _cancelOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _cancelOrder.backgroundColor = AppStyleColor;
        
        [_cancelOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _cancelOrder.titleLabel.font = Font(20);
        
    }
    
    return _cancelOrder;
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.title = @"订单详情";
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"tel"] highligthtedImage:[UIImage imageNamed:@"tel"] action:@selector(telephone)];
    
    [self.view addSubview:self.weightTableview];
    
    [self.weightTableview registerClass:[TableViewCell class] forCellReuseIdentifier:@"Cell"];

    [self.view addSubview:self.updateDate];
    
    [self setHeadView];
    
    self.weightTableview.tableHeaderView  = self.headView;
    
    [self.updateDate addTarget:self action:@selector(updateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self layOutSubView];

    //选择支付方式
    
    _customShareView = [[CustomShareView alloc]init];
    
    [self.view addSubview:_customShareView];
    
    _customShareView.delegate  = self;
    
    self.weightTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        [LSProgressHUD showWithMessage:nil];
        
        OrderDetailHeader *head = [[OrderDetailHeader alloc]init];
        
        head.target = @"ownControl";
        
        head.method = @"getOrderDetail";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        OrderDetailBody *body = [[OrderDetailBody alloc]init];
        
        body.id = self.ID;
        
        OrderDetailRequest *request = [[OrderDetailRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api getOrderdetail:request.mj_keyValues.mutableCopy];

    }];
    
    [self.weightTableview.mj_header beginRefreshing];
    
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

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"不取消"]) {
            
        }else{
            [Utils addHudOnView:self.view withTitle:@"正在取消..."];
            cancelOrderHeader *head = [[cancelOrderHeader alloc]init];
            
            head.target = @"ownControl";
            
            head.method = @"orderCancel";
            
            head.versioncode = Versioncode;
            
            head.devicenum = Devicenum;
            
            head.fromtype = Fromtype;
            
            head.token = [User LocalUser].token;
            
            cancelOrderBody *body = [[cancelOrderBody alloc]init];
            
            body.id = self.model.id;
            
            CancelOrderRequest *request = [[CancelOrderRequest alloc]init];
            
            request.head = head;
            
            request.body = body;
            
            NSLog(@"%@",request);
            
            [self.canOrderApi getmyfile:request.mj_keyValues.mutableCopy];
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


- (void)CancelOrder{

    NSString *content = @"确认要取消此订单";
    [self showScanMessageTitle:nil  content:content leftBtnTitle:@"不取消" rightBtnTitle:@"取消订单" tag:kFetchTag];
    
}

- (void)updateAction{
    
    if (self.model.status == 1) {
        
        [self.updateDate setTitle:@"立即支付" forState:UIControlStateNormal];
        
        [_customShareView showInView:self.view];

    }else if (self.model.status == 2){
        
        self.updateDate.hidden = YES;
        
    }else if (self.model.status == 3 || self.model.status == 4){
        
        //订单填写
        
        OrderFillViewController *orderFill = [OrderFillViewController new];
        
        orderFill.revireOrder = YES;
        
        orderFill.orderDetailModel = self.model;
        
        [self.navigationController pushViewController:orderFill animated:YES];
        
    }

    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return CGFLOAT_MIN;
        
    }else{
        
        return 0;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return 100;
    return [tableView fd_heightForCellWithIdentifier:@"Cell" cacheByIndexPath:indexPath configuration:^(TableViewCell *cell) {
        itemModel *model = [self.listArr objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (indexPath.row == 0) {
        [cell.onLine removeFromSuperview];
    }
    if (indexPath.row == self.listArr.count-1) {
        [cell.downLine removeFromSuperview];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        itemModel *model = [self.listArr objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
    return cell;
}

- (void)selectPayModel:(NSInteger)index
{
    
    NSLog(@"%ld",index);
    
    
    if (index == 1) {
        
        //微信支付
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
        
        body.orderid = self.model.id;
        body.zilist = @"0";
        CreatWXOrderRequest *request = [[CreatWXOrderRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.wxOrder getWXOrder:request.mj_keyValues.mutableCopy];
 
    }else if (index == 2){
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
        
        body.orderid = self.model.id;
        body.zilist = @"0";
        AlipayRequest *request = [[AlipayRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.alipay getAliOrder:request.mj_keyValues.mutableCopy];
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}


@end
