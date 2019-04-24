//
//  MedicalPayScuessViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MedicalPayScuessViewController.h"
#import "ToSubsViewController.h"
#import "SubscribOrderViewController.h"
#import "TJOrderDetailModel.h"
#import "TJOrderDetailRequest.h"
#import "TJOrderDetailApi.h"
#import "MyOrderViewController.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
@interface MedicalPayScuessViewController ()<ApiRequestDelegate>

@property (nonatomic,strong)UIImageView *scuessImg;

@property (nonatomic,strong)UILabel *scuessLabel;

@property (nonatomic,strong)UILabel *scuessDes;

@property (nonatomic,strong)UILabel *scuessDes1;

@property (nonatomic,strong)UIButton *scanOrder;

@property (nonatomic,strong)UIButton *yuyueOrder;

@property (nonatomic,strong)TJOrderDetailApi *api;

@property (nonatomic,strong)NSString *id;

@end

@implementation MedicalPayScuessViewController

- (TJOrderDetailApi *)api
{
    if (!_api) {
        
        _api = [[TJOrderDetailApi alloc]init];
        _api.delegate  =self;
    }
    return _api;
}

- (void)refreshWithPage{
    
    self.scuessImg = [[UIImageView alloc]init];
    self.scuessImg.image = [UIImage imageNamed:@"alipay"];
    [self.view addSubview:self.scuessImg];
    [self.scuessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64.5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(59);
    }];
    
    self.scuessLabel = [[UILabel alloc]init];
    self.scuessLabel.text = @"支付成功";
    self.scuessLabel.textColor = DefaultBlackLightTextClor;
    self.scuessLabel.font = FontNameAndSize(17);
    self.scuessLabel.textAlignment  =NSTextAlignmentCenter;
    [self.view addSubview:self.scuessLabel];
    [self.scuessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scuessImg.mas_bottom).mas_equalTo(30);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    self.serviceType = [[UILabel alloc]init];
    self.serviceType.textColor = DefaultBlackLightTextClor;
    self.serviceType.font = FontNameAndSize(17);
    self.serviceType.textAlignment  =NSTextAlignmentCenter;
    [self.view addSubview:self.serviceType];
    [self.serviceType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scuessLabel.mas_bottom).mas_equalTo(30);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    self.scuessDetail = [[UILabel alloc]init];
    self.scuessDetail.textColor = DefaultBlackLightTextClor;
    self.scuessDetail.font = FontNameAndSize(17);
    self.scuessDetail.textAlignment  =NSTextAlignmentCenter;
    [self.view addSubview:self.scuessDetail];
    [self.scuessDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.serviceType.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    self.scuessDes = [[UILabel alloc]init];
    self.scuessDes.text = @"体检信息已发送到您的手机，请注意查收，";
    self.scuessDes.textColor = DefaultGrayTextClor;
    self.scuessDes.font = FontNameAndSize(14);
    self.scuessDes.textAlignment  =NSTextAlignmentCenter;
    [self.view addSubview:self.scuessDes];
    [self.scuessDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scuessDetail.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
    }];
    
    self.scuessDes1 = [[UILabel alloc]init];
    self.scuessDes1.textColor = DefaultGrayTextClor;
    self.scuessDes1.font = FontNameAndSize(14);
    self.scuessDes1.numberOfLines = 0;
    self.scuessDes1.textAlignment  =NSTextAlignmentCenter;
    [self.view addSubview:self.scuessDes1];
    [self.scuessDes1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scuessDes.mas_bottom).mas_equalTo(5);
        make.left.right.mas_equalTo(0);
    }];
 
}

- (UIButton *)yuyueOrder
{
    if (!_yuyueOrder) {
        _yuyueOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yuyueOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yuyueOrder.backgroundColor = AppStyleColor;
        _yuyueOrder.titleLabel.font = Font(20);
    }
    return _yuyueOrder;
}

- (UIButton *)scanOrder
{
    if (!_scanOrder) {
        _scanOrder = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanOrder setTitle:@"查看订单" forState:UIControlStateNormal];
        [_scanOrder setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _scanOrder.backgroundColor = [UIColor whiteColor];
        _scanOrder.titleLabel.font = Font(20);
    }
    return _scanOrder;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self setRightNavigationItemWithTitle:@"完成" action:@selector(back)];
    [self refreshWithPage];
  
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
    // Do any additional setup after loading the view.
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    TJOrderDetailModel *model = responsObject;
    self.serviceType.text = model.name;
    self.id = model.id;
        NSRange range = {3,4};
    self.scuessDetail.text = [NSString stringWithFormat:@"服务对象:%@(%@)",model.patientname, [model.patientphone stringByReplacingCharactersInRange:range withString:@"****"]];
    
    if ([model.nojg isEqualToString:@"0"]) {
        [self.view addSubview:self.scanOrder];
        [self.view addSubview:self.yuyueOrder];
        [self.yuyueOrder setTitle:@"联系客服" forState:UIControlStateNormal];
        [self.scanOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(50);
        }];
        
        [self.yuyueOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.scanOrder.mas_right);
            make.height.mas_equalTo(self.scanOrder.mas_height);
        }];
        [self.yuyueOrder addTarget:self action:@selector(tochat) forControlEvents:UIControlEventTouchUpInside];
        [self.scanOrder addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
        self.scuessDes1.text = @"您的订单已提交成功，客服人员会在24小时内和您确认，请您保持电话畅通哦。直医客服热线：400-900-1169.";

    }else{
        [self.yuyueOrder setTitle:@"体检预约" forState:UIControlStateNormal];
        self.scuessDes1.text = @"在体检之前在APP进行预约，会有更好的服务体验哦";
        [self.view addSubview:self.scanOrder];
        [self.view addSubview:self.yuyueOrder];
        [self.scanOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(50);
        }];
        
        [self.yuyueOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.scanOrder.mas_right);
            make.height.mas_equalTo(self.scanOrder.mas_height);
        }];
        [self.yuyueOrder addTarget:self action:@selector(yuyue) forControlEvents:UIControlEventTouchUpInside];
        [self.scanOrder addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    }

}
- (void)back{
    [Utils jumpToHomepage];
}

- (void)tochat{
    UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
    //设置头像
    [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
    [manager pushUdeskInViewController:self completion:nil];
    //点击留言回调
    [manager leaveMessageButtonAction:^(UIViewController *viewController){
        [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
            NSLog(@"客服用户自定义字段：%@",responseObject);
        }];
        UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
        [viewController presentViewController:offLineTicket animated:YES completion:nil];
    }];
}
- (void)yuyue{
    ToSubsViewController *tosusbs = [[ToSubsViewController alloc]init];
    tosusbs.orderEnter = YES;
    [self.navigationController pushViewController:tosusbs animated:YES];
}
- (void)scan{
    
    MyOrderViewController *order = [MyOrderViewController new];
    order.orderEnter = YES;
    order.title  = @"我的订单";
    [self.navigationController pushViewController:order animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
