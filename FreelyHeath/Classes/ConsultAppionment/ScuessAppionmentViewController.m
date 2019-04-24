//
//  ScuessAppionmentViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ScuessAppionmentViewController.h"
#import "AppionmentDetailViewController.h"
#import "AppionmentListViewController.h"
@interface ScuessAppionmentViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *scuessLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UIButton *sckanButton;

@end

@implementation ScuessAppionmentViewController

- (UIImageView *)img{
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.backgroundColor = [UIColor clearColor];
    }
    return _img;
}

- (UILabel *)scuessLabel{
    if (!_scuessLabel) {
        _scuessLabel = [[UILabel alloc]init];
        _scuessLabel.backgroundColor = [UIColor clearColor];
        _scuessLabel.textColor = DefaultBlackLightTextClor;
        _scuessLabel.font = FontNameAndSize(22.5);
        _scuessLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scuessLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 0;
        _detailLabel.textColor = DefaultGrayTextClor;
        _detailLabel.font = FontNameAndSize(14);
    }
    return _detailLabel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = [UIColor whiteColor];
        _backButton.layer.cornerRadius = 4;
        _backButton.layer.masksToBounds = YES;
        [_backButton setTitle:@"返回首页" forState:UIControlStateNormal];
        _backButton.titleLabel.font = FontNameAndSize(16);
        [_backButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _backButton.layer.borderWidth = 1;
        _backButton.layer.borderColor = AppStyleColor.CGColor;
    }
    return _backButton;
}

- (UIButton *)sckanButton{
    if (!_sckanButton) {
        _sckanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sckanButton.backgroundColor = AppStyleColor;
        _sckanButton.layer.cornerRadius = 4;
        _sckanButton.layer.masksToBounds = YES;
        _sckanButton.titleLabel.font = FontNameAndSize(16);
        [_sckanButton setTitle:@"查看请求" forState:UIControlStateNormal];
        [_sckanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sckanButton;
}

- (void)refresh{
    self.view.backgroundColor = [UIColor whiteColor];
    self.img.image = [UIImage imageNamed:@"alipay"];
    [self.view addSubview:self.img];
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(131-64);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(97);
    }];
    
    self.scuessLabel.text = @"提交成功";
    [self.view addSubview:self.scuessLabel];
    [self.scuessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.img.mas_bottom).mas_equalTo(34.5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(21);
    }];
    NSString *_test  = @"客服将会在3个工作日内与你联系,请你保持电话畅通哦。直医客服电话热线:400-900-1169。";
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;
    paraStyle01.headIndent = 0.0f;
    CGFloat emptylen = self.detailLabel.font.pointSize * 0;
    paraStyle01.firstLineHeadIndent = emptylen;
    paraStyle01.tailIndent = 0.0f;
    paraStyle01.lineSpacing = 2.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    self.detailLabel.attributedText = attrText;
    self.detailLabel.userInteractionEnabled = YES;
     UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(call)];
    [self.detailLabel addGestureRecognizer:tap];
    [self.view addSubview:self.detailLabel];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scuessLabel.mas_bottom).mas_equalTo(27.5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenWidth - 80);
        make.height.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.sckanButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_equalTo(43);
        make.left.mas_equalTo(self.detailLabel.mas_left);
        make.width.mas_equalTo((kScreenWidth - 95)/2);
        make.height.mas_equalTo(40);
    }];
    [self.sckanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_equalTo(43);
        make.right.mas_equalTo(self.detailLabel.mas_right);
        make.width.mas_equalTo((kScreenWidth - 95)/2);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)call{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"拔打：400-900-1169" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-900-1169"]];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self refresh];
    [self.backButton addTarget:self action:@selector(backToindex) forControlEvents:UIControlEventTouchUpInside];
    [self.sckanButton addTarget:self action:@selector(toOrder) forControlEvents:UIControlEventTouchUpInside];

}

- (void)backToindex{
    [Utils jumpToHomepage];
}

- (void)toOrder{
    AppionmentDetailViewController *detail = [AppionmentDetailViewController new];
    detail.id = self.id;
    detail.title = @"会诊详情";
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)back{
    if (self.isenter == YES) {
        [Utils jumpToHomepage];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
