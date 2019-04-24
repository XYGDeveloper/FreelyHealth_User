//
//  MeViewController.m
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MeViewController.h"
#import "CustomTableViewCell.h"
#import "HeadView.h"
#import "LoginViewController.h"
#import "User.h"
#import "OrderFillViewController.h"
#import "MedicalTreatmentViewController.h"
#import "MyFilesViewController.h"
#import "MyOrderViewController.h"
#import "IndexManagerFillDataViewController.h"
#import "UIImage+ImageEffects.h"
#import "LoginOutApi.h"
#import "LoginOutRequest.h"
#import "MyDoctorListViewController.h"
#import "AboutMeViewController.h"
#import "UIViewController+Base.h"
#import "UIImage+GradientColor.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "MyProfileViewController.h"
#import "WKWebViewController.h"
//test
#import "MedicalFillOrderViewController.h"
#import "SubscribeListViewController.h"
#import "ToSubsViewController.h"
#import "HClActionSheet.h"
#import "CaseListViewController.h"
#import "CommonPatientsViewController.h"
#import "AppionmentListViewController.h"
#import "MessageListViewController.h"
//
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import <UShareUI/UShareUI.h>
#import <APOpenAPI.h>
#import <DTShareKit/DTOpenAPI.h>
#import "MyconponViewController.h"
#import "RootManager.h"
#import "GetConponManager.h"
#import "MymessageListRequest.h"
#import "getMessageListApi.h"
#import "getMessageCountApi.h"
#import "LKBadgeView.h"
#import "BadgeTableViewCell.h"
#import "MyMessageModel.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ApiRequestDelegate>{
    CGFloat _lastPosition;
}
//@property (nonatomic,strong)PSBottomBar * bottomBar;
@property (nonatomic,strong)UIImageView * avatarView;
@property (nonatomic,strong)UILabel * nikeNameLabel;
@property (nonatomic,strong)UILabel * companyLabel;
@property (nonatomic,strong)UIImageView * flageImage;
@property (nonatomic,strong)UILabel * hotelTitleLabel;
@property (nonatomic,strong)UIView * headBackView;
@property (nonatomic,strong)UIImageView * headImageView;

@property (nonatomic,strong)UITableView *meTableView;

@property (nonatomic,strong)HeadView *headView;

@property (nonatomic,strong)UIView *naviBar;

@property (nonatomic,strong)UILabel *naviTitle;

@property (nonatomic,strong)LoginOutApi *loginOutApi;

@property (nonatomic,strong)CustomTableViewCell *cell;

@property (nonatomic,strong)HClActionSheet *loginout;

@property (nonatomic,strong)UILabel *bageLabel;
@property (nonatomic,strong)LKBadgeView *badge;
@property (nonatomic,assign)int count;
//
@property (nonatomic,strong)getMessageListApi *messageApi;
@property (nonatomic,strong)NSMutableArray *messageArray;

@end

@implementation MeViewController

- (getMessageListApi *)messageApi{
    if (!_messageApi) {
        _messageApi = [[getMessageListApi alloc]init];
        _messageApi.delegate  =self;
    }
    return _messageApi;
}

- (NSMutableArray *)messageArray{
    if (!_messageArray) {
        _messageArray = [NSMutableArray array];
    }
    return _messageArray;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"auScuess" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMessagecount) name:@"messageCount" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (LoginOutApi *)loginOutApi
{
    if (!_loginOutApi) {
        _loginOutApi = [[LoginOutApi alloc]init];
        _loginOutApi.delegate  =self;
    }
    return _loginOutApi;
}

- (UIView*)headBackView
{
    if (!_headBackView) {
        _headBackView = [UIView new];
        _headBackView.userInteractionEnabled = YES;
        _headBackView.frame = CGRectMake(0,0, kScreenWidth,200);
    }
    return _headBackView;
}

- (UIImageView*)headImageView
{
    if (!_headImageView)
    {
        _headImageView = [UIImageView new];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.clipsToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        _headImageView.backgroundColor = [UIColor orangeColor];
    }
    return _headImageView;
}

