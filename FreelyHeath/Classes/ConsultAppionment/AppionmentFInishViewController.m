//
//  AppionmentFInishViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentFInishViewController.h"
#import "TeamListTableViewCell.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "RemarksCellHeightModel.h"
#import "RemarksTableViewCell.h"
#import "AppionmentInfoTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "AppionmentChatTableViewCell.h"
#import "FriendCircleCell.h"
#import "AppionmentListRequest.h"
#import "AppionmentListDetailModel.h"
#import "AppionmentListDetailApi.h"
#import "AppionmentDetailDesTableViewCell.h"
#import "DotorDetailViewController.h"

@interface AppionmentFInishViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)AppionmentListDetailApi *api;
@property (nonatomic,strong)AppionmentListDetailModel *model;
@property (nonatomic,strong)NSArray *members;

@end

@implementation AppionmentFInishViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorColor = [UIColor whiteColor];
        _tableview.backgroundColor =DefaultBackgroundColor;
    }
    return _tableview;
}

- (AppionmentListDetailApi *)api{
    if (!_api) {
        _api = [[AppionmentListDetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeHudFromView:self.view];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    self.model = responsObject;
    self.members = [AppionmentDetailModel mj_objectArrayWithKeyValuesArray:self.model.members];
    [self.tableview reloadData];
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 67.5)];
        _headerView.backgroundColor = DefaultBackgroundColor;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51.5)];
        bgView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:bgView];
        UILabel *label = [[UILabel alloc]init];
        label.textColor = AppStyleColor;
        label.text = @"会诊意见书";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = FontNameAndSize(16);
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(30);
        }];
        UIImageView *img = [[UIImageView alloc]init];
        [bgView addSubview:img];
        img.image = [UIImage imageNamed:@"agreebook"];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(label.mas_right);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(12);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
    }
    return _headerView;
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
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return self.model.members.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 135;
    } else if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class]) cacheByIndexPath:indexPath configuration:^(AppionmentDetailDesTableViewCell *cell) {
            [cell refreshWIithDetailModel:self.model];
        }];
    } else if(indexPath.section == 2) {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([FriendCircleCell class]) cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
            [cell cellDataWithAppionmentModel:self.model];
        }];
    }else if(indexPath.section == 3) {
        return 75;
    }else{
        return 94;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        AppionmentInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWIithDetailModel:self.model];
        return cell;
    } else if(indexPath.section == 1) {
        AppionmentDetailDesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWIithDetailModel:self.model];
        return cell;
    } else  if(indexPath.section ==2) {
        FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCircleCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        [cell cellDataWithAppionmentModel:self.model];
        return cell;
    }else  if(indexPath.section == 3) {
        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticeTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:self.model];
        return cell;
    }else{
        TeamListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *sep = [UIView new];
        sep.backgroundColor = DefaultBackgroundColor;
        [cell addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.0);
        }];
        AppionmentDetailModel *model = [self.members objectAtIndex:indexPath.row];
        [cell refreshWithAppionmentModel:model];
        NSLog(@"%@",model.dname);
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4){
        AppionmentDetailModel *model = [self.members objectAtIndex:indexPath.row];
        if ([model.dname isEqualToString:@"直医客服"]) {
            [self toCustomer];
        }else{
            DotorDetailViewController *doctor = [[DotorDetailViewController alloc]init];
            doctor.title = @"医生详情";
            doctor.ID = model.id;
            //        doctor.chatID = self.model.chatid;
            [self.navigationController pushViewController:doctor animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 4) {
            return 51;
        }else{
            return 0;
        }
    } else {
        if (section == 4) {
            return 51;
        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (section == 3) {
            return 10;
        }else{
            return 0;
        }
    } else {
        if (section == 3) {
            return 10;
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
        UIView *sep = [UIView new];
        sep.backgroundColor = DefaultBackgroundColor;
        [contentView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.5);
        }];
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
        UIView *sep = [UIView new];
        sep.backgroundColor = DefaultBackgroundColor;
        [contentView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.5);
        }];
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
    self.view.backgroundColor = DefaultBackgroundColor;
    AppionmentListHeader *head = [[AppionmentListHeader alloc]init];
    head.target = @"userHuizhenControl";
    head.method = @"userHuizhenDetail";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    AppionmentListBody *body = [[AppionmentListBody alloc]init];
    body.type = self.type;
    body.id = self.id;
    AppionmentListRequest *request = [[AppionmentListRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api getAppionmentListDetail:request.mj_keyValues.mutableCopy];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self layOut]; 
    [self.tableview registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableview registerClass:[AppionmentDetailDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
    [self.tableview registerClass:[AppionmentInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
    [self.tableview registerClass:[NoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    [self.tableview registerClass:[AppionmentChatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
    [self.tableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
//    self.tableview.tableFooterView = self.footView;
//    self.tableview.tableHeaderView = self.headerView;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
