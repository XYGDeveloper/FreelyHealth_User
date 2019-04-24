//
//  CommitApplyViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CommitApplyViewController.h"
#import "AppiontmentTopTableViewCell.h"
#import "AppionmentBottomTableViewCell.h"
#import "CommitApplyModel.h"
#import "AppointmentViewController.h"
#import "WKWebViewController.h"
@interface CommitApplyViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *buttonBgview;
@property (nonatomic,strong)UIButton *agreeButton;
@property (nonatomic,strong)UIButton *skanAgreeButton;
@property (nonatomic,strong)UIButton *commitApply;
@property (nonatomic,strong)CommitApplyModel *model;
@property (nonatomic,assign)BOOL select;

@end

@implementation CommitApplyViewController

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

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
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    [self.buttonBgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(50);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(14);
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
    [agree loadWebURLSring:[NSString stringWithFormat:@"%@?token=%@",tovalute_URL,[User LocalUser].token]];
    NSLog(@"%@",[NSString stringWithFormat:@"%@?token=%@",tovalute_URL,[User LocalUser].token]);
    agree.hidesBottomBarWhenPushed = YES;
    agree.title = @"评估";
    [self.navigationController pushViewController:agree animated:YES];
}

- (void)toFillAppment{
    if (self.agreeButton.selected == NO) {
        [Utils postMessage:@"请先同意网络会诊协议" onView:self.view];
        return;
    }
    AppointmentViewController *appionment = [AppointmentViewController new];
    appionment.teamid = self.teamId;
    appionment.teamMember = self.teamMember;
    appionment.title = @"专家会诊";
    [self.navigationController pushViewController:appionment animated:YES];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AppiontmentTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppiontmentTopTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refeshWIthModel:self.model];
        return cell;
    }else{
        AppionmentBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentBottomTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refeshWIthModel:self.model];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AppiontmentTopTableViewCell class]) cacheByIndexPath:indexPath configuration:^(AppiontmentTopTableViewCell *cell) {
            [cell refeshWIthModel:self.model];
        }];
    }else{
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AppionmentBottomTableViewCell class]) cacheByIndexPath:indexPath configuration:^(AppionmentBottomTableViewCell *cell) {
            [cell refeshWIthModel:self.model];
        }];
    }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.tableview registerClass:[AppiontmentTopTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppiontmentTopTableViewCell class])];
    [self.tableview registerClass:[AppionmentBottomTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentBottomTableViewCell class])];
    [self.view addSubview:self.tableview];
    [self.view addSubview:self.buttonBgview];
    [self.buttonBgview addSubview:self.agreeButton];
    [self.buttonBgview addSubview:self.skanAgreeButton];
    [self.view addSubview:self.commitApply];
    [self layOutsubviews];
    self.select = NO;
    NSLog(@"%d",self.select);
    CommitApplyModel *model = [[CommitApplyModel alloc]init];
    model.topImage = @"http://chuantu.biz/t6/293/1524554594x-1404793555.png";
    model.des = @"建立视频会诊平台，通过视频影像系统连接日本专家与国内患者，做到医生与患者、患者家属面对面沟通，会诊，给出会诊意见。从而解答患者及家属对于当前病情的疑问。并且根据医生的专业判断，决定后期的治疗方向。";
    model.detailkDes = @"1、发起会诊预约\n2、阅读<网络会诊咨询服务协议>\n3、填写添加病历，输入相关信息、上传有关病情图片。确认病情相关信息和手机号码填写无误后保存病历\n4、填写患者信息,电话号码,会诊诉求\n5、提交预约,并支付\n6、等待审核预约信息，审核期间工作人员会分别跟专家和用户进行沟通，在此期间用户需保持手机保持可以";
    self.model = model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
