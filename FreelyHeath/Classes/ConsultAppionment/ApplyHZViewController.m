//
//  ApplyHZViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ApplyHZViewController.h"
#import "AppointmentViewController.h"
@interface ApplyHZViewController ()
@property (nonatomic,strong)UIView *buttonBgview;
@property (nonatomic,strong)UIButton *agreeButton;
@property (nonatomic,strong)UIButton *skanAgreeButton;
@property (nonatomic,strong)UIButton *commitApply;
@property (nonatomic,assign)BOOL select;

@end

@implementation ApplyHZViewController

- (UIButton *)agreeButton{
    if (!_agreeButton) {
        _agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeButton setImage:[UIImage imageNamed:@"appionment_agree_nomal"] forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"appionment_agree_selec"] forState:UIControlStateSelected];
        [_agreeButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _agreeButton.backgroundColor = [UIColor whiteColor];
        [_agreeButton addTarget:self action:@selector(toChoose) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}

- (UIButton *)skanAgreeButton{
    if (!_skanAgreeButton) {
        _skanAgreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skanAgreeButton setTitle:@"网络会诊协议" forState:UIControlStateNormal];
        _skanAgreeButton.titleLabel.font = Font(14);
        [_skanAgreeButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _skanAgreeButton.backgroundColor = [UIColor whiteColor];
        [_skanAgreeButton addTarget:self action:@selector(toRead) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skanAgreeButton;
}

- (UIButton *)commitApply{
    if (!_commitApply) {
        _commitApply = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitApply setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_commitApply setTitle:@"提交申请" forState:UIControlStateNormal];
        _commitApply.titleLabel.font = Font(14);
        [_commitApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitApply.backgroundColor = AppStyleColor;
        [_commitApply addTarget:self action:@selector(toFillAppment) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commitApply;
}

- (UIView *)buttonBgview{
    if (!_buttonBgview) {
        _buttonBgview = [[UIView alloc]init];
        _buttonBgview.backgroundColor = [UIColor whiteColor];
    }
    return _buttonBgview;
}

- (void)layOutsubviews{
  
    [self.buttonBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(50);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.buttonBgview.mas_centerY);
    }];
    [self.skanAgreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.buttonBgview.mas_centerY);
        make.left.mas_equalTo(self.agreeButton.mas_right).mas_equalTo(10);
        make.height.mas_equalTo(40);
    }];
    [self.commitApply mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.buttonBgview.mas_right);
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(self.buttonBgview.mas_height);
    }];
    
}

- (void)toChoose{
    self.agreeButton.selected = !self.agreeButton.selected;
    if (self.agreeButton.selected == YES) {
            self.select = YES;
    }else{
            self.select = NO;
     
    }
}

- (void)toRead{
    //temp
    WKWebViewController *agree = [WKWebViewController new];
    [agree loadWebHTMLSring:@"agreement"];
    agree.hidesBottomBarWhenPushed = YES;
    agree.title = @"会诊协议";
    [self.navigationController pushViewController:agree animated:YES];
}

- (void)toFillAppment{
    if (self.agreeButton.selected == NO) {
        [Utils postMessage:@"请先同意网络会诊协议" onView:self.view];
        return;
    }
    AppointmentViewController *appionment = [AppointmentViewController new];
    appionment.isLSTD = self.isLSTD;
    appionment.teamid = self.teamId;
    appionment.teamMember = self.teamMember;
    appionment.title = @"专家会诊";
    [self.navigationController pushViewController:appionment animated:YES];
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.buttonBgview];
    [self.buttonBgview addSubview:self.agreeButton];
    self.agreeButton.alpha = 0.8;
    [self.buttonBgview addSubview:self.skanAgreeButton];
    [self.view addSubview:self.commitApply];
    [self layOutsubviews];
    self.select = NO;
    NSLog(@"%d",self.select);
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
