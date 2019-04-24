//
//  HZOrderDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZOrderDetailViewController.h"
#import "SbscriDesTableViewCell.h"
#import "HZOrderdetailTableViewCell.h"
#import "ToSubsViewController.h"
#import "TJOrderDetailModel.h"
#import "TJOrderDetailRequest.h"
#import "TJOrderDetailApi.h"
#import "TJServiceDetailViewController.h"
#import "CancelOrderApi.h"
#import "CancelOrderRequest.h"
#import "CustomShareView.h"
#import "AlipayApi.h"
#import "AlipayRequest.h"
#import "AlipayService.h"
#import "AliModel.h"
#import "PayScuessViewController.h"
#import "WXCreatOrderApi.h"
#import "CreatWXOrderRequest.h"
#import "WXPayService.h"
#import "WXPayReq.h"
#import "WXorderModel.h"
#import "GTMBase64.h"
#import "SecurityUtil.h"
#import "MedicalPayScuessViewController.h"
#import "PhyicalModel.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "TJorderCommitRequest.h"
#import "SubsOrderHaveServiceTableViewCell.h"
#import "AlertView.h"
#import "AuditedViewController.h"
#import "AppionmentFInishViewController.h"
#import "AppionmentReviewViewController.h"
#import "WailtToPayViewController.h"
#import "AuditedViewController.h"
#import "PayFinishViewController.h"
#import "PayModeViewController.h"
#import "TunorDetail.h"
#import "NationInsureViewController.h"
#define kFetchTag 7000
@interface HZOrderDetailViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ApiRequestDelegate,selectPayModelDelegate,BaseMessageViewDelegate>
{
    CustomShareView *_customShareView;
}
@property (nonatomic,strong)UITableView *OrderdetailTableView;
@property (nonatomic,strong)UIButton *toSub;   //预约
@property (nonatomic,strong)UIButton *ToPay;   //立即支付
@property (nonatomic,strong)UIButton *cancelOrder; //取消订单
@property (nonatomic,strong)TJOrderDetailApi *api;
@property (nonatomic,strong)TJOrderDetailModel *model;
@property (nonatomic,strong)CancelOrderApi *canOrderApi;
@property (nonatomic,strong)AlipayApi *alipay;
@property (nonatomic,strong)WXCreatOrderApi *wxOrder;

@end

@implementation HZOrderDetailViewController

