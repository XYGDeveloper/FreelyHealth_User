//
//  SDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SDetailViewController.h"
#import "ConsultTableViewCell.h"
#import "PolularScienceTableViewCell.h"
#import "QuestionAndAuswerCellTableViewCell.h"
#import "TeamIndexViewController.h"
#import "QuestionCenterViewController.h"
#import "PopularDetailViewController.h"
#import "YLButton.h"
#import "TumorZoneListApi.h"
#import "TumorZoneRequest.h"
#import "TumorZoneListModel.h"
#import "MedicalTreatmentViewController.h"
#import "TeamExpertViewController.h"
#import "CustomerViewController.h"
#import "ToQuestionViewController.h"
#import "ScienDetailViewController.h"
#import "FreeConsultViewController.h"
#import "UINavigationController+NAV.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "TeamDetailViewController.h"
#import "MBProgressHUD+BWMExtension.h"
#import "UIView+AnimationProperty.h"
@interface SDetailViewController ()<UITableViewDelegate,UITableViewDataSource,delegateColl,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *ConsulttableView;

@property (nonatomic,strong)NSMutableArray *listArray;

@property (nonatomic,strong)NSMutableArray *preArrayList;

@property (nonatomic,strong)TumorZoneListModel *model;

@property (nonatomic,strong)TumorZoneListApi *TumorZoneApi;

@property (nonatomic,strong)MBProgressHUD *hub;

@property(nonatomic,assign)CGFloat historyY;

@end

@implementation SDetailViewController


- (void)loadData{
    
    [MBProgressHUD bwm_showTitle:@"加载中" toView:self.view hideAfter:0.5];
    
    TumorZoneHeader *head = [[TumorZoneHeader alloc]init];
    
    head.target = @"noTokenPrefectureControl";
    
    head.method = @"prefectureFirst";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    TumorZoneBody *body = [[TumorZoneBody alloc]init];
    
    body.id = @"1";
    
    TumorZoneRequest *request = [[TumorZoneRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.TumorZoneApi TumorZoneList:request.mj_keyValues.mutableCopy];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
//    [self.ConsulttableView.mj_header beginRefreshing];
    
}

- (NSMutableArray *)listArray
{
    
    if (!_listArray) {
        
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
    
}

- (NSMutableArray *)preArrayList
{

    if (!_preArrayList) {
        
        _preArrayList = [NSMutableArray array];
    }

    return _preArrayList;
    

}

- (TumorZoneListApi *)TumorZoneApi{
    
    if (!_TumorZoneApi) {
        
        _TumorZoneApi = [[TumorZoneListApi alloc]init];
        
        _TumorZoneApi.delegate = self;
        
        
    }
    
    return _TumorZoneApi;
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
   [self.ConsulttableView.mj_header endRefreshing];

    [self.hub bwm_hideWithTitle:command.response.msg
                      hideAfter:kBWMMBProgressHUDHideTimeInterval
                        msgType:BWMMBProgressHUDMsgTypeError];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.ConsulttableView];

//    NSLog(@"%@",responsObject);
    
    self.model = [TumorZoneListModel mj_objectWithKeyValues:responsObject];
    
    self.preArrayList = self.model.informations.mutableCopy;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"re" object:nil];
    
    [self.ConsulttableView reloadData];

}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [self.ConsulttableView.mj_header endRefreshing];

    [self.hub bwm_hideWithTitle:command.response.msg
                      hideAfter:kBWMMBProgressHUDHideTimeInterval
                        msgType:BWMMBProgressHUDMsgTypeSuccessful];
    
    if (self.preArrayList.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.ConsulttableView response:command.response operationBlock:^{
            strongify(self)
            
            self.ConsulttableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                TumorZoneHeader *head = [[TumorZoneHeader alloc]init];
                
                head.target = @"noTokenPrefectureControl";
                
                head.method = @"prefectureFirst";
                
                head.versioncode = Versioncode;
                
                head.devicenum = Devicenum;
                
                head.fromtype = Fromtype;
                
                head.token = [User LocalUser].token;
                
                TumorZoneBody *body = [[TumorZoneBody alloc]init];
                
                body.id = @"1";
                
                TumorZoneRequest *request = [[TumorZoneRequest alloc]init];
                
                request.head = head;
                
                request.body = body;
                
                NSLog(@"%@",request);
                
                [self.TumorZoneApi TumorZoneList:request.mj_keyValues.mutableCopy];
                
            }];
            
            [self.ConsulttableView.mj_header beginRefreshing];
            
        }];
    }
   
}

