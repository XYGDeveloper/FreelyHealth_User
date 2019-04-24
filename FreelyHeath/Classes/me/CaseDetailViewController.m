//
//  CaseDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CaseDetailModel.h"
#import "CaseListRequest.h"
#import "CaseDetailApi.h"
#import "delApi.h"
#import "EditCaseApi.h"
#import "MyIntroTableViewCell.h"
#import "CaseInfoTableViewCell.h"
#import "FriendCircleCell.h"
#import "AddCaseViewController.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "AlertView.h"
#define kFetchTag 100

@interface CaseDetailViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource,BaseMessageViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)UITableView *caseDetailTableview;
@property (nonatomic,strong)CaseDetailApi *api;
@property (nonatomic,strong)delApi *delapi;
@property (nonatomic,strong)EditCaseApi *editApi;
@property (nonatomic,strong)CaseDetailModel *model;
@property (nonatomic,strong)UIButton *delbutton;
@property (nonatomic,strong)UIButton *modibutton;
@end

@implementation CaseDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.caseDetailTableview.mj_header beginRefreshing];
}
- (UITableView *)caseDetailTableview{
    if (!_caseDetailTableview) {
        _caseDetailTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _caseDetailTableview.delegate = self;
        _caseDetailTableview.dataSource = self;
        _caseDetailTableview.backgroundColor = DefaultBackgroundColor;
    }
    return _caseDetailTableview;
}
- (UIButton *)delbutton
{
    if (!_delbutton) {
        _delbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _delbutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _delbutton.backgroundColor = [UIColor whiteColor];
        [_delbutton setTitle:@"删除" forState:UIControlStateNormal];
        [_delbutton setTitleColor:AppStyleColor forState:UIControlStateNormal];
    }
    return _delbutton;
}
- (UIButton *)modibutton
{
    if (!_modibutton) {
        _modibutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _modibutton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _modibutton.backgroundColor = AppStyleColor;
        [_modibutton setTitle:@"修改" forState:UIControlStateNormal];
        [_modibutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _modibutton;
}
- (CaseDetailApi *)api{
    if (!_api) {
        _api = [[CaseDetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (delApi *)delapi{
    if (!_delapi) {
        _delapi = [[delApi alloc]init];
        _delapi.delegate = self;
    }
    return _delapi;
}
- (EditCaseApi *)editApi{
    if (!_editApi) {
        _editApi = [[EditCaseApi alloc]init];
        _editApi.delegate = self;
    }
    return _editApi;
}
- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.caseDetailTableview.mj_header endRefreshing];
    [Utils removeHudFromView:self.view];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    [self.caseDetailTableview.mj_header endRefreshing];
    if (api == _api) {
        self.model = responsObject;
        [self.caseDetailTableview reloadData];
    }
    if (api == _delapi) {
        [Utils postMessage:command.response.msg onView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (api == _editApi) {
        [Utils postMessage:command.response.msg onView:self.view];
    }
}

- (void)layOutsubviews{
    [self.caseDetailTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightNavigationItemWithTitle:@"分享" action:@selector(toshare)];
    [self.caseDetailTableview registerClass:[CaseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CaseInfoTableViewCell class])];
     [self.caseDetailTableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:@"f1"];
    [self.caseDetailTableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:@"f2"];
    [self.caseDetailTableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"hun"];
    [self.caseDetailTableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"jiazu"];
    [self.caseDetailTableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"zhengzhuang"];
    [self.caseDetailTableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"jiwang"];
    [self.caseDetailTableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"zhiliao"];
    [self.caseDetailTableview registerClass:[MyIntroTableViewCell class] forCellReuseIdentifier:@"koufu"];

    [self.view addSubview:self.caseDetailTableview];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self layOutsubviews];
     [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.delbutton];
    [self.view addSubview:self.modibutton];
    [self.delbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.modibutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.delbutton addTarget:self action:@selector(todel) forControlEvents:UIControlEventTouchUpInside];
    [self.modibutton addTarget:self action:@selector(tomodify) forControlEvents:UIControlEventTouchUpInside];
    self.caseDetailTableview.mj_header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [Utils addHudOnView:self.view withTitle:@"正在获取..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blDetail";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        bodyer.id = self.id;
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.api detailCase:requester.mj_keyValues.mutableCopy];
    }];
    [self.caseDetailTableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)todel{
    NSString *content = @"确认删除此条病历信息";
    [self showScanMessageTitle:@"提示信息" content:content leftBtnTitle:@"取消" rightBtnTitle:@"确定" tag:kFetchTag];
}

- (void)baseMessageView:(__kindof BaseMessageView *)messageView event:(id)event {
    
    NSLog(@"%@, tag:%ld event:%@", NSStringFromClass([messageView class]), (long)messageView.tag, event);
    if (messageView.tag == kFetchTag) {
        if ([event isEqualToString:@"取消"]) {
            
        }else{
            [Utils addHudOnView:self.view withTitle:@"正在删除..."];
            caseListHeader *header = [[caseListHeader alloc]init];
            header.target = @"bingLiControl";
            header.method = @"blDelete";
            header.versioncode = Versioncode;
            header.devicenum = Devicenum;
            header.fromtype = Fromtype;
            header.token = [User LocalUser].token;
            caseListBody *bodyer = [[caseListBody alloc]init];
            bodyer.id = self.id;
            CaseListRequest *requester = [[CaseListRequest alloc]init];
            requester.head = header;
            requester.body = bodyer;
            [self.delapi delCase:requester.mj_keyValues.mutableCopy];
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


- (void)tomodify{
    AddCaseViewController *edit = [AddCaseViewController new];
    edit.btlistEnter = YES;
    edit.title = @"编辑病例";
    edit.id = self.model.id;
    [self.navigationController pushViewController:edit animated:YES];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 201.5;
        }else if (indexPath.row == 1){
            return [tableView fd_heightForCellWithIdentifier:@"hun" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
                [cell refreshWirthModel:self.model];
            }];
        }else{
            return [tableView fd_heightForCellWithIdentifier:@"jiazu" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
                [cell refreshWirthModel1:self.model];
            }];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"zhengzhuang" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
                [cell refreshWirthModel2:self.model];
            }];
        }else if (indexPath.row == 1){
            return [tableView fd_heightForCellWithIdentifier:@"jiwang" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
                [cell refreshWirthModel3:self.model];
            }];
        }else{
            return [tableView fd_heightForCellWithIdentifier:@"zhiliao" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
                [cell refreshWirthModel4:self.model];
            }];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return [tableView fd_heightForCellWithIdentifier:@"koufu" cacheByIndexPath:indexPath configuration: ^(MyIntroTableViewCell *cell) {
                [cell refreshWirthModel4:self.model];
            }];
        }else{
            return [tableView fd_heightForCellWithIdentifier:@"f1" cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
                [cell cellDataWithModel1:self.model];
            }];
        }
    }else{
        return [tableView fd_heightForCellWithIdentifier:@"f2" cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
                [cell cellDataWithModel2:self.model];
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else if (section ==1){
        return 3;
    }else if (section == 2){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            CaseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CaseInfoTableViewCell class])];
            [cell refreshWithModel:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hun"];
            [cell refreshWirthModel:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiazu"];
            [cell refreshWirthModel1:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section ==1){
        if (indexPath.row == 0) {
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhengzhuang"];
            [cell refreshWirthModel2:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row ==1){
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jiwang"];
            [cell refreshWirthModel3:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhiliao"];
            [cell refreshWirthModel4:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section ==2){
        if (indexPath.row == 0) {
            MyIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"koufu"];
            [cell refreshWirthModel5:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"f1"];
            [cell cellDataWithModel1:self.model];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"f2"];
        [cell cellDataWithModel2:self.model];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else{
            return 40;
        }
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
            return 40;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        }else if (section == 1){
            UIView *sectionview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            sectionview.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 40)];
            label.text = @"病史资料";
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16.0f weight:0.3];
            label.textColor = DefaultBlackLightTextClor;
            [sectionview addSubview:label];
            return sectionview;
        }else if (section == 2){
            UIView *sectionview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            sectionview.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 40)];
            label.text = @"病程记录";
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16.0f weight:0.3];
            label.textColor = DefaultBlackLightTextClor;
            [sectionview addSubview:label];
            return sectionview;
        }else{
            UIView *sectionview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            sectionview.backgroundColor = [UIColor whiteColor];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth - 20, 40)];
            label.text = @"病历报告";
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:16.0f weight:0.3];
            label.textColor = DefaultBlackLightTextClor;
            [sectionview addSubview:label];
            return sectionview;
        }
    } else {
        return nil;
    }
}

