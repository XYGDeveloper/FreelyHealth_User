//
//  MessageListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MessageListViewController.h"
#import "AppionmentNoticeViewController.h"
#import "MessageListTableViewCell.h"
#import "UdeskTicketViewController.h"
#import "UdeskSDKManager.h"
#import "MyMessageModel.h"
#import "MymessageListRequest.h"
#import "getMessageListApi.h"
#import "getMessageCountApi.h"
#import "MymessageConListViewController.h"
@interface MessageListViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *messageNameLabel;
@property (nonatomic,strong)UILabel *messageContentLabel;
@property (nonatomic,strong)UILabel *badgeLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)getMessageListApi *messageApi;
//@property (nonatomic,strong)getMessageCountApi *countApi;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong)MyMessageModel *model;
@property (nonatomic,strong)NSString *counts;

@end

@implementation MessageListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshMessageModel];
//    [self refreshWithMessagecount];
}

//- (void)refreshWithMessagecount{
//    myMessageHeader *head = [[myMessageHeader alloc]init];
//    head.target = @"userMsgControl";
//    head.method = @"queryUserMsgCounts";
//    head.versioncode = Versioncode;
//    head.devicenum = Devicenum;
//    head.fromtype = Fromtype;
//    head.token = [User LocalUser].token;
//    myMessageBody *body = [[myMessageBody alloc]init];
//    MymessageListRequest *request = [[MymessageListRequest alloc]init];
//    request.head = head;
//    request.body = body;
//    NSLog(@"%@",request);
//    [self.countApi getMessageCounts:request.mj_keyValues.mutableCopy];
//}

- (void)refreshMessageModel{
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

//- (getMessageCountApi *)countApi{
//    if (!_countApi) {
//        _countApi = [[getMessageCountApi alloc]init];
//        _countApi.delegate  =self;
//    }
//    return _countApi;
//}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.tableview.mj_header endRefreshing];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.tableview.mj_header endRefreshing];
    [[EmptyManager sharedManager] removeEmptyFromView:self.tableview];
    NSArray *array = (NSArray *)responsObject;
    self.messageArray = [NSMutableArray array];
    [self.messageArray removeAllObjects];
    if (api == _messageApi) {
        if (array.count <= 0) {

        } else {
            for (MyMessageModel *model in array) {
                if ([model.status isEqualToString:@"0"]) {
                    [self.messageArray addObject:model];
                }
            }
            if (self.messageArray.count <= 0) {
                self.model = [array firstObject];
            }else{
                self.model = [self.messageArray firstObject];
            }
            self.counts = [NSString stringWithFormat:@"%lu",(unsigned long)self.messageArray.count];
          
        }
        
        if ([UdeskManager getLocalUnreadeMessagesCount] > 0) {
            self.badgeLabel.text = [NSString stringWithFormat:@"%ld",[UdeskManager getLocalUnreadeMessagesCount]];
            self.badgeLabel.backgroundColor = DefaultRedTextClor;
        }else{
            self.badgeLabel.backgroundColor = [UIColor whiteColor];
        }
        NSArray *message = [UdeskManager getLocalUnreadeMessages];
        if (message.count > 0) {
            UdeskMessage *messageobj = [message firstObject];
            self.messageContentLabel.text = [self filterHTML:messageobj.content];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
            NSString *strDate = [dateFormatter stringFromDate:messageobj.timestamp];
            self.timeLabel.text = [[strDate componentsSeparatedByString:@" "] objectAtIndex:3];
        }else{
            self.messageContentLabel.text = @"无客服消息";
            self.timeLabel.text = @"";
            
        }
        
        [self.tableview reloadData];
        
    }
 
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}


- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        _footView.backgroundColor =[UIColor whiteColor];
    }
    return _footView;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.image = [UIImage imageNamed:@"message_customer"];
    }
    return _headImage;
}
- (UILabel *)messageNameLabel{
    if (!_messageNameLabel) {
        _messageNameLabel = [[UILabel alloc]init];
        _messageNameLabel.textAlignment = NSTextAlignmentLeft;
        _messageNameLabel.textColor = DefaultBlackLightTextClor;
        _messageNameLabel.font = Font(16);
    }
    return _messageNameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = DefaultGrayLightTextClor;
        _timeLabel.font = Font(14);
    }
    return _timeLabel;
}

- (UILabel *)messageContentLabel{
    if (!_messageContentLabel) {
        _messageContentLabel = [[UILabel alloc]init];
        _messageContentLabel.textAlignment = NSTextAlignmentLeft;
        _messageContentLabel.font = FontNameAndSize(15);
        _messageContentLabel.textColor = DefaultGrayTextClor;
    }
    return _messageContentLabel;
}
- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = FontNameAndSize(10);
        _badgeLabel.layer.cornerRadius = 7.5;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.textColor = [UIColor whiteColor];
    }
    return _badgeLabel;
}

- (void)SetFOotview{
            self.tableview.tableFooterView = self.footView;
            self.headImage.userInteractionEnabled = YES;
            [self.footView addSubview:self.headImage];
            self.messageNameLabel.userInteractionEnabled = YES;
            [self.footView addSubview:self.messageNameLabel];
            self.messageContentLabel.userInteractionEnabled = YES;
            [self.footView addSubview:self.messageContentLabel];
            [self.footView addSubview:self.badgeLabel];
            [self.footView addSubview:self.timeLabel];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, kScreenWidth, 80);
            [button addTarget:self action:@selector(tocustomer) forControlEvents:UIControlEventTouchUpInside];
            [self.footView addSubview:button];
            //test
            self.messageNameLabel.text = @"客服信息";
}

- (void)tocustomer{
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
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.backgroundColor = DefaultBackgroundColor;
        _tableview.delegate  = self;
        _tableview.dataSource  =self;
        _tableview.separatorColor = [UIColor whiteColor];
    }
    return _tableview;
}

- (void)layOut{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
    }];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(-10.5);
        make.bottom.mas_equalTo(self.headImage.mas_top).mas_equalTo(10.5);
    }];
    [self.messageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_top);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_top);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.messageNameLabel.mas_right).mas_equalTo(15);
    }];
    
    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.messageNameLabel.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.tableview];
    [self SetFOotview];
    [self layOut];
    [self.tableview registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MessageListTableViewCell class])];
    [self.tableview registerClass:[MessageListTableViewCell class] forCellReuseIdentifier:@"conversation"];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessagecount:) name:@"messageCount" object:nil];
}

//- (void)refreshMessagecount:(NSNotification *)noti{
//
//    if ([noti.name isEqualToString:@"messageCount"]) {
//        [self refreshWithMessagecount];
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        MessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageListTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.messageArray.count > 0) {
            cell.badgeLabel.text = self.counts;
            cell.badgeLabel.backgroundColor = DefaultRedTextClor;
        }
        [cell refreshWithModel:self.model counts:self.counts];
        return cell;
    }else{
        MessageListTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"conversation"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                             @(ConversationType_GROUP)]];
        [cell refreshWithMessageCounts:[NSString stringWithFormat:@"%d",unreadMsgCount]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AppionmentNoticeViewController *notice = [AppionmentNoticeViewController new];
        notice.title = @"通知";
        [self.navigationController pushViewController:notice animated:YES];
    }else{
        MymessageConListViewController *list = [MymessageConListViewController new];
        list.title = @"会话列表";
        [self.navigationController pushViewController:list animated:YES];
    }
 
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