- (UIImageView*)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_avatarView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath]];
        _avatarView.contentMode = UIViewContentModeScaleToFill;
        _avatarView.userInteractionEnabled = YES;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
       _avatarView.clipsToBounds = YES;
        [_avatarView setLayerWithCr:_avatarView.width / 2];
        _avatarView.layer.borderWidth = 0.5;
        _avatarView.layer.borderColor = HexColor(0x1BC8E1).CGColor;
    }
    return _avatarView;
}

- (UIImageView*)flageImage
{
    if (!_flageImage) {
        _flageImage = [UIImageView new];
        _flageImage.contentMode = UIViewContentModeScaleToFill;
        _flageImage.size = CGSizeMake(18, 18);
        _flageImage.userInteractionEnabled = YES;
    }
    return _flageImage;
}

- (UILabel*)nikeNameLabel
{
    if (!_nikeNameLabel) {
        _nikeNameLabel = [UILabel new];
        _nikeNameLabel.textAlignment = NSTextAlignmentLeft;
        _nikeNameLabel.userInteractionEnabled = YES;
        _nikeNameLabel.font = FontNameAndSize(16);
        _nikeNameLabel.textColor = [UIColor whiteColor];
        _nikeNameLabel.userInteractionEnabled = YES;
    }
    return _nikeNameLabel;
}

- (UILabel*)companyLabel
{
    if (!_companyLabel) {
        _companyLabel = [UILabel new];
        _companyLabel.textAlignment = NSTextAlignmentLeft;
        _companyLabel.userInteractionEnabled = YES;
        _companyLabel.numberOfLines = 0;
        _companyLabel.font = FontNameAndSize(16);
        _companyLabel.textColor = [UIColor whiteColor];
    }
    return _companyLabel;
}

#pragma mark --
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.meTableView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationController.navigationBar.translucent = YES;
    NSLog(@"%@",[User LocalUser].name);
    [self refreshMessagecount];
}

- (void)refreshMessagecount{
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenNavigationControllerBar:NO];
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.navigationController.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)resetHeaderView
{
    self.headImageView.frame = self.headBackView.bounds;
    self.headImageView.image = [UIImage imageNamed:@"sss"];

    [self.headBackView addSubview:self.headImageView];
    
    [self.headBackView addSubview:self.hotelTitleLabel];
    
    [self.hotelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headBackView.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(20);
    }];
 
    UIView *shadowView = [[UIView alloc]init];
    shadowView.left = self.headBackView.left +15;
    shadowView.centerY = self.headBackView.centerY - 20;
    shadowView.size = CGSizeMake(80, 80);
    [self.headBackView addSubview:shadowView];

    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    
    shadowView.layer.shadowOpacity = 0.5;
    
    shadowView.layer.shadowRadius = 1.0;
    
    shadowView.layer.cornerRadius = 2.0;
    
    shadowView.clipsToBounds = NO;
    
    [shadowView addSubview:self.avatarView];
    
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath?[User LocalUser].facepath:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3812448785,1198799034&fm=26&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"nologin"]];
    NSRange range = {3,4};
    self.companyLabel.text = [User LocalUser].company;
    self.companyLabel.preferredMaxLayoutWidth = kScreenWidth/2;
    [self.companyLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.nikeNameLabel.text = [User LocalUser].phone ? [[User LocalUser].phone stringByReplacingCharactersInRange:range withString:@"****"]:@"登录/注册";
    self.nikeNameLabel.left = shadowView.right + HalfF(15);
    self.nikeNameLabel.size = CGSizeMake(kScreenWidth - HalfF(30),25);
    self.nikeNameLabel.centerY = [User LocalUser].token ? shadowView.centerY - 10:shadowView.centerY;
    [self.headBackView addSubview:self.nikeNameLabel];
    if ([[User LocalUser].isvip isEqualToString:@"1"]) {
        self.flageImage.image = [UIImage imageNamed:@"vip_flage"];
        [self.headBackView addSubview:self.companyLabel];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nikeNameLabel.bottom);
            make.left.mas_equalTo(shadowView.mas_right).mas_equalTo(HalfF(20));
        }];
        [self.headBackView addSubview:self.flageImage];
        [self.flageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.companyLabel.mas_right).mas_equalTo(5);
            make.width.height.mas_equalTo(20);
            make.top.mas_equalTo(self.companyLabel.mas_top);
        }];
        
    }else{
        self.flageImage.image = [UIImage imageNamed:@""];
        [self.headBackView addSubview:self.companyLabel];
        [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nikeNameLabel.bottom);
            make.left.mas_equalTo(shadowView.mas_right).mas_equalTo(HalfF(20));
        }];
        [self.headBackView addSubview:self.flageImage];
        [self.flageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.companyLabel.mas_right).mas_equalTo(5);
            make.width.height.mas_equalTo(20);
            make.top.mas_equalTo(self.companyLabel.mas_top);
        }];
    }
    
}