- (void)setButtonUI{

    YLButton * zsearchBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [zsearchBtn setImage:[UIImage imageNamed:@"conslt_left"] forState:UIControlStateNormal];
    [zsearchBtn setTitle:@"咨询" forState:UIControlStateNormal];
    zsearchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    [zsearchBtn setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
    [zsearchBtn setTitleColor: AppStyleColor forState:UIControlStateHighlighted];
    zsearchBtn.imageRect = CGRectMake(30, 15, 26, 26);
    zsearchBtn.titleRect = CGRectMake(70, 10, 100, 35);
    [self.view addSubview:zsearchBtn];
    
    [zsearchBtn addTarget:self action:@selector(toValuteAction:) forControlEvents:UIControlEventTouchUpInside];

    zsearchBtn.backgroundColor = [UIColor whiteColor];
    [zsearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(54);
    }];
    
    //
    YLButton * jsearchBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [jsearchBtn setImage:[UIImage imageNamed:@"consult_middle"] forState:UIControlStateNormal];
    [jsearchBtn setTitle:@"就医" forState:UIControlStateNormal];
    jsearchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    [jsearchBtn setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
    [jsearchBtn setTitleColor:AppStyleColor forState:UIControlStateHighlighted];
    jsearchBtn.imageRect = CGRectMake(30, 15, 26, 26);
    jsearchBtn.titleRect = CGRectMake(70, 10, 100, 35);
    [self.view addSubview:jsearchBtn];
    jsearchBtn.backgroundColor = [UIColor whiteColor];
    
    [jsearchBtn addTarget:self action:@selector(jumpToJY:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [jsearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(zsearchBtn.mas_right);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(54);
    }];

    //
    YLButton * jjsearchBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [jjsearchBtn setImage:[UIImage imageNamed:@"consult_right"] forState:UIControlStateNormal];
    [jjsearchBtn setTitle:@"康复" forState:UIControlStateNormal];
     jjsearchBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    [jjsearchBtn setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:0.3] forState:UIControlStateNormal];
    [jjsearchBtn setTitleColor:AppStyleColor forState:UIControlStateHighlighted];
    jjsearchBtn.imageRect = CGRectMake(30, 15, 26, 26);
    jjsearchBtn.titleRect = CGRectMake(70, 10, 100, 35);
    [self.view addSubview:jjsearchBtn];
    jjsearchBtn.backgroundColor = [UIColor whiteColor];

    [jjsearchBtn addTarget:self action:@selector(jumpToJj:) forControlEvents:UIControlEventTouchUpInside];

    [jjsearchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(jsearchBtn.mas_right);
        make.width.mas_equalTo(kScreenWidth/3);
        make.height.mas_equalTo(54);
    }];
    
    for (NSInteger i = 0; i<= 3; i++) {
        
        UIView *Buttonview = [[UIView alloc]initWithFrame:CGRectMake(i* (kScreenWidth/3), 10, 1, 34)];
        
        [self.view addSubview:Buttonview];
        
        Buttonview.backgroundColor = RGB(213, 231, 233);
        
        if (i == 0 || i == 3) {
            Buttonview.hidden = YES;
        }
    }
    
    [self.ConsulttableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(jjsearchBtn.mas_bottom).mas_equalTo(0);
        
        make.left.right.bottom.mas_equalTo(0);
        
    }];
    
}

- (void)jumpToJj:(UIButton *)sender{
    sender.alpha = 0;
    sender.scale = 1.1f;
    [UIView animateWithDuration:0.3 animations:^{
        sender.alpha = 1.f;
        sender.scale = 1.f;
    } completion:^(BOOL finished) {
        [MBProgressHUD bwm_showTitle:@"即将开通，敬请期待" toView:self.view hideAfter:2.0f msgType:BWMMBProgressHUDMsgTypeInfo];
    }];
}

- (void)jumpToJY:(UIButton *)sender{
    sender.alpha = 0;
    sender.scale = 1.1f;
    [UIView animateWithDuration:0.3 animations:^{
        sender.alpha = 1.f;
        sender.scale = 1.f;
    } completion:^(BOOL finished) {
        if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
            [Utils postMessage:@"网络连接已断开" onView:self.view];
        }else{
            MedicalTreatmentViewController *medical = [MedicalTreatmentViewController new];
            medical.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:medical animated:YES];
        }
    }];
    
}


- (UITableView *)ConsulttableView
{
    if (!_ConsulttableView) {
        _ConsulttableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _ConsulttableView.delegate = self;
        _ConsulttableView.dataSource = self;
        _ConsulttableView.showsVerticalScrollIndicator = NO;
        _ConsulttableView.separatorColor = RGB(213, 231, 233);
    }
    return _ConsulttableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"肿瘤专区";
    self.view.backgroundColor = DefaultBackgroundColor;
    
    [self.view addSubview:self.ConsulttableView];

    [self setButtonUI];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];

    headView.backgroundColor = DefaultBackgroundColor;
    
    self.ConsulttableView.tableHeaderView = headView;
    
    self.ConsulttableView.backgroundColor = DefaultBackgroundColor;
    
    self.ConsulttableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.ConsulttableView registerClass:[QuestionAndAuswerCellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QuestionAndAuswerCellTableViewCell class])];
    
    [self.ConsulttableView registerClass:[ConsultTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ConsultTableViewCell class])];
    [self.ConsulttableView registerClass:[PolularScienceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PolularScienceTableViewCell class])];
    
    [self loadData];

}


- (void)back{

    [self.navigationController popViewControllerAnimated:YES];
    
}
//


