//
//  ExpertConsultViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ExpertConsultViewController.h"
#import "CountTableViewCell.h"
#import "IntroTableViewCell.h"
#import "UIButton+LXMImagePosition.h"
#import "DoctorApi.h"
#import "DoctorIntroduceRuquset.h"
#import "DoctorModel.h"
#import <UShareUI/UShareUI.h>
#import "CustomerViewController.h"
#import "ChatWithMachViewController.h"
#import "UINavigationBar+Extion.h"
#import "UIView+Extion.h"
#import "ButtonTableViewCell.h"
#import "MedicalDetailController.h"
#import "UdeskSDKManager.h"
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import "UdeskTicketViewController.h"
#import <APOpenAPI.h>
#import <DTShareKit/DTOpenAPI.h>
#define Max_OffsetY  50

#define WeakSelf(x)      __weak typeof (self) x = self

#define HalfF(x) ((x)/2.0f)


#define  Statur_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height
#define  NAVIBAR_HEIGHT  (self.navigationController.navigationBar.frame.size.height)
#define  INVALID_VIEW_HEIGHT (Statur_HEIGHT + NAVIBAR_HEIGHT)
@interface ExpertConsultViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

{
    CGFloat _lastPosition;
}
//@property (nonatomic,strong)PSBottomBar * bottomBar;
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UILabel * nikeNameLabel;
@property (nonatomic,strong)UILabel * jopNameLabel;
@property (nonatomic,strong)UILabel * hotelNameLabel;
@property (nonatomic,strong)UIView * headBackView;

@property (nonatomic,strong)UIImageView * headImageView;

@property (nonatomic,strong)UIButton * backButton;

@property (nonatomic,strong)UILabel * titleView;

@property (nonatomic,strong)UIButton * shareButton;
//

@property (nonatomic,strong)UIImageView *headView;

@property (nonatomic,strong)UITableView *customTableview;

@property (nonatomic,strong)UIView *contenView;

@property (nonatomic,strong)UIImageView *head;

@property (nonatomic,strong)UILabel *teamname;

@property (nonatomic,strong)UILabel *headername;

@property (nonatomic,strong)UILabel *jopname;

@property (nonatomic,strong)UILabel *hname;


@property (nonatomic,strong)UITextView *introduce;

@property (nonatomic,strong)DoctorApi *api;

@property (nonatomic,strong)DoctorModel *model;

@property (nonatomic,strong)NSString *shareUrl;

@end


@implementation ExpertConsultViewController


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self hiddenNavigationControllerBar:YES];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
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
    
    NSLog(@"%@",request);

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self hiddenNavigationControllerBar:NO];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)dealloc
{
    _headBackView = nil;
    _headImageView = nil;
}

- (UIButton *)backButton
{
    
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_backButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        
    }
    
    return _backButton;
    
}

- (UILabel *)titleView
{
    
    if (!_titleView) {
        
        _titleView = [[UILabel alloc]init];
        
        _titleView.backgroundColor = [UIColor clearColor];
        
        _titleView.textColor = [UIColor whiteColor];
        
        _titleView.text = @"我的团队";
        
        _titleView.font =  Font(18);
        
        _titleView.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleView;
    
}


- (UIButton *)shareButton
{
    
    if (!_shareButton) {
        
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        
    }
    
    return _shareButton;
    
}


- (UIView*)headBackView
{
    if (!_headBackView) {
        _headBackView = [UIView new];
        _headBackView.userInteractionEnabled = YES;
        _headBackView.frame = CGRectMake(0, 0, kScreenWidth,230);
    }
    return _headBackView;
}

- (UIImageView*)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [UIImageView new];
        _headImageView.image = [UIImage imageNamed:@"consult_bg"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        
    }
    return _headImageView;
}

- (UIImageView*)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIImageView new];
        _avatarView.image = [UIImage imageNamed:@"me_header"];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.size = CGSizeMake(80, 80);
        _avatarView.userInteractionEnabled = YES;
        [_avatarView setLayerWithCr:_avatarView.width / 2];
    }
    return _avatarView;
}