- (UITableView *)meTableView
{
    if (!_meTableView) {
        _meTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _meTableView.delegate = self;
        _meTableView.dataSource = self;
        _meTableView.backgroundColor = DefaultBackgroundColor;
        _meTableView.showsVerticalScrollIndicator = NO;
        _meTableView.separatorColor = RGB(213, 231, 233);
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        footview.backgroundColor = DefaultBackgroundColor;
        _meTableView.tableFooterView = footview;
        if (@available(iOS 11.0, *)){
            _meTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _meTableView;
    
}

- (void)layOutSubview{
        [self.meTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.meTableView];
    [self resetHeaderView];
    self.meTableView.tableHeaderView = self.headBackView;
    [self.meTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
     [self.meTableView registerClass:[BadgeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BadgeTableViewCell class])];
    [self.meTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"info1"];
      [self.meTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"phonecell"];
    [self.meTableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CustomTableViewCell class])];

    [self layOutSubview];
    
//    [self.meTableView reloadData];
    
    [_avatarView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toUpdate)]];
    
    [_nikeNameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLogin)]];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMe:) name:@"auScuess" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshLoginOutMe:) name:@"loginOutScuess" object:nil];
    
}

- (void)refreshMe:(NSNotification *)noti{
    
    if ([noti.name isEqualToString:@"auScuess"]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath?[User LocalUser].facepath:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3812448785,1198799034&fm=26&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"nologin"]];
//            NSRange range = {3,4};
//              self.nikeNameLabel.text =  [[User LocalUser].phone stringByReplacingCharactersInRange:range withString:@"****"];
            [self resetHeaderView];
            [self.meTableView reloadData];
            [[GetConponManager sharedConpon] getConpon];
        });
    }
    
}


- (void)refreshLoginOutMe:(NSNotification *)noti{
    
    if ([noti.name isEqualToString:@"loginOutScuess"]) {
        [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[User LocalUser].facepath?[User LocalUser].facepath:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3812448785,1198799034&fm=26&gp=0.jpg"] placeholderImage:[UIImage imageNamed:@"nologin"]];
        [self resetHeaderView];
        self.count = 0;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.meTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.meTableView reloadData];
    }
}

//修改资料

- (void)toUpdate{
    
    if (![User hasLogin]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
    } else {
        MyProfileViewController *profile =[MyProfileViewController new];
        profile.title = @"用户资料编辑";
        [self.navigationController pushViewController:profile animated:YES];
    }
}