- (void)toValuteAction:(UIButton *)sender{
    sender.alpha = 0;
    sender.scale = 1.1f;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"连接客服中...";
    [UIView animateWithDuration:0.3 animations:^{
        sender.alpha = 1.f;
        sender.scale = 1.f;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } completion:^(BOOL finished) {
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            
            if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                
                [Utils postMessage:@"网络连接已断开" onView:self.view];
                
            }else{
                
                UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
                //设置头像
                [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
                
                [manager pushUdeskInViewController:self completion:nil];
                //点击留言回调
                [manager leaveMessageButtonAction:^(UIViewController *viewController){
                    
                    [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
                        NSLog(@"客服用户自定义字段：%@",responseObject);
                    }];
                    UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
                    [viewController presentViewController:offLineTicket animated:YES completion:nil];
                }];
            }
        }
    }];
}

- (void)toValuteAction1{
    

    CustomerViewController *chatService = [[CustomerViewController alloc] init];
    chatService.conversationType = ConversationType_CUSTOMERSERVICE;
    chatService.targetId = Service_ID;
    chatService.title = @"客服";
  
    RCCustomerServiceInfo *csInfo = [[RCCustomerServiceInfo alloc] init];
    
    csInfo.userId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
    csInfo.nickName = [User LocalUser].name;
    csInfo.loginName = [User LocalUser].nickname;
    csInfo.name = [User LocalUser].nickname;
    csInfo.gender = [User LocalUser].sex;
    csInfo.age = [User LocalUser].age;
    csInfo.portraitUrl =
    [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri;
    
    [self.navigationController pushViewController :chatService animated:YES];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSMutableArray *sectionArr = @[@"专家咨询",@"科普园地"].mutableCopy;
    
    UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    content.backgroundColor = [UIColor whiteColor];
    UIImageView *letView = [[UIImageView alloc]init];
    letView.image = [UIImage imageNamed:@"navi_background"];
    [content addSubview:letView];
    [letView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(20);
        make.left.mas_equalTo(16);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    titleLabel.textColor = DefaultGrayLightTextClor;
    [content addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(letView.mas_right).mas_equalTo(5);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.alpha = 0.8;
    [button setTitle:@"查看全部" forState:UIControlStateNormal];
    [button setTitleColor:DefaultBlueTextClor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    [content addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-10);
    }];
    
    titleLabel.text = [sectionArr objectAtIndex:section];
    
    button.tag = 1000+section;
    
    [button addTarget:self action:@selector(jumpDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sep = [[UIView alloc]init];

    sep.backgroundColor = DividerGrayColor;
    
    [content addSubview:sep];
    
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    
    if (section == 0) {
        
        sep.hidden = YES;
        
    }else{
    
        sep.hidden = NO;
        
    }
    
    return content;
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return 244;
        
    }else{
    
        return 112;
    
    }
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        return 1;
        
    }else{
        
        return self.preArrayList.count;
        
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        
        ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConsultTableViewCell class])];
                
        cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width+1000, 0,0);
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.delegateColl = self;
        
        return cell;
        
    }else
    {
        PolularScienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PolularScienceTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        infomationModel *model = [self.model.informations objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
        return cell;
    }
    
    return cell;
    
}

- (void)jumpDetail:(UIButton *)sender{

    if (sender.tag == 1001){
    
        if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
            [Utils postMessage:@"网络连接已断开" onView:self.view];
        }else{
            PopularDetailViewController *popula = [PopularDetailViewController new];
            popula.hidesBottomBarWhenPushed = YES;
            popula.title = @"科普园地";
            [self.navigationController pushViewController:popula animated:YES];
        }
        
    }else{
    
        //temp
        
      //  [Utils postMessage:@"即将开通" onView:self.view];

        if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
            
            [Utils postMessage:@"网络连接已断开" onView:self.view];
            
        }else{
            
            TeamIndexViewController *tumor = [TeamIndexViewController new];
            
            tumor.hidesBottomBarWhenPushed = YES;
            
            tumor.title = @"肿瘤咨询";
            
            [self.navigationController pushViewController:tumor animated:YES];
            
        }
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 1) {
        
        infomationModel *model = [self.model.informations objectAtIndex:indexPath.row];
        
        if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
            
            [Utils postMessage:@"网络连接已断开" onView:self.view];
            
        }else{
            
            ScienDetailViewController *ass = [ScienDetailViewController new];
            
            ass.model = model;
            
            [ass loadWebURLSring:model.url];
            
            ass.hidesBottomBarWhenPushed = YES;
            
            ass.title = @"科普详情";
            
            [self.navigationController pushViewController:ass animated:YES];
            
        }
        
    }

}


- (void)ClickCooRow:(NSInteger)CellRow teamModel:(TeamModel *)model
{
    
    //temp
    
    if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
        
        [Utils postMessage:@"网络连接已断开" onView:self.view];
        
    }else{
        
        TeamDetailViewController *team = [TeamDetailViewController new];
        
        team.hidesBottomBarWhenPushed = YES;
        
        team.ID = model.id;
        
        team.title = model.name;
        
        [self.navigationController pushViewController:team animated:YES];
        
    }
//    [Utils postMessage:@"即将开通" onView:self.view];
    
}


@end
