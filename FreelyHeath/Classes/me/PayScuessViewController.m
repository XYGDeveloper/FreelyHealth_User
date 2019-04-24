//
//  PayScuessViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PayScuessViewController.h"
#import "MyOrderViewController.h"
#import "SDetailViewController.h"
#import "AppionmentListViewController.h"
#import "AuditedViewController.h"
#import "AppionmentDetailViewController.h"
@interface PayScuessViewController ()
@property (nonatomic,strong)UIButton *detailButton;
@property (nonatomic,strong)UIButton *orderButton;

@end

@implementation PayScuessViewController

- (IBAction)scanOrder:(id)sender {
    if (self.aEnter == YES) {
        AppionmentListViewController *order = [AppionmentListViewController new];
        order.orderStatus = @"1";
        order.title  = @"会诊请求";
        [self.navigationController pushViewController:order animated:YES];
    }else{
        MyOrderViewController *order = [MyOrderViewController new];
        order.orderEnter = YES;
        order.title  = @"我的订单";
        [self.navigationController pushViewController:order animated:YES];
    }
   
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scanOrder.layer.cornerRadius = 4;
    
    self.scanOrder.layer.borderWidth = 1;
    
    self.scanOrder.layer.borderColor = AppStyleColor.CGColor;
    
    self.scanOrder.layer.masksToBounds = YES;
    self.serviceType.text = self.service;
    self.serviceType.font = FontNameAndSize(18);
    self.serviceObj.font = FontNameAndSize(12);
    self.serviceObj.text = [NSString stringWithFormat:@"服务对象:%@(%@)",self.name,self.phone];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    if (self.aEnterHZ == YES) {
        self.scanOrder.hidden = YES;
        [self setRightNavigationItemWithTitle:nil action:nil];
        
        UIView *contentview = [[UIView alloc]init];
        [self.view addSubview:contentview];
        [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(45);
        }];
        self.detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.detailButton.backgroundColor = [UIColor whiteColor];
        [self.detailButton setTitle:@"查看订单详情" forState:UIControlStateNormal];
        [self.detailButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        self.detailButton.titleLabel.font  =FontNameAndSize(16);
        [contentview addSubview:self.detailButton];
        self.orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.orderButton.backgroundColor = AppStyleColor;
        [self.orderButton setTitle:@"查看会诊详情" forState:UIControlStateNormal];
        [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.orderButton.titleLabel.font  = FontNameAndSize(16);
        [contentview addSubview:self.orderButton];
        
        [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(45);
        }];
        [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(45);
        }];
        
        UIView *sepview = [[UIView alloc]init];
        sepview.backgroundColor = HexColor(0xe7e7e9);
        [contentview addSubview:sepview];
        [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        [self.detailButton addTarget:self action:@selector(scanOrderaction) forControlEvents:UIControlEventTouchUpInside];
        [self.orderButton addTarget:self action:@selector(setScanHZdetail) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.scanOrder.hidden = NO;
        [self setRightNavigationItemWithTitle:@"完成" action:@selector(finish)];
    }
}

- (void)scanOrderaction{
    
    MyOrderViewController *order = [MyOrderViewController new];
    order.orderEnter = YES;
    order.title  = @"我的订单";
    [self.navigationController pushViewController:order animated:YES];
    
}

- (void)back{
    [Utils jumpToHomepage];
}


- (void)finish{

    [[NSNotificationCenter defaultCenter]postNotificationName:KNotification_RefreshList object:nil];
    
    [Utils jumpToHomepage];
    
}

- (void)setScanHZdetail{
    AppionmentDetailViewController *huizhen = [AppionmentDetailViewController new];
    huizhen.id = self.hzid;
    huizhen.title = @"会诊详情";
    [self.navigationController pushViewController:huizhen animated:YES];
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
