//
//  AppionmentDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentDetailViewController.h"
#import "AppionmentInfoTableViewCell.h"
#import "AppionmentDetailDesTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "FriendCircleCell.h"
#import "CancelAppionmentTableViewCell.h"
#import "WailtToPayNoticeTableViewCell.h"
#import "AppionmentPriceTableViewCell.h"
#import "AppionmentChatTableViewCell.h"
#import "TeamListTableViewCell.h"
#import "AppionmentListRequest.h"
#import "AppionmentListDetailModel.h"
#import "AppionmentListDetailApi.h"
#import "CancelAppionmentApi.h"
#import "AlertView.h"
#import "PayModeViewController.h"
#define kFetchTag 7000
#import "TunorDetail.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "ConversationViewController.h"
#import "DotorDetailViewController.h"
#import "queryIsHaveApi.h"
#import "QueryIsExitAgreeBookRequest.h"
#import "AgreeBookModel.h"
#import "scanAgreebookViewController.h"
@interface AppionmentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)AppionmentListDetailApi *api;//会诊详情
@property (nonatomic,strong)CancelAppionmentApi *cancelapi;//取消会诊
@property (nonatomic,strong)AppionmentListDetailModel *model;
@property (nonatomic,strong)queryIsHaveApi *ishave;

@property (nonatomic,strong)NSArray *members;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIView *headerView;

@end

@implementation AppionmentDetailViewController