- (UILabel*)nikeNameLabel
{
    if (!_nikeNameLabel) {
        _nikeNameLabel = [UILabel new];
        _nikeNameLabel.textAlignment = NSTextAlignmentCenter;
        _nikeNameLabel.font = [UIFont systemFontOfSize:16];
        _nikeNameLabel.textColor = DefaultBlackLightTextClor;
        
    }
    return _nikeNameLabel;
}

- (UILabel*)jopNameLabel
{
    if (!_jopNameLabel) {
        _jopNameLabel = [UILabel new];
        _jopNameLabel.textAlignment = NSTextAlignmentCenter;
        _jopNameLabel.font = [UIFont systemFontOfSize:16];
        _jopNameLabel.textColor = DefaultGrayTextClor;
    }
    return _jopNameLabel;
}

- (UILabel*)hotelNameLabel
{
    if (!_hotelNameLabel) {
        _hotelNameLabel = [UILabel new];
        _hotelNameLabel.textAlignment = NSTextAlignmentCenter;
        _hotelNameLabel.font = [UIFont systemFontOfSize:16];
        _hotelNameLabel.textColor = DefaultGrayTextClor;
        
    }
    return _hotelNameLabel;
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
    
    self.nikeNameLabel.text = self.model.name ? self.model.name:@"";
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:self.model.facepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    
    self.jopNameLabel.text = [NSString stringWithFormat:@"%@ | %@",self.model.dname,self.model.job];
    self.hotelNameLabel.text = self.model.hname;
    
    self.shareUrl = self.model.shareurl;
    
    self.titleView.text = self.model.name;
    
    [self.customTableview reloadData];
    
    
}


- (UITableView *)customTableview
{
    
    if (!_customTableview) {
        
        _customTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _customTableview.delegate  =  self;
        
        _customTableview.dataSource = self;
        
        _customTableview.backgroundColor = [UIColor clearColor];
        
        _customTableview.separatorColor = [UIColor whiteColor];
    }
    
    return _customTableview;
    
}


