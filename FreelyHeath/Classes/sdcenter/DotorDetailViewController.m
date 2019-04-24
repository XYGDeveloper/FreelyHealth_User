//
//  DotorDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/11/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DotorDetailViewController.h"
#import "UIImage+GradientColor.h"
#import "UdeskTicketViewController.h"
#import "MedicalDetailController.h"
#import "UdeskSDKManager.h"
#import <UShareUI/UShareUI.h>
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import <APOpenAPI.h>
#import <DTShareKit/DTOpenAPI.h>
@interface DotorDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *tableview;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UIImageView *img;

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *jop;

@property (nonatomic,strong)UILabel *dep;

@property (nonatomic,strong)UILabel *hospital;

@property (nonatomic,strong)DoctorApi *api;

@property (nonatomic,strong)DoctorModel *model;

@property (nonatomic,strong)NSString *shareUrl;


@end

@implementation DotorDetailViewController

- (UITableView *)tableview
{
    if (!_tableview) {
        
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _tableview.delegate = self;
        
        _tableview.backgroundColor = DefaultBackgroundColor;
        
        _tableview.dataSource = self;
        
        [_tableview registerClass:[IntroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IntroTableViewCell class])];

        [_tableview registerClass:[IntroTableViewCell class] forCellReuseIdentifier:@"time"];

        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableview.showsVerticalScrollIndicator = NO;

    }
    
    return _tableview;
    
}

