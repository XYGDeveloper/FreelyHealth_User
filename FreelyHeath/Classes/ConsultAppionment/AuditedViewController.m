//
//  AuditedViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AuditedViewController.h"
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
#import "ConversationViewController.h"
@interface AuditedViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)AppionmentListDetailApi *api;
@property (nonatomic,strong)AppionmentListDetailModel *model;
@property (nonatomic,strong)NSArray *members;

@end

@implementation AuditedViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorColor = [UIColor whiteColor];
        _tableview.backgroundColor = DefaultBackgroundColor;
    }
    return _tableview;
}

-(AppionmentListDetailApi *)api{
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
//    for (AppionmentDetailModel *model in self.members) {
//            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:model.id name:model.dname portrait:model.dfacepath];
//        [[RCIM sharedRCIM] setCurrentUserInfo:info];
//    }
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[User LocalUser].name portrait:[User LocalUser].facepath];
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [self.tableview reloadData];
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
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 5) {
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
        return 95;
    }else if(indexPath.section == 4) {
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
    } else  if(indexPath.section ==3) {
        AppionmentChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else  if(indexPath.section == 4) {
        NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoticeTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithModel:self.model];
        return cell;
    }else{
        TeamListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class])];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        AppionmentDetailModel *model = [self.members objectAtIndex:indexPath.row];
        [cell refreshWithAppionmentModel:model];
        NSLog(@"%@",model.dname);
        UIView *sep = [UIView new];
        sep.backgroundColor = DefaultBackgroundColor;
        [cell addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1.0);
        }];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 5) {
            return 51;
        }else{
            return 0;
        }
    } else {
        if (section == 5) {
            return 51;
        }else{
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (section == 4) {
            return 10;
        }else{
            return 0;
        }
    } else {
        if (section == 4) {
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
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
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
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        //
        NSLog(@"%@",[User LocalUser].id);
//        [[RCCall sharedRCCall] startSingleCall:@"ddd89e6c5c2b11e88e9000163e00b3a0" mediaType:RCCallMediaVideo];
//        NSMutableArray *list = [NSMutableArray array];
//        for (AppionmentDetailModel *model in self.members) {
//            [list addObject:model.id];
//        }
//        [[RCCall sharedRCCall] startMultiCallViewController:ConversationType_GROUP targetId:self.model.mdtgroupid mediaType:RCCallMediaVideo userIdList:list];
        if (self.model.mdtgroupid && [self.model.jinru isEqualToString:@"1"]) {
            ConversationViewController*conversation = [[ConversationViewController alloc]initWithConversationType:ConversationType_GROUP targetId:self.model.mdtgroupid];
            conversation.displayUserNameInCell = YES;
            conversation.enableNewComingMessageIcon = YES; //开启消息提醒
            conversation.enableUnreadMessageIcon = YES;
            [self.navigationController pushViewController:conversation animated:YES];
        }else{
            [Utils postMessage:@"暂时不能进行会诊，请关注会诊时间和会诊消息通知" onView:self.view];
        }
        
    }else if (indexPath.section == 5){
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    if ([userId isEqualToString:[User LocalUser].id]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].name portrait:[User LocalUser].facepath]);
    }else{
        for (AppionmentDetailModel *model in self.members) {
            RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:model.id name:model.dname portrait:model.dfacepath];
            completion(user);
        }
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    
    if ([groupId isEqualToString:self.model.mdtgroupid]) {
        RCGroup *userInfo = [[RCGroup alloc]init];
        userInfo.groupId = self.model.mdtgroupid;
        userInfo.groupName = @"会诊群";
        userInfo.portraitUri = @"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/90f4ee8723b24ea08fe85915dad7c7b7.jpg";
        return completion(userInfo);
    }
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    if ([groupId isEqualToString:self.model.mdtgroupid]) {
        for (AppionmentDetailModel *model in self.members) {
            RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:model.id name:model.dname portrait:model.dfacepath];
                [ret addObject:user.userId];
        }
    }
    resultBlock(ret);
}

- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    NSLog(@"%@",userInfo);
}

@end