- (void)toLogin{
    
    if (![User hasLogin]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [[RootManager sharedManager].tabbarController presentViewController:nav animated:YES completion:nil];
    } else {
        MyProfileViewController *profile =[MyProfileViewController new];
        profile.title = @"用户资料编辑";
        [self.navigationController pushViewController:profile animated:YES];
    }
    
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_Y = scrollView.contentOffset.y;
    //1.处理图片放大
    CGFloat imageH = self.headBackView.size.height;
    CGFloat imageW = kScreenWidth;
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headImageView.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }else{
        
    }
    if (scrollView.contentOffset.y > 20 ) {
        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        UIImage *alphaimage = [self imageByApplyingAlpha:(scrollView.contentOffset.y-100)/200 image:bgImg];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithPatternImage:alphaimage]] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return 4;
    }else if (section == 2){
        return 3;
    }else{
        return 1;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            BadgeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BadgeTableViewCell class])];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell refreshWith:@"me_news" textlabeltext:@"我的消息" count:[NSString stringWithFormat:@"%d",self.count]];
            return cell;
            
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"info1"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = FontNameAndSize(16);
            NSMutableArray *arr0 = [NSMutableArray arrayWithCapacity:4];
            arr0 = [NSMutableArray arrayWithObjects:@"我的消息",@"我的订单",@"体检预约",@"会诊请求",@"优惠券", nil];
            cell.textLabel.text = [arr0 objectAtIndex:indexPath.row];
            NSArray *images0 = @[@"me_news",@"me_order",@"me_bespeak",@"me_request",@"me_coupon"];
            cell.imageView.image = [UIImage imageNamed:images0[indexPath.row]];
            return cell;
        }
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];
        NSMutableArray *arr1 = [NSMutableArray arrayWithCapacity:4];
        arr1 = [NSMutableArray arrayWithObjects:@"我的档案",@"病历管理",@"指标管理",@"常用患者", nil];
        NSArray *images0 = @[@"me_archives",@"me_record",@"me_index",@"me_used"];
        cell.imageView.image = [UIImage imageNamed:images0[indexPath.row]];
        cell.textLabel.text = [arr1 objectAtIndex:indexPath.row];
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 1){
             UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phonecell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];
            cell.textLabel.text = @"联系客服";
            cell.imageView.image = [UIImage imageNamed:@"me_service"];
            button.frame =  CGRectMake(0, 0, 120, 30);
            [button setTitle:@"400-900-1169" forState:UIControlStateNormal];
            button.titleLabel.font = FontNameAndSize(14);
            [button setTitleColor:DefaultGrayTextClor forState:UIControlStateNormal];
            cell.accessoryView = button;
            [button addTarget:self action:@selector(customerPhone) forControlEvents:UIControlEventTouchUpInside];
            return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
            cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"邀请分享";
                cell.imageView.image = [UIImage imageNamed:@"me_share"];
          
            return cell;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于我们";
            cell.imageView.image = [UIImage imageNamed:@"me_we"];
        return cell;
    }
    else{
    
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.backgroundColor = [UIColor clearColor];
        
        [cell refreshWithisLogin:[User hasLogin]];
        
        cell.loginout = ^{
            self.loginout = [[HClActionSheet alloc] initWithTitle:@"退出登录不会删除数据，下次登录依然使用本账号" style:HClSheetStyleWeiChat itemTitles:@[@"退出登录"]];
            self.loginout.delegate = self;
            self.loginout.tag = 100;
            self.loginout.titleTextColor = DefaultGrayLightTextClor;
            self.loginout.titleTextFont = Font(16);
            self.loginout.itemTextFont = [UIFont systemFontOfSize:16];
            self.loginout.itemTextColor = AppStyleColor;
            self.loginout.cancleTextFont = [UIFont systemFontOfSize:16];
            self.loginout.cancleTextColor = DefaultGrayTextClor;
            [self.loginout didFinishSelectIndex:^(NSInteger index, NSString *title) {
                NSLog(@"%ld",index);
                if (index == 0) {
                    [Utils addHudOnView:self.view];
                    LoginOutHeader *head = [[LoginOutHeader alloc]init];
                    head.target = @"loginControl";
                    head.method = @"logout";
                    head.versioncode = Versioncode;
                    head.devicenum = Devicenum;
                    head.fromtype = Fromtype;
                    head.token = [User LocalUser].token;
                    LoginOutBody *body = [[LoginOutBody alloc]init];
                    LoginOutRequest *request = [[LoginOutRequest alloc]init];
                    request.head = head;
                    request.body = body;
                    NSLog(@"%@",request);
                    [self.loginOutApi LoginOut:request.mj_keyValues.mutableCopy];
                    [self.meTableView setContentOffset:CGPointMake(0,0) animated:NO];
                }
            }];
         
        };
        return cell;
    }
    
}