- (void)LayoutSubview{
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (DoctorApi *)api
{
    
    if (!_api) {
        
        _api = [[DoctorApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    self.model = responsObject;
    
    self.name.text = self.model.name ? self.model.name:@"";
    
    [self.img sd_setImageWithURL:[NSURL URLWithString:self.model.facepath] placeholderImage:[UIImage imageNamed:@"用户"]];
    
    self.jop.text = [NSString stringWithFormat:@"%@ | %@",self.model.dname,self.model.job];
    
    self.hospital.text = self.model.hname;
    
    self.shareUrl = self.model.shareurl;
    
    self.title = self.model.name;
    
    [self.tableview reloadData];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    DoctorHeader *head = [[DoctorHeader alloc]init];
    
    head.target = @"noTokenPrefectureControl";
    
    head.method = @"doctorsDetail";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    DoctorBody *body = [[DoctorBody alloc]init];
    
    body.id = self.ID;
    
    DoctorIntroduceRuquset *request = [[DoctorIntroduceRuquset alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    [self.api doctorInfo:request.mj_keyValues.mutableCopy];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self setRightNavigationItemWithTitle:@"分享" action:@selector(toshare)];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 230)];
    self.headView.backgroundColor = DefaultBackgroundColor;
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    UIColor *topUIColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topUIColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    topView.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    [self.headView addSubview:topView];
    
    UIView *buttonView = [[UIView alloc]init];
    
    [self.headView addSubview:buttonView];
    
    buttonView.backgroundColor = [UIColor whiteColor];
    
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
    
    self.name.text = @"张三";
    
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
    
    self.jop.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
    
    [topView addSubview:self.jop];
    
    [self.jop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(lineView.mas_top);
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        
    }];
    
    self.hospital = [[UILabel alloc]init];
    
    self.hospital.textColor = [UIColor whiteColor];

    self.hospital.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
    
    [topView addSubview:self.hospital];
    
    [self.hospital mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jop.mas_bottom);
        make.left.mas_equalTo(lineView.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kScreenWidth - 40);
        
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        
        make.height.mas_equalTo(100);
        
        make.top.mas_equalTo(topView.mas_bottom).mas_equalTo(-30);
        
    }];
    
    CGFloat margin = ((kScreenWidth - 40) - 60 * 4)/5;
    
    NSArray *imag = @[@"c1",@"c2",@"c3",@"c4"];
    
    NSArray *labels = @[@"图文咨询",@"语音咨询",@"视频咨询",@"预约面诊"];
    
    for (int i= 0; i < 4; i++) {
        
        UIButton *iage = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [iage setImage:[UIImage imageNamed:imag[i]] forState:UIControlStateNormal];
        
        iage.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
        iage.frame = CGRectMake(i * 60 + (i+1)*margin, 10, 60, 60);
        
        iage.tag = i+1000;
        
        [buttonView addSubview:iage];
        
        [iage addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *iageLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        
        iageLabel.frame = CGRectMake(i * 60 + (i+1)*margin, CGRectGetMaxY(iage.frame), 60, 20);
        
        iageLabel.tag = i+1000;
        
        [buttonView addSubview:iageLabel];
        
        [iageLabel setTitleColor:DefaultGrayTextClor forState:UIControlStateNormal];
        
        iageLabel.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
        
        [iageLabel setTitle:labels[i] forState:UIControlStateNormal];
        
        [iageLabel addTarget:self action:@selector(jumpPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0,kScreenWidth - 40, 98) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6,6)];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskLayer.shadowColor=[UIColor grayColor].CGColor;
    maskLayer.shadowOffset=CGSizeMake(1, 2);
    maskLayer.shadowOpacity= 1;
    buttonView.layer.mask = maskLayer;
    
    [self.view addSubview:self.tableview];
    
    self.tableview.tableHeaderView  = self.headView;
    
    [self LayoutSubview];
        
}

- (void)jumpPage:(UIButton *)button{
    
    if (button.tag == 1000) {
        
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            
            UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
            
            //设置头像
            [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
            
            [manager pushUdeskInViewController:self completion:nil];
            //点击留言回调
            [manager leaveMessageButtonAction:^(UIViewController *viewController){
                
                UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
                [viewController presentViewController:offLineTicket animated:YES completion:nil];
                
            }];
            
            
        }
        
        
    }else if (button.tag == 1001){
        
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            
            
            [Utils callPhoneNumber:@"400-900-1169"];

//            UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
//
//            //设置头像
//            [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
//
//            [manager pushUdeskInViewController:self completion:nil];
//            //点击留言回调
//            [manager leaveMessageButtonAction:^(UIViewController *viewController){
//
//                UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
//                [viewController presentViewController:offLineTicket animated:YES completion:nil];
//
//            }];
        }
        
    }else if (button.tag == 1002){
        [MBProgressHUD bwm_showTitle:@"即将开通，敬请期待" toView:self.view hideAfter:2.0f msgType:BWMMBProgressHUDMsgTypeInfo];
    }else if (button.tag == 1003){
        if ([Utils showLoginPageIfNeeded]) {
        } else {
            MedicalDetailController *madicalDetail = [MedicalDetailController new];
            madicalDetail.title  =@"专家特诊";
            madicalDetail.gooid = @"2";
            madicalDetail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:madicalDetail animated:YES];
        }
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
    if (self.model.menzhen.length >0) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.model.menzhen.length >0) {
        
        if (indexPath.section == 0) {
            
            return [tableView fd_heightForCellWithIdentifier:@"time" cacheByIndexPath:indexPath configuration: ^(IntroTableViewCell *cell) {
                
                [cell refreWithdocModelTime:self.model];
                
            }];
            
        }else{
            
            return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([IntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(IntroTableViewCell *cell) {
                
                [cell refreWithdocModel:self.model];
                
            }];
        }
    }else{
        
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([IntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(IntroTableViewCell *cell) {
            
            [cell refreWithdocModel:self.model];
            
        }];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.model.menzhen.length >0) {
        
        if (indexPath.section == 0) {
            
            IntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"time"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell refreWithdocModelTime:self.model];
            
            return cell;
            
        }else{
            
            IntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntroTableViewCell class])];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell refreWithdocModel:self.model];
            
            return cell;
            
        }
        
    }else{
        
        IntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntroTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreWithdocModel:self.model];
        
        return cell;
        
    }
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
            return 0.00001;
        
    }else{
        
            return 0.00001;

    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.00001)];
        
    } else {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.00001)];

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
                [Utils postMessage:resp.message onView:self.view];
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                
                UMSocialLogInfo(@"response data is %@",data);
                
            }
        }
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = scrollView.contentOffset;
    NSLog(@"%f",translation.y);
    
    if (translation.y< 100) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationtitleView:nil];
            self.title = self.model.name;
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
            nikeName.text = self.model.name;
            [headImage sd_setImageWithURL:[NSURL URLWithString:self.model.facepath]];
            [self setNavigationtitleView:bgView];
        }];
    }
}


@end