- (queryIsHaveApi *)ishave{
    if (!_ishave) {
        _ishave = [[queryIsHaveApi alloc]init];
        _ishave.delegate = self;
    }
    return _ishave;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    AppionmentListHeader *head = [[AppionmentListHeader alloc]init];
    head.target = @"userHuizhenControl";
    head.method = @"userHuizhenDetail";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    AppionmentListBody *body = [[AppionmentListBody alloc]init];
    body.id = self.id;
    AppionmentListRequest *request = [[AppionmentListRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.api getAppionmentListDetail:request.mj_keyValues.mutableCopy];
}

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
        self.members = [AppionmentDetailModel mj_objectArrayWithKeyValuesArray:self.model.members];
        QGBHeader *header = [[QGBHeader alloc]init];
        header.target = @"userHuizhenControl";
        header.method = @"queryHuizhenResult";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        QGBBody *bodyer = [[QGBBody alloc]init];
        bodyer.id = self.model.id;
        QueryIsExitAgreeBookRequest *requester = [[QueryIsExitAgreeBookRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.ishave quqryAgreebook:requester.mj_keyValues.mutableCopy];
        
        [self.tableview reloadData];
    }
    if (api == _cancelapi) {
        [Utils postMessage:command.response.msg onView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelAppionment" object:nil];
    }
    
    if (api == _ishave) {
        NSLog(@"%@",responsObject);
        AgreeBookModel *model = responsObject;
        if (model.diagnose.length <= 0) {
            self.tableview.tableHeaderView = nil;
        }else{
            self.tableview.tableHeaderView = self.headerView;
        }
    }
    
    //    for (AppionmentDetailModel *model in self.members) {
    //            RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:model.id name:model.dname portrait:model.dfacepath];
    //        [[RCIM sharedRCIM] setCurrentUserInfo:info];
    //    }
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[User LocalUser].name portrait:[User LocalUser].facepath];
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [self.tableview reloadData];
    
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorColor = [UIColor whiteColor];
    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.model.status isEqualToString:@"1"]) {
        return 5;
    }else if([self.model.status isEqualToString:@"2"]){
        return 5;
    }else if([self.model.status isEqualToString:@"3"]){
        return 6;
    }else{
        return 5;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.model.status isEqualToString:@"1"]) {
        return 1;
    }else if([self.model.status isEqualToString:@"2"]){
        return 1;
    }else  if([self.model.status isEqualToString:@"3"]){
        if (section == 5) {
            return self.model.members.count;
        }else{
            return 1;
        }
    }else{
                if (section == 4) {
                    return self.model.members.count;
                }else{
                    return 1;
                }
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.status isEqualToString:@"1"]) {
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
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(WailtToPayNoticeTableViewCell *cell) {
                [cell refreshWithAppionmentDetailModel:self.model];
            }];
        }else{
            return 160;
        }
    }else if ([self.model.status isEqualToString:@"2"]) {
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
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(WailtToPayNoticeTableViewCell *cell) {
                [cell refreshWithAppionmentDetailModel:self.model];
            }];
        }else{
            return 129;
        }
    } else  if ([self.model.status isEqualToString:@"3"]){
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
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(WailtToPayNoticeTableViewCell *cell) {
                [cell refreshWithAppionmentDetailModel:self.model];
            }];
        }else{
            return 94;
        }
    }else{
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
                    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(WailtToPayNoticeTableViewCell *cell) {
                        [cell refreshWithAppionmentDetailModel:self.model];
                    }];
                }else{
                    return 94;
                }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if ([self.model.status isEqualToString:@"3"]) {
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
    }else if ([self.model.status isEqualToString:@"4"]){
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
    }else{
        if (@available(iOS 11.0, *)) {
            return 0.00001;
        } else {
            return 0.00001;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
 
    if ([self.model.status isEqualToString:@"3"] || [self.model.status isEqualToString:@"4"]) {
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
    }else{
        if (@available(iOS 11.0, *)) {
            return 0.00001;
        } else {
            return 0.00001;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.model.status isEqualToString:@"3"]) {
        if (@available(iOS 11.0, *)) {
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
            contentView.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 15, kScreenWidth - 16.5, 20)];
            label.textColor = DefaultBlackLightTextClor;
            label.font = FontNameAndSize(16);
            label.textAlignment = NSTextAlignmentLeft;
            if (self.model.members.count <= 0) {
                label.text = @"";

            }else{
                label.text = @"参会人员";

            }
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
            if (self.model.members.count <= 0) {
                label.text = @"";
                
            }else{
                label.text = @"参会人员";
                
            }
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
    }else if ([self.model.status isEqualToString:@"4"]){
        if (@available(iOS 11.0, *)) {
            UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
            contentView.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(16.5, 15, kScreenWidth - 16.5, 20)];
            label.textColor = DefaultBlackLightTextClor;
            label.font = FontNameAndSize(16);
            label.textAlignment = NSTextAlignmentLeft;
            if (self.model.members.count <= 0) {
                label.text = @"";
                
            }else{
                label.text = @"参会人员";
                
            }
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
            if (self.model.members.count <= 0) {
                label.text = @"";
                
            }else{
                label.text = @"参会人员";
                
            }
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
    }else{
        if (@available(iOS 11.0, *)) {
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        } else {
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.status isEqualToString:@"1"]) {
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
            CancelAppionmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CancelAppionmentTableViewCell class])];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.cAppionment = ^{
                NSString *content = @"确认要取消会议吗";
                [self showScanMessageTitle:nil  content:content leftBtnTitle:@"不取消" rightBtnTitle:@"确认取消" tag:kFetchTag];
            };
            return cell;
        }
    }else if ([self.model.status isEqualToString:@"2"]) {
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
//            UIView *sep = [UIView new];
//            sep.backgroundColor = DefaultBackgroundColor;
//            [cell addSubview:sep];
//            [sep mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(20);
//                make.right.top.mas_equalTo(0);
//                make.height.mas_equalTo(1.0);
//            }];
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
    }else  if ([self.model.status isEqualToString:@"3"]){
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
            WailtToPayNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
            [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWithAppionmentDetailModel:self.model];
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
    }else{
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
                    WailtToPayNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
                    [cell setSeparatorInset:UIEdgeInsetsMake(0, kScreenWidth, 0, 0)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell refreshWithAppionmentDetailModel:self.model];
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

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    //
    [self.tableview registerClass:[AppionmentDetailDesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentDetailDesTableViewCell class])];
    [self.tableview registerClass:[AppionmentInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentInfoTableViewCell class])];
    [self.tableview registerClass:[NoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NoticeTableViewCell class])];
    [self.tableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
    [self.tableview registerClass:[CancelAppionmentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CancelAppionmentTableViewCell class])];
    [self.tableview registerClass:[WailtToPayNoticeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WailtToPayNoticeTableViewCell class])];
    //
    [self.tableview registerClass:[AppionmentPriceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentPriceTableViewCell class])];
    //
    [self.tableview registerClass:[AppionmentChatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentChatTableViewCell class])];
    [self.tableview registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scanAgreebook)];
    [self.headerView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.model.status isEqualToString:@"3"]) {
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
                conversation.title = self.model.topic;
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
    }else if([self.model.status isEqualToString:@"4"]){
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
  
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
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
        userInfo.groupName = self.model.topic;
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

- (void)scanAgreebook{
    scanAgreebookViewController *huizhenAgreebook = [scanAgreebookViewController new];
    huizhenAgreebook.title = @"会诊意见书";
    huizhenAgreebook.huizhenid = self.model.id;
    [self.navigationController pushViewController:huizhenAgreebook animated:YES];
}

- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    NSLog(@"%@",userInfo);
}

@end
