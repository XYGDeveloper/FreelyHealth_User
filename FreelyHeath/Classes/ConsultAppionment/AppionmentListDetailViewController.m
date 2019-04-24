//
//  AppionmentListDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentListDetailViewController.h"
#import "TeamListTableViewCell.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
@interface AppionmentListDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIView *headerView;
@end

@implementation AppionmentListDetailViewController

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
    }
    return _tableview;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 94)];
        _footView.backgroundColor = [UIColor whiteColor];
        UIImageView *customerImage = [[UIImageView alloc]init];
        customerImage.userInteractionEnabled = YES;
        [_footView addSubview:customerImage];
        [customerImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"Logo"]];
        [customerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_footView.mas_centerY);
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(60);
        }];
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.userInteractionEnabled = YES;
        nameLabel.textColor = DefaultBlackLightTextClor;
        nameLabel.font = FontNameAndSize(15);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.text = @"直医客服";
        [_footView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(customerImage.mas_centerY);
            make.left.mas_equalTo(customerImage.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(20);
        }];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toCustomer)];
    [_footView addGestureRecognizer:tap];
    return _footView;
}

- (void)toCustomer{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TeamListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class])];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 51;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return 51;
        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return 51;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return nil;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 15, kScreenWidth - 16.5, 20)];
        label.textColor = DefaultBlackLightTextClor;
        label.font = FontNameAndSize(16);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"参会人员";
        [contentView addSubview:label];
        return contentView;
    } else {
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
        contentView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 15, kScreenWidth - 16.5, 20)];
        label.textColor = DefaultBlackLightTextClor;
        label.font = FontNameAndSize(16);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"参会人员";
        [contentView addSubview:label];
        return contentView;
    }
}
- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self layOut];
    [self.tableview registerClass:[TeamListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];
    self.tableview.tableFooterView = self.footView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