- (void)customerPhone{
    
    [Utils callPhoneNumber:@"400-900-1169"];

}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [Utils removeHudFromView:self.view];
    
    if (api == _loginOutApi) {
        [User clearLocalUser];
        [Utils postMessage:command.response.msg onView:self.view];
        self.count = 0;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.meTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
        [self.meTableView reloadData];
    }
    
    if (api == _messageApi) {
        
    }
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [Utils removeHudFromView:self.view];
    
    if (api == _loginOutApi) {
        [User clearLocalUser];
        self.count = 0;
        [Utils postMessage:@"退出登录成功" onView:self.view];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.meTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self.meTableView reloadData];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loginOutScuess" object:nil];
    }

    if (api == _messageApi) {
        NSArray *array = responsObject;
        self.messageArray = [NSMutableArray array];
        [self.messageArray removeAllObjects];
        if (array.count <= 0) {
            self.count = 0;
        } else {
            for (MyMessageModel *model in array) {
                if ([model.status isEqualToString:@"0"]) {
                    [self.messageArray addObject:model];
                }
            }
        }
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                             @(ConversationType_PRIVATE), @(ConversationType_GROUP)
                                                                             ]];
        int udeskUnreadmessagecount =  (int)[UdeskManager getLocalUnreadeMessagesCount];
        self.count = self.messageArray.count + unreadMsgCount + udeskUnreadmessagecount;
        NSLog(@"uuuu%d   %d    %d  ",unreadMsgCount,udeskUnreadmessagecount,self.count);
        [self.meTableView reloadData];
    }
    [self.meTableView reloadData];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    MessageListViewController *messagelist = [MessageListViewController new];
                    messagelist.title = @"我的消息";
                    [self.navigationController pushViewController:messagelist animated:YES];
                }
            }
        }else if (indexPath.row == 1)
        {
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    MyOrderViewController *order = [MyOrderViewController new];
                    order.title = @"我的订单";
                    order.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:order animated:YES];
                }
            }
        }else if (indexPath.row == 2)
        {
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    SubscribeListViewController *sub = [SubscribeListViewController new];
                    sub.title = @"预约列表";
                    sub.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:sub animated:YES];
                }
            }
        }else if (indexPath.row == 3)
        {
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    AppionmentListViewController *plist = [AppionmentListViewController new];
                    plist.title = @"会诊请求";
                    plist.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:plist animated:YES];
                }
            }
        }else{
            MyconponViewController *conpon = [MyconponViewController new];
            conpon.title = @"优惠券";
            [self.navigationController pushViewController:conpon animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    MyFilesViewController *file = [MyFilesViewController new];
                    file.hidesBottomBarWhenPushed = YES;
                    file.title = @"我的档案";
                    [self.navigationController pushViewController:file animated:YES];
                }
            }
        }else if (indexPath.row ==1){
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    CaseListViewController *caseList = [CaseListViewController new];
                    caseList.title = @"病历列表";
                    caseList.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:caseList animated:YES];
                }
            }
        }else if (indexPath.row == 2){
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    IndexManagerFillDataViewController *indexManager = [IndexManagerFillDataViewController new];
                    indexManager.title = @"指标管理";
                    indexManager.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:indexManager animated:YES];
                }
            }
        }else{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    CommonPatientsViewController *plist = [CommonPatientsViewController new];
                    plist.title = @"患者列表";
                    plist.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:plist animated:YES];
                }
            }
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            if ([Utils showLoginPageIfNeeded]) {
            } else {
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
                [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo){
                    [self shareWebPageToPlatformType:platformType];
                }];
            }
        }else if (indexPath.row == 1){
            [Utils callPhoneNumber:@"400-900-1169"];
        }else{
            AboutMeViewController *aboutMe = [AboutMeViewController new];
            aboutMe.title  = @"关于我们";
            aboutMe.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutMe animated:YES];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        return nil;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0)
            return CGFLOAT_MIN;
        return 10;
    }else{
        if (section == 0)
            return CGFLOAT_MIN;
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"这个App对我们太有用了" descr:@"为用户提供肿瘤精准全案服务，直面有效，精准的医疗服务。为肿瘤患者和高危人群提供全面的健康管理和便捷的就医通道。" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = [NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/shareAppDownload.html?userid=%@",[User LocalUser].id];
    NSLog(@"%@    %@",[User LocalUser].id,[NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/shareAppDownload.html?userid=%@",[User LocalUser].id]);
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

@end