- (void)toshare{
    
    if (![QQApiInterface isQQInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_QQ];
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_Qzone];
    }
    if (![WXApi isWXAppInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatSession];
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatFavorite];
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_WechatTimeLine];
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
    }
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Predefine_Begin+16 withPlatformIcon:[UIImage imageNamed:@"Logo"] withPlatformName:@"直医客服"];
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Renren)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        if (platformType == UMSocialPlatformType_Renren) {
            UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
            [UdeskManager setupCustomerOnline];
           NSString *info =  [NSString stringWithFormat:@"患者信息:%@,%@,%@",self.model.name,self.model.sex,self.model.age];
            NSDictionary *dict = @{                                                                       @"productImageUrl":@"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg",
                                                                                                              @"productTitle":[NSString stringWithFormat:@"主要症状:%@",self.model.zhengzhuang],
                                                                                                              @"productDetail":info,@"productURL":self.model.shareurl
                                                                                                              };
            [manager setProductMessage:dict];
            //设置头像
            [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
            [manager pushUdeskInViewController:self completion:nil];
            //点击留言回调
            [manager leaveMessageButtonAction:^(UIViewController *viewController){
                UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
                [viewController presentViewController:offLineTicket animated:YES completion:nil];
            }];
        }else{
            [self shareWebPageToPlatformType:platformType];
        }
    }];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"病例详情介绍" descr:self.model.zhengzhuang thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.model.shareurl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            [Utils postMessage:error.userInfo[@"message"] onView:self.view];
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                [Utils postMessage:@"分享成功！" onView:self.view];

                UMSocialLogInfo(@"response message is %@",resp.message);
                [Utils postMessage:resp.message onView:self.view];
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];
}

@end
