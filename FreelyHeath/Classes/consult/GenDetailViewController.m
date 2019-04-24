//
//  GenDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/9/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GenDetailViewController.h"
#import "CustomerViewController.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "SecondModel.h"
#import "PhyicalModel.h"
#import "MedicalFillOrderViewController.h"
#import "UIImage+GradientColor.h"
@interface GenDetailViewController ()

@property (nonatomic,strong)UIButton *serviceButton;

@end

@implementation GenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.name;
    self.serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.serviceButton];
    self.serviceButton.backgroundColor = Customer_Color;
    [self.serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = DividerDarkGrayColor;
        [self.serviceButton addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
   
    if ([self.model.pay isEqualToString:@"1"]) {
        [self.serviceButton setTitle:@"立即下单" forState:UIControlStateNormal];
        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        [self.serviceButton setBackgroundImage:bgImg forState:UIControlStateNormal];
        [self.serviceButton addTarget:self action:@selector(toOrder) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.serviceButton.backgroundColor = [UIColor whiteColor];
        [self.serviceButton setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
        [self.serviceButton setTitle:@"    联系客服" forState:UIControlStateNormal];
        self.serviceButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:2];
        [self.serviceButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [self.serviceButton addTarget:self action:@selector(toRelateService) forControlEvents:UIControlEventTouchUpInside];
        self.serviceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    
}

- (void)toRelateService{

    UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
    
    [UdeskManager setupCustomerOnline];
    
    //设置头像
    [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
    
    [manager pushUdeskInViewController:self completion:nil];
    //点击留言回调
    [manager leaveMessageButtonAction:^(UIViewController *viewController){
        
        UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
        [viewController presentViewController:offLineTicket animated:YES completion:nil];
        
    }];

}


- (void)toOrder{
    MedicalFillOrderViewController *fill = [MedicalFillOrderViewController new];
    fill.id = self.model.id;
    fill.name = self.model.name;
    [self.navigationController pushViewController:fill animated:YES];
    
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