- (void)layOutSubview{
    
    [self.customTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)resetHeaderView
{
    
    self.headImageView.frame = self.headBackView.bounds;
    [self.headBackView addSubview:self.headImageView];
    
    self.avatarView.centerX = self.headBackView.centerX;
    self.avatarView.centerY = self.headBackView.centerY -  HalfF(20);
    [self.headBackView addSubview:self.avatarView];
    
    self.nikeNameLabel.y = CGRectGetMaxY(self.avatarView.frame) + HalfF(10);
    self.nikeNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.nikeNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.nikeNameLabel];
    
    self.jopNameLabel.y = CGRectGetMaxY(self.nikeNameLabel.frame) + HalfF(5);
    self.jopNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.jopNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.jopNameLabel];
    
    
    self.hotelNameLabel.y = CGRectGetMaxY(self.jopNameLabel.frame) + HalfF(5);
    self.hotelNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30), 20);
    self.hotelNameLabel.centerX = self.headBackView.centerX;
    [self.headBackView addSubview:self.hotelNameLabel];
    
    [self.headBackView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(24);
        
    }];
    
    [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.headBackView addSubview:self.titleView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.centerX.mas_equalTo(self.avatarView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(16);
        
    }];
    
    [self.headBackView addSubview:self.shareButton];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.right.mas_equalTo(-14);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
    }];
    
    [self.shareButton addTarget:self action:@selector(toshare) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *sep = [[UIView alloc]init];
    
    [self.headBackView addSubview:sep];
    
    sep.backgroundColor = DefaultBackgroundColor;

    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.hotelNameLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
  
    //添加按钮
    //image在上，文字在下
    //图片是60*60的2x的图
//    UIView *buttonContentView = [[UIView alloc]init];
//    
//    [self.headBackView addSubview:buttonContentView];
//    
//    [buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(sep.mas_bottom).mas_equalTo(10);
//        make.height.mas_equalTo(100);
//        
//    }];
//    
////
//    for (NSInteger index = 0; index < 4; index++) {
//        
//        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth/4)*(index +1),15, 1, 45)];
//        
//        rightView.backgroundColor = DividerGrayColor;
//        
//        [buttonContentView addSubview:rightView];
//        
//    }
//    
//    NSArray *imageArr0 = @[@"c1",@"c2",@"z5",@"c4"];
//    
//    NSMutableArray *titleArr = @[@"图文咨询",@"语音咨询",@"视频咨询",@"预约面诊"].mutableCopy;
//    
//    for (NSInteger i = 0; i < 4; i++) {
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//        
//        button.frame = CGRectMake(i * (kScreenWidth/4)-5 ,buttonContentView.center.y+20,90, 80);
//        
//        button.tag = 1000+i;
//        
//        [button setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
//        
//        [button setTitleColor:DefaultBlueTextClor forState:UIControlStateSelected];
//        
//        [button addTarget:self action:@selector(buttionAction:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [button setImage:[UIImage imageNamed:imageArr0[i]] forState:UIControlStateNormal];
//        [button setTitle:titleArr[i] forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:0.5];
//        CGFloat imageWidth = 60;
//        CGFloat imageHeight = 60;
//        CGFloat spacing = 6;
//        CGFloat labelWidth = [button.titleLabel.text sizeWithFont:button.titleLabel.font].width;
//        CGFloat labelHeight = [button.titleLabel.text sizeWithFont:button.titleLabel.font].height;
//        CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 3;//image中心移动的x距离
//        CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
//        CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
//        CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
//        
//        button.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX+5);
//        [buttonContentView addSubview:button];
//        
//    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.customTableview registerClass:[CountTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CountTableViewCell class])];
    
    [self.customTableview registerClass:[IntroTableViewCell class] forCellReuseIdentifier:NSStringFromClass([IntroTableViewCell class])];
    
    [self.customTableview registerNib:[UINib nibWithNibName:@"ButtonTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ButtonTableViewCell class])];

    [self resetHeaderView];

    self.customTableview.tableHeaderView = self.headBackView;

    self.view.backgroundColor = DefaultBackgroundColor;
    
    [self.view addSubview:self.customTableview];
    
  
    
    [self layOutSubview];

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
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    NSLog(@"上下偏移量 OffsetY:%f ->",offset_Y);
    
    //1.处理图片放大
    CGFloat imageH = self.headBackView.size.height;
    CGFloat imageW = kScreenWidth;
    
    //下拉
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }
    else
    {
        self.headImageView.frame = self.headBackView.bounds;
    }
    
    //2.处理导航颜色渐变  3.底部工具栏动画
    
    if (offset_Y > Max_OffsetY)
    {
        CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
        
        //        [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:alpha]];
        
        if (offset_Y - _lastPosition > 5)
        {
            //向上滚动
            _lastPosition = offset_Y;
            
        }
        else if (_lastPosition - offset_Y > 5)
        {
            // 向下滚动
            _lastPosition = offset_Y;
        }
        //        self.title = alpha > 0.8? self.nikeNameLabel.text:@"";
        
        //        [self setNavigationTitleViewWithView:alpha > 0.8? self.nikeNameLabel.text:@"" timerWithTimer:nil];
        
    }
    else
    {
        //        [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:0]];
        
    }
    
    //滚动至顶部
    
    if (offset_Y < 0) {
        
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return CGFLOAT_MIN;
    return 4;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return 80;
        
    }else{
    
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([IntroTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(IntroTableViewCell *cell) {
            
            [cell refreWithdocModel:self.model];
            
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ButtonTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.pic = ^{
            
            
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
            
            
        };
        
        
        cell.vio = ^{
            
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

        };
        
        cell.ved = ^{
            
            [Utils postMessage:@"即将开通此功能" onView:self.view];
            
        };
        
        cell.yu = ^{
            
            if ([Utils showLoginPageIfNeeded]) {
                
            } else {
                
                MedicalDetailController *madicalDetail = [MedicalDetailController new];
                
                madicalDetail.title  =@"专家特诊";
                
                madicalDetail.gooid = @"2";
                
                madicalDetail.hidesBottomBarWhenPushed = YES;

                [self.navigationController pushViewController:madicalDetail animated:YES];
   
                
            }

        };

        
        return cell;
        
        
    }else{
        
        IntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IntroTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell refreWithdocModel:self.model];
        
        return cell;

    }
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
