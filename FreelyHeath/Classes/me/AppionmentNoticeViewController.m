//
//  AppionmentNoticeViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentNoticeViewController.h"
#import "AppionmentMessageListTableViewCell.h"
#import "AuditedViewController.h"
#import "AuditedViewController.h"
#import "WailtToPayViewController.h"
#import "AppionmentReviewViewController.h"
#import "AppionmentFInishViewController.h"
#import "MyMessageModel.h"
#import "MymessageListRequest.h"
#import "getMessageListApi.h"
#import "ReadMessageApi.h"
#import "AppionmentDetailViewController.h"
@interface AppionmentNoticeViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)ReadMessageApi *readApi;
@property (nonatomic,strong)getMessageListApi *messageApi;

@end

@implementation AppionmentNoticeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    myMessageHeader *head = [[myMessageHeader alloc]init];
    
    head.target = @"userMsgControl";
    
    head.method = @"getUserMsgList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    myMessageBody *body = [[myMessageBody alloc]init];
    
    MymessageListRequest *request = [[MymessageListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.messageApi getMessageList:request.mj_keyValues.mutableCopy];
 
}

- (getMessageListApi *)messageApi{
    if (!_messageApi) {
        _messageApi = [[getMessageListApi alloc]init];
        _messageApi.delegate  =self;
    }
    return _messageApi;
}

- (ReadMessageApi *)readApi{
    if (!_readApi) {
        _readApi = [[ReadMessageApi alloc]init];
        _readApi.delegate = self;
    }
    return _readApi;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableview.mj_header endRefreshing];

}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    NSArray *array = (NSArray *)responsObject;
    NSLog(@"%@",array);
    if (api == _messageApi) {
        if (array.count <= 0) {
            [[EmptyManager sharedManager] showEmptyOnView:self.tableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无消息" operationText:nil operationBlock:nil];
        } else {
            [self.messageArray removeAllObjects];
            [self.messageArray addObjectsFromArray:responsObject];
            [self.tableview reloadData];
        }
    }
    
    if (api == _readApi) {
        
    }
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate  =self;
        _tableview.dataSource  =self;
        _tableview.backgroundColor = DefaultBackgroundColor;
    }
    return _tableview;
}

- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self layOut];
    [self.tableview registerClass:[AppionmentMessageListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([AppionmentMessageListTableViewCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([AppionmentMessageListTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(AppionmentMessageListTableViewCell *cell) {
        [cell refreshWithMessageModel:model];
    }];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppionmentMessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AppionmentMessageListTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
    [cell refreshWithMessageModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyMessageModel *model = [self.messageArray objectAtIndex:indexPath.row];
    if (model.mdtid) {
        AppionmentDetailViewController *audi = [[AppionmentDetailViewController alloc]init];
        audi.title = @"会诊详情";
        audi.id = model.mdtid;
        [self.navigationController pushViewController:audi animated:YES];
    }
    [self readMessageWithMessageid:model.id];
    
}

- (void)readMessageWithMessageid:(NSString *)messageid{
    myMessageHeader *head = [[myMessageHeader alloc]init];
    head.target = @"userMsgControl";
    head.method = @"readUserMsg";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    myMessageBody *body = [[myMessageBody alloc]init];
    body.id = messageid;
    MymessageListRequest *request = [[MymessageListRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"%@",request);
    [self.readApi readMessage:request.mj_keyValues.mutableCopy];
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