- (UIButton *)ToPay
{
    if (!_ToPay) {
        _ToPay = [UIButton buttonWithType:UIButtonTypeCustom];
        _ToPay.backgroundColor = AppStyleColor;
        [_ToPay setTitle:@"立即支付" forState:UIControlStateNormal];
        [_ToPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ToPay.titleLabel.font = Font(20);
    }
    return _ToPay;
}
- (UIButton *)cancelOrder
{
    if (!_cancelOrder) {
        _cancelOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelOrder.backgroundColor = [UIColor whiteColor];
        [_cancelOrder setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelOrder setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _cancelOrder.titleLabel.font = Font(20);
    }
    return _cancelOrder;
}
- (TJOrderDetailApi *)api
{
    if (!_api) {
        
        _api = [[TJOrderDetailApi alloc]init];
        _api.delegate  =self;
    }
    return _api;
}
- (UIButton *)toSub{
    if (!_toSub) {
        _toSub = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toSub setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _toSub.backgroundColor = AppStyleColor;
        _toSub.titleLabel.font = Font(20);
    }
    return _toSub;
}
- (CancelOrderApi *)canOrderApi
{
    if (!_canOrderApi) {
        _canOrderApi = [[CancelOrderApi alloc]init];
        _canOrderApi.delegate  = self;
    }
    return _canOrderApi;
}
- (UITableView *)OrderdetailTableView
{
    if (!_OrderdetailTableView) {
        _OrderdetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _OrderdetailTableView.delegate = self;
        _OrderdetailTableView.dataSource = self;
        _OrderdetailTableView.backgroundColor = DefaultBackgroundColor;
    }
    return _OrderdetailTableView;
}
- (AlipayApi *)alipay
{
    if (!_alipay) {
        _alipay = [[AlipayApi alloc]init];
        _alipay.delegate  = self;
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

- (void)setStatusUI{
    
    [self.view addSubview:self.cancelOrder];
    
    [self.cancelOrder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(50);
    }];
    
    [self.cancelOrder addTarget:self action:@selector(delOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.ToPay];
    
    [self.ToPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cancelOrder.mas_right);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(self.cancelOrder.mas_width);
    }];
    
    [self.ToPay addTarget:self action:@selector(toOrder) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setStatusUI1{
    
    [self.view addSubview:self.toSub];
    [self.toSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self.toSub addTarget:self action:@selector(toSubscri) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)toOrder{
    
    _customShareView = [[CustomShareView alloc]init];
    [self.view addSubview:_customShareView];
    _customShareView.delegate  = self;
    [_customShareView showInView:self.view];
    
}

-(void)delOrder{
    
    NSString *content = @"确认要取消此订单";
    [self showScanMessageTitle:nil  content:content leftBtnTitle:@"不取消" rightBtnTitle:@"取消订单" tag:kFetchTag];
    
}

- (void)selectPayModel:(NSInteger)index
{
    NSLog(@"%ld",index);
    if (index == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"加载中...";
        //微信支付
        WXRequestHeader *head = [[WXRequestHeader alloc]init];
        head.target = @"generalControl";
        head.method = @"createWeChatOrder";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        WXRequestBody *body = [[WXRequestBody alloc]init];
        body.orderid = self.orderid;
        body.zilist = self.model.zilist;
        CreatWXOrderRequest *request = [[CreatWXOrderRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.wxOrder getWXOrder:request.mj_keyValues.mutableCopy];
        
    }else if (index == 2){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"加载中...";
        //支付宝支付
        AliRequestHeader *head = [[AliRequestHeader alloc]init];
        head.target = @"generalControl";
        head.method = @"createAlipayOrder";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        AliRequestBody *body = [[AliRequestBody alloc]init];
        body.orderid = self.orderid;
        body.zilist = self.model.zilist;
        AlipayRequest *request = [[AlipayRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.alipay getAliOrder:request.mj_keyValues.mutableCopy];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.OrderdetailTableView registerClass:[SbscriDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SbscriDesTableViewCell class])];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self setRightNavigationItemWithImage:[UIImage imageNamed:@"tel"] highligthtedImage:[UIImage imageNamed:@"tel"] action:@selector(telephone)];
    [self.view addSubview:self.OrderdetailTableView];
    [self.OrderdetailTableView registerClass:[HZOrderdetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HZOrderdetailTableViewCell class])];

    TJOrderDetailHeader *cityhead = [[TJOrderDetailHeader alloc]init];
    
    cityhead.target = @"ownControl";
    
    cityhead.method = @"getOrderDetail";
    
    cityhead.versioncode = Versioncode;
    
    cityhead.devicenum = Devicenum;
    
    cityhead.fromtype = Fromtype;
    
    cityhead.token = [User LocalUser].token;
    
    TJOrderDetailBody *citybody = [[TJOrderDetailBody alloc]init];
    
    citybody.id = self.orderid;
    
    TJOrderDetailRequest *cityrequest = [[TJOrderDetailRequest alloc]init];
    
    cityrequest.head = cityhead;
    
    cityrequest.body = citybody;
    
    [self.api getOrderDetail:cityrequest.mj_keyValues.mutableCopy];
    
    [self.toSub setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.view addSubview:self.toSub];
    [self.toSub mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.toSub addTarget:self action:@selector(tochat) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    if (api == _api) {
        TJOrderDetailModel *model = responsObject;
        self.model = model;
        [self.OrderdetailTableView reloadData];
        if (self.hzDetail == YES) {
            
        }else{
            if ([model.status isEqualToString:@"1"]) {
                [self setStatusUI];
                
            }else if ([model.status isEqualToString:@"2"]){
                if ([model.nojg isEqualToString:@"0"]) {
                  
                }else{
                    [self.toSub setTitle:@"体检预约" forState:UIControlStateNormal];
                    [self.view addSubview:self.toSub];
                    [self.toSub mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.mas_equalTo(0);
                        make.height.mas_equalTo(50);
                    }];
                    [self.toSub addTarget:self action:@selector(toSubscri) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }
        }
        
    }
    
    if (api == _canOrderApi) {
        [Utils removeHudFromView:self.view];
        [Utils postMessage:@"取消订单成功" onView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotification_cancel object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
        scuess.orderid = self.orderid;
        scuess.title = @"支付成功";
        [self.navigationController pushViewController:scuess animated:YES];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([SbscriDesTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(SbscriDesTableViewCell *cell) {
            [cell refreshWithModel:self.model];
        }];
    }else{
        return 25.5 * 6 + 10;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SbscriDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SbscriDesTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:self.model];
        cell.detail = ^{
            NationInsureViewController *nation = [NationInsureViewController new];
            [nation loadWebURLSring:self.model.url];
            nation.title = @"会诊详情";
            nation.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nation animated:YES];
        };
        return cell;
    }else{
            HZOrderdetailTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HZOrderdetailTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithModel:self.model];
            return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tochat{
//    UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
//    //设置头像
//    [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
//    [manager pushUdeskInViewController:self completion:nil];
//    //点击留言回调
//    [manager leaveMessageButtonAction:^(UIViewController *viewController){
//        [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
//            NSLog(@"客服用户自定义字段：%@",responseObject);
//        }];
//        UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
//        [viewController presentViewController:offLineTicket animated:YES completion:nil];
//    }];
    
    PayModeViewController *pay = [[PayModeViewController alloc]init];
    pay.HZid = self.model.mdtyuyueid;
    TunorDetail *model = [[TunorDetail alloc]init];
    model.name = @"会诊服务";
    model.datailo = self.model.price;
    pay.model = model;
    pay.title = @"提交订单";
    [self.navigationController pushViewController:pay animated:YES];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)toSubscri{
    ToSubsViewController *tosubs = [[ToSubsViewController alloc]init];
    [self.navigationController pushViewController:tosubs animated:YES];
}


@end
