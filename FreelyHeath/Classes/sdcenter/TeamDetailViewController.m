//
//  TeamDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/11/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamDetailViewController.h"
#import <UShareUI/UShareUI.h>
#import "UIImage+GradientColor.h"
#import "UdeskTicketViewController.h"
#import "MedicalDetailController.h"
#import "UdeskSDKManager.h"
#import "ExpertConsultTableViewCell.h"
#import "ExpertConsultViewController.h"
#import "TeamdetailModel.h"
#import "TeamDetailRequest.h"
#import "TeamDetailApi.h"
#import "ExpertDisTableViewCell.h"
#import "UINavigationBar+Extion.h"
#import "UIView+Extion.h"
#import "TeamDesTableViewCell.h"
#import "TeamListTableViewCell.h"
#import "DotorDetailViewController.h"
#import "OVSDeployableLabel.h"
#import "IntroTableViewCell.h"
#import "UIView+AnimationProperty.h"
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import <UShareUI/UShareUI.h>
#import "ZJImageMagnification.h"
#import <APOpenAPI.h>
#import <DTShareKit/DTOpenAPI.h>
#import "CommitApplyViewController.h"
#import "ApplyHZViewController.h"
@interface TeamDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UIImageView *img;

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *jop;

@property (nonatomic,strong)UILabel *dep;

@property (nonatomic,strong)UILabel *hospital;

@property (nonatomic,strong)TeamDetailApi *api;

@property (nonatomic,strong)TeamdetailModel *model;

@property (nonatomic,strong)NSMutableArray * listArr;

@property (nonatomic,strong)NSString *shareUrl;

@property (nonatomic,strong)UIButton *ConsultationAppointmentButton;

@end

@implementation TeamDetailViewController

- (NSMutableArray *)listArr
{
    
    if (!_listArr) {
        
        _listArr = [NSMutableArray array];
    }
    
    return _listArr;
    
}


- (UIButton *)ConsultationAppointmentButton{
    if (!_ConsultationAppointmentButton) {
        _ConsultationAppointmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ConsultationAppointmentButton setTitle:@"申请会诊" forState:UIControlStateNormal];
        [_ConsultationAppointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ConsultationAppointmentButton.backgroundColor = AppStyleColor;
        _ConsultationAppointmentButton.titleLabel.font = FontNameAndSize(18);
    }
    return _ConsultationAppointmentButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    teamDetailHeader *head = [[teamDetailHeader alloc]init];
    
    head.target = @"noTokenPrefectureControl";
    
    head.method = @"teamsDetail";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    teamDetailBody *body = [[teamDetailBody alloc]init];
    
    body.id = self.ID;
    
    TeamDetailRequest *request = [[TeamDetailRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api teamDetailList:request.mj_keyValues.mutableCopy];
    
}


- (UITableView *)tableview
{
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_tableview registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];
        [_tableview registerClass:[IntroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IntroTableViewCell class])];
        _tableview.delegate = self;
        
        _tableview.backgroundColor = DefaultBackgroundColor;
        
        _tableview.separatorColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        
        _tableview.dataSource = self;
        
        _tableview.showsVerticalScrollIndicator = NO;
    }
    
    return _tableview;
    
}

- (void)LayoutSubview{
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (TeamDetailApi *)api
{
    
    if (!_api) {
        
        _api = [[TeamDetailApi alloc]init];
        
        _api.delegate  =self;
        
    }
    
    return _api;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    self.model = responsObject;

    self.shareUrl = self.model.shareurl;

    self.listArr = [members mj_objectArrayWithKeyValuesArray:self.model.members];
    
    self.name.text = self.model.lname ? self.model.lname:@"";
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:self.model.lfacepath] placeholderImage:[UIImage imageNamed:@"用户"]];
    
    self.jop.text = [NSString stringWithFormat:@"学科领头人 %@",self.model.ljob];
    self.hospital.text = self.model.lhname;
//    self.conLabel.text = self.model.introduction;
    [self.tableview reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self setRightNavigationItemWithTitle:@"分享" action:@selector(toshare)];
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    self.headView.backgroundColor = DefaultBackgroundColor;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    UIColor *topUIColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topUIColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [self.headView addSubview:topView];
    
