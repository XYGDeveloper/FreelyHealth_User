//
//  WailtToPayViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WailtToPayViewController.h"
#import "TeamListTableViewCell.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "RemarksCellHeightModel.h"
#import "RemarksTableViewCell.h"
#import "AppionmentInfoTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "AppionmentChatTableViewCell.h"
#import "FriendCircleCell.h"
#import "WailtToPayNoticeTableViewCell.h"
#import "AppionmentPriceTableViewCell.h"
#import "AppionmentListRequest.h"
#import "AppionmentListDetailModel.h"
#import "AppionmentListDetailApi.h"
#import "CancelAppionmentApi.h"
#import "AlertView.h"
#define kFetchTag 7000
#import "PayModeViewController.h"
#import "TunorDetail.h"
#import "AppionmentDetailDesTableViewCell.h"
@interface WailtToPayViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)AppionmentListDetailApi *api;//会诊详情
@property (nonatomic,strong)CancelAppionmentApi *cancelapi;//取消会诊
@property (nonatomic,strong)AppionmentListDetailModel *model;
@end

@implementation WailtToPayViewController

- (AppionmentListDetailApi *)api{
    if (!_api) {
        _api = [[AppionmentListDetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (CancelAppionmentApi *)cancelapi{
    if (!_cancelapi) {
        _cancelapi = [[CancelAppionmentApi alloc]init];
        _cancelapi.delegate = self;
    }
    return _cancelapi;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [Utils removeHudFromView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    if (api == _api) {
        self.model = responsObject;
        [self.tableview reloadData];
    }
    if (api == _cancelapi) {
        [Utils removeHudFromView:self.view];
        [Utils postMessage:command.response.msg onView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAppionment" object:nil];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
        return 105;
    }else{
        return 129;
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
        WailtToPayNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell refreshWithAppionmentDetailModel:self.model];
        return cell;
    }else{
        AppionmentPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentPriceTableViewCell class])];
        [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *sep = [UIView new];
        sep.backgroundColor = DefaultBackgroundColor;
        [cell addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.top.mas_equalTo(0);
            make.height.mas_equalTo(1.0);
        }];
        [cell refreshWithAppionmentDetailModel:self.model];
        cell.cancel = ^{
            NSString *content = @"确认要取消会议吗";
            [self showScanMessageTitle:nil  content:content leftBtnTitle:@"不取消" rightBtnTitle:@"确认取消" tag:kFetchTag];
        };
        cell.pay = ^{
            PayModeViewController *pay = [[PayModeViewController alloc]init];
            pay.HZid = self.model.id; 
            TunorDetail *model = [[TunorDetail alloc]init];
            model.name = @"会诊服务";
            model.datailo = self.model.huizhenprice;
            pay.model = model;
            pay.HZid = self.model.id;
            pay.title = @"提交订单";
            [self.navigationController pushViewController:pay animated:YES];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return 0;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return 0;
    } else {
        return 0;
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
      
        return nil;
    } else {
 
        return nil;
    }
}
- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self layOut];
    [self.tableview registerClass:[TeamListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableview registerClass:[AppionmentDetailDesTableViewCell
 class] forCellReuseIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
    [self.tableview registerClass:[AppionmentInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
    [self.tableview registerClass:[NoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    [self.tableview registerClass:[AppionmentChatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
    [self.tableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
    [self.tableview registerClass:[WailtToPayNoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
    [self.tableview registerClass:[AppionmentPriceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentPriceTableViewCell class])];
    self.tableview.tableFooterView = self.footView;
    
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"确认取消"]) {
            [Utils addHudOnView:self.view];
            AppionmentListHeader *head = [[AppionmentListHeader alloc]init];
            head.target = @"userHuizhenControl";
            head.method = @"cancelHuizhenYuyue";
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
            [self.cancelapi cancelAppionment:request.mj_keyValues.mutableCopy];
        }else{
            
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