//    UILabel *inlabel = [[UILabel alloc]init];
//
//    inlabel.userInteractionEnabled = YES;
//
//    [self.headView addSubview:inlabel];
//
//    self.conLabel = [[UITextView alloc]init];
//
//    [inlabel addSubview:self.conLabel];
//    self.conLabel.textAlignment = NSTextAlignmentCenter;
//    self.conLabel.textColor = DefaultGrayLightTextClor;
//    self.conLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
//    self.conLabel.editable = NO;
//    self.conLabel.isEditable == NO;
//    [self.conLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(4, 4, 4, 4));
//    }];
//
//    inlabel.backgroundColor = [UIColor whiteColor];
    
    self.img = [[UIImageView alloc]init];
    
    self.img.backgroundColor = [UIColor whiteColor];
    self.img.layer.cornerRadius = 40;
    self.img.layer.masksToBounds = YES;
    self.img.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.img addGestureRecognizer:tap];
    [topView addSubview:self.img];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(80);
        
    }];
    
    self.name = [[UILabel alloc]init];
    
    self.name.textColor = [UIColor whiteColor];
    
    self.name.font = [UIFont systemFontOfSize:22 weight:2.0f];
    
    [topView addSubview:self.name];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.img.mas_centerY);
        make.left.mas_equalTo(self.img.mas_right).mas_equalTo(5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    
    [topView addSubview:lineView];
    
    lineView.backgroundColor = [UIColor whiteColor];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.img.mas_centerY);
        make.left.mas_equalTo(self.name.mas_right).mas_equalTo(10);
        make.width.mas_equalTo(0.8);
        make.height.mas_equalTo(60);
        
    }];
    
    self.jop = [[UILabel alloc]init];
    
    self.jop.textColor = [UIColor whiteColor];
    
    self.jop.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    
    [topView addSubview:self.jop];
    
    [self.jop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(lineView.mas_top);
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        
    }];
    
    self.hospital = [[UILabel alloc]init];
    
    self.hospital.textColor = [UIColor whiteColor];
    
    self.hospital.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    
    [topView addSubview:self.hospital];
    
    [self.hospital mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.jop.mas_bottom);
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        
    }];

    [self.view addSubview:self.tableview];
    
    self.tableview.tableHeaderView  = self.headView;
    
    [self LayoutSubview];
    
    self.title = self.model.name;
    
    [self.view addSubview:self.ConsultationAppointmentButton];
    
    [self.ConsultationAppointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    [self.ConsultationAppointmentButton addTarget:self action:@selector(toAppionment) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)toAppionment{
    if ([Utils showLoginPageIfNeeded]) {
    } else {
        ApplyHZViewController *nation = [ApplyHZViewController new];
        nation.isLSTD = NO;
        [nation loadWebURLSring:video_hz_URL5];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (members *model in self.listArr) {
            [tempArr addObject:model.name];
        }
        nation.teamMember = tempArr;
        nation.teamId = self.model.id;
        nation.title = @"专家视频会诊";
        nation.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nation animated:YES];
    }
   
}

- (void)tapAction{
    [ZJImageMagnification scanBigImageWithImageView:self.img alpha:1.0f];
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }else{
        return 0;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.listArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntroTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DoctorModel *model = [[DoctorModel alloc]init];
        model.introduction = self.model.introduction;
        [cell refreWithdocModel:model];
        return cell;
    }else{
        TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(0,20,0,0);
        members *model =[self.listArr objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([IntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(IntroTableViewCell *cell) {
            DoctorModel *model = [[DoctorModel alloc]init];
            model.introduction = self.model.introduction;
            [cell refreWithdocModel:model];
            
        }];

    }else{
        return 94;
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        members *model = [self.listArr objectAtIndex:indexPath.row];
        DotorDetailViewController *doctor = [[DotorDetailViewController alloc]init];
        doctor.title = @"医生详情";
        doctor.ID = model.id;
        doctor.chatID = self.model.chatid;
        [self.navigationController pushViewController:doctor animated:YES];
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

    if (![APOpenAPI isAPAppInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_AlipaySession];
    }
    if ([DTOpenAPI isDingTalkInstalled]) {
        [UMSocialUIManager  removeCustomPlatformWithoutFilted:UMSocialPlatformType_DingDing];
    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weibo://"]]) {
    }
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatFavorite),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_AlipaySession),@(UMSocialPlatformType_DingDing)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.name descr:self.model.introduction thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = self.shareUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
//    NSLog(@"%@",self.model.name,self.model.introduction,self.shareUrl);
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                [Utils postMessage:@"分享成功！" onView:self.view];
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                
                UMSocialLogInfo(@"response data is %@",data);
                
            }
        }
        
        //        [Utils postMessage:error.description onView:self.view];
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = scrollView.contentOffset;
    NSLog(@"%f",translation.y);
    
    if (translation.y< 100) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationtitleView:nil];
            self.title = self.model.lhname;
        }];
    }else if(translation.y> 100){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        UIImageView *headImage = [[UIImageView alloc]init];
        [bgView addSubview:headImage];
        headImage.layer.cornerRadius = 15;
        headImage.layer.masksToBounds = YES;
        UILabel *nikeName = [[UILabel alloc]init];
        nikeName.textColor = [UIColor whiteColor];
        nikeName.font = Font(14);
        nikeName.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:nikeName];
        [nikeName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bgView.mas_centerX);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.right.mas_equalTo(0);
        }];
        [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.right.mas_equalTo(nikeName.mas_left).mas_equalTo(-5);
            make.width.height.mas_equalTo(30);
        }];
     
        [UIView animateWithDuration:0.3 animations:^{
            nikeName.text = self.model.lhname;
            [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.lfacepath]];
            [self setNavigationtitleView:bgView];
        }];
    }
}

@end
