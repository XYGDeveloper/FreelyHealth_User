//
//  ZYindexViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/1.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ZYindexViewController.h"
#import "UIImage+GradientColor.h"
#import "JQFlowView.h"
#import "UdeskSDKManager.h"
#import "JQIndexBannerSubview.h"
#import "GetIndexBannerRequest.h"
#import "GetIndexBannerApi.h"
#import "IndexBannerModel.h"
#import "IndexTableViewCell.h"
#import "WKWebViewController.h"
#import "UdeskTicketViewController.h"
#import "TableViewController.h"
#import "PDFWebViewViewController.h"
#import "ServiceTypeTableViewCell.h"
#import "TJMenuViewController.h"
#import "GeneDetectionViewController.h"
#import "MedicalTreatmentViewController.h"
#import "NationInsureViewController.h"
#import "MiddleTableViewCell.h"
#import "PopularDetailViewController.h"
#import "ConsultIndexModel.h"
#import "TumorZoneListApi.h"
#import "TumorZoneRequest.h"
#import "TumorZoneListModel.h"
#import "MBProgressHUD+BWMExtension.h"
#import "TJFLViewController.h"
#import "LYZToast.h"
#import "LYZAdView.h"
#import "TumorZoneListApi.h"
#import "TumorZoneRequest.h"
#import "QueryConponApi.h"
#import "MessageListViewController.h"
#import "UdeskSDKManager.h"
#import "MyMessageModel.h"
#import "MymessageListRequest.h"
#import "getMessageListApi.h"
#import "getMessageCountApi.h"
@interface ZYindexViewController ()<UITableViewDelegate,UITableViewDataSource,JQFlowViewDelegate,JQFlowViewDataSource,ApiRequestDelegate,BaseMessageViewDelegate>
@property (nonatomic,strong)UITableView *indexTableview;
@property (nonatomic,strong)UIView *indexTableviewHeaderView;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) JQFlowView *pageFlowView;
@property (nonatomic, strong) UIScrollView *scrollView; // 轮播图容器
@property (nonatomic, strong) GetIndexBannerApi *bannerApi;
@property (nonatomic,strong)TumorZoneListApi *TumorZoneApi;
@property (nonatomic,strong)NSMutableArray *BannerArray;
@property (nonatomic,strong)TumorZoneListModel *model;
@property (nonatomic, strong) LYZToast *toast;
@property (nonatomic,strong)getMessageCountApi *countApi;
@property (nonatomic,strong)NSArray *banners;

@end

@implementation ZYindexViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.indexTableview.mj_header beginRefreshing];
    [self showToast];
}

- (getMessageCountApi *)countApi{
    if (!_countApi) {
        _countApi = [[getMessageCountApi alloc]init];
        _countApi.delegate  = self;
    }
    return _countApi;
}

-(void)showToast{
    
    if ([User hasLogin]) {
        myMessageHeader *head = [[myMessageHeader alloc]init];
        head.target = @"userMsgControl";
        head.method = @"queryUserMsgCounts";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        myMessageBody *body = [[myMessageBody alloc]init];
        MymessageListRequest *request = [[MymessageListRequest alloc]init];
        request.head = head;
        request.body = body;
        NSLog(@"%@",request);
        [self.countApi getMessageCounts:request.mj_keyValues.mutableCopy];
    }
}

- (GetIndexBannerApi *)bannerApi
{
    if (!_bannerApi) {
        _bannerApi = [[GetIndexBannerApi alloc]init];
        _bannerApi.delegate = self;
    }
    return _bannerApi;
}

- (TumorZoneListApi *)TumorZoneApi{
    if (!_TumorZoneApi) {
        _TumorZoneApi = [[TumorZoneListApi alloc]init];
        _TumorZoneApi.delegate = self;
    }
    return _TumorZoneApi;
}

- (NSMutableArray *)BannerArray
{
    if (!_BannerArray) {
        _BannerArray = [NSMutableArray array];
    }
    return _BannerArray;
}
- (UITableView *)indexTableview{
    if (!_indexTableview) {
        _indexTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49) style:UITableViewStyleGrouped];
        _indexTableview.delegate =self;
        _indexTableview.dataSource = self;
        _indexTableview.separatorColor = RGB(213, 231, 233);
        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
        footview.backgroundColor = DefaultBackgroundColor;
        _indexTableview.tableFooterView = footview;
        _indexTableview.showsVerticalScrollIndicator = NO;
        _indexTableview.backgroundColor = DefaultBackgroundColor;
        _indexTableview.separatorColor = [UIColor whiteColor];
    }
    return _indexTableview;
}

- (UIView *)indexTableviewHeaderView{
    if (!_indexTableviewHeaderView) {
        _indexTableviewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth - 84) * 9 / 16 + 24)];
        _indexTableviewHeaderView.backgroundColor = [UIColor whiteColor];
        UIImageView *headerviewBgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, ((kScreenWidth - 84) * 9 / 16 + 24)/2)];
        [_indexTableviewHeaderView addSubview:headerviewBgview];
        UIColor *topUIColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topUIColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        headerviewBgview.image = bgImg;
    }
    return _indexTableviewHeaderView;
}
#pragma mark -- 下面是轮播图 --
- (JQFlowView *)pageFlowView{
    if (!_pageFlowView) {
        _pageFlowView = [[JQFlowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenWidth - 84) * 9 / 16 + 24)];
        _pageFlowView.backgroundColor = [UIColor clearColor];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.4;
        _pageFlowView.minimumPageScale = 0.90;
        _pageFlowView.orginPageCount = self.imageArray.count;
        _pageFlowView.isOpenAutoScroll = YES;
        _pageFlowView.autoTime = 2.0;
        _pageFlowView.orientation = JQFlowViewOrientationHorizontal;
    }
    return _pageFlowView;
}

- (void)scanInfo{
    if ([Utils showLoginPageIfNeeded]) {
    } else {
        if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
            [Utils postMessage:@"网络连接已断开" onView:self.view];
        }else{
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
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    IndexBannerHeader *head = [[IndexBannerHeader alloc]init];
    head.target = @"mainControl";
    head.method = @"getMainBannerList";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    IndexBannerBody *body = [[IndexBannerBody alloc]init];
    GetIndexBannerRequest *request = [[GetIndexBannerRequest alloc]init];
    request.head = head;
    request.body = body;
    NSLog(@"99%@",request);
    [self.bannerApi getBannerList:request.mj_keyValues.mutableCopy];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.indexTableview];
    [self.indexTableviewHeaderView addSubview:self.pageFlowView];
    self.indexTableview.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        TumorZoneHeader *header = [[TumorZoneHeader alloc]init];
        
        header.target = @"noTokenPrefectureControl";
        
        header.method = @"prefectureFirst";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        TumorZoneBody *bodyer = [[TumorZoneBody alloc]init];
        
        bodyer.id = @"1";
        
        TumorZoneRequest *requester = [[TumorZoneRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        [self.TumorZoneApi TumorZoneList:requester.mj_keyValues.mutableCopy];
    }];
    
    [self.indexTableview.mj_header beginRefreshing];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"refreshindex" object:nil];
  
    UIColor *topUIColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topUIColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    self.indexTableview.mj_header.backgroundColor = [UIColor colorWithPatternImage:bgImg];
    self.indexTableview.tableHeaderView = self.indexTableviewHeaderView;
    [self.indexTableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.indexTableview registerNib:[UINib nibWithNibName:@"IndexTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndexTableViewCell class])];
    [self.indexTableview registerClass:[MiddleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MiddleTableViewCell class])];
    [self.indexTableview registerClass:[ServiceTypeTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ServiceTypeTableViewCell class])];
    
}

- (void)refresh:(NSNotification *)noti{
    if ([noti.name isEqualToString:@"refreshindex"]) {

        [self.indexTableview.mj_header beginRefreshing];
        
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    [self.indexTableview.mj_header endRefreshing];
//    self.imageArray = [NSMutableArray array];
//    self.imageArray = @[@"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170914/acf1575275ca40cd85c5e403d12ee679.png",@"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20171128/ok.png",@"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170914/2ed68040d3f240999f3683bff9c684cc.png"].mutableCopy;
//    [_pageFlowView reloadData];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [self.indexTableview.mj_header endRefreshing];
    if (api == _bannerApi) {
        self.imageArray = [NSMutableArray array];
        [self.imageArray removeAllObjects];
        self.banners = responsObject;
        for (IndexBannerModel *model in responsObject) {
            [self.imageArray addObject:model.imgpath];
        }
        [self.pageFlowView reloadData];
        [self.indexTableview reloadData];
    }
    if (api == _TumorZoneApi) {
        self.model = [TumorZoneListModel mj_objectWithKeyValues:responsObject];
        self.BannerArray = [infomationModel mj_objectArrayWithKeyValuesArray:self.model.informations];
        NSLog(@"%@",self.BannerArray);
        [self.indexTableview reloadData];
    }
    
    if (api == _countApi) {
        NSNumber *number = responsObject[@"userMsgCounts"];
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),
                                                                             @(ConversationType_GROUP)]];
        int count = (int)[UdeskManager getLocalUnreadeMessagesCount];
        int counts = count + [number intValue] + unreadMsgCount;
        if (counts > 0) {
            _toast = [[LYZToast alloc] initToastWithTitle:[NSString stringWithFormat:@"消息提醒：您有%d条未读消息",counts] message:@"立即查看" iconImage:nil];
            _toast.supView = self.view;
            [_toast show:^{
                [_toast dismissToast];
                if ([Utils showLoginPageIfNeeded]) {
                } else {
                    if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                        [Utils postMessage:@"网络连接已断开" onView:self.view];
                    }else{
                        MessageListViewController *message = [MessageListViewController new];
                        message.title = @"消息通知";
                        [self.navigationController pushViewController:message animated:YES];
                    }
                }
            }];
        }else{
            [_toast dismissToast];
        }
       
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 110;
    }else if(indexPath.section == 1){
        return 70;
    }else{
        return 195;
    }
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0){
            return CGFLOAT_MIN;
        }else if (section == 1){
            return 5;
        }else{
            return 45;
        }
    } else {
        if (section == 0){
            return CGFLOAT_MIN;
        }else if (section == 1){
            return 5;
        }else{
            return 45;
        }
    }
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (@available(iOS 11.0, *)) {
        if (section == 2) {
            UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
            sectionView.backgroundColor = [UIColor whiteColor];
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
            topView.backgroundColor = DefaultBackgroundColor;
            [sectionView addSubview:topView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(topView.frame)+10, kScreenWidth-20,20)];
            label.backgroundColor = [UIColor whiteColor];
            label.text = @"公共服务";
            label.font = Font(16);
            label.textColor = DefaultBlackLightTextClor;
            [sectionView addSubview:label];
            return sectionView;
        }else{
            return nil;
        }
    } else {
        if (section == 2) {
            UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
            sectionView.backgroundColor = [UIColor whiteColor];
            UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 5)];
            topView.backgroundColor = DefaultBackgroundColor;
            [sectionView addSubview:topView];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(topView.frame)+10, kScreenWidth-20,20)];
            label.backgroundColor = [UIColor whiteColor];
            label.text = @"公共服务";
            label.font = Font(16);
            label.textColor = DefaultBlackLightTextClor;
            [sectionView addSubview:label];
            return sectionView;
        }else{
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return CGFLOAT_MIN;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.evalute = ^{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    WKWebViewController *ass = [WKWebViewController new];
                    [ass loadWebURLSring:[NSString stringWithFormat:@"%@?token=%@",tovalute_URL,[User LocalUser].token]];
                    NSLog(@"%@",[NSString stringWithFormat:@"%@?token=%@",tovalute_URL,[User LocalUser].token]);
                    ass.hidesBottomBarWhenPushed = YES;
                    ass.title = @"评估";
                    [self.navigationController pushViewController:ass animated:YES];
                }
            }
        };
        
        //快速提问
        cell.auswer = ^{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
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
            }
        };
        
        //指标管理
        cell.indexManager = ^{
            if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                [Utils postMessage:@"网络连接已断开" onView:self.view];
            }else{
                TableViewController *indexm = [TableViewController new];
                indexm.title = @"癌症科普";
                indexm.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:indexm animated:YES];
            }
        };
        cell.baogaoManager = ^{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                     TJFLViewController *webViewVC = [[TJFLViewController alloc] init];
                     webViewVC.title = @"查看报告";
                     [self.navigationController pushViewController:webViewVC animated:YES];
                }
            }
        };
        return cell;
    }else if(indexPath.section == 1){
        MiddleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MiddleTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.ques = ^{
            PopularDetailViewController *popula = [PopularDetailViewController new];
            popula.title = @"科普详情";
            popula.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:popula animated:YES];
        };
        [cell refreshcellWithModel:self.BannerArray];
        return cell;
    }else{
        ServiceTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServiceTypeTableViewCell class])];
        //体检
        cell.tijian = ^{
            if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                [Utils postMessage:@"网络连接已断开" onView:self.view];
            }else{
                TJMenuViewController *menu = [[TJMenuViewController alloc]init];
                [self.navigationController pushViewController:menu animated:YES];
            }
        };
        //基因检测
        cell.jiyin = ^{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    GeneDetectionViewController *gen = [GeneDetectionViewController new];
                    gen.hidesBottomBarWhenPushed = YES;
                    gen.title  =@"基因检测";
                    [self.navigationController pushViewController:gen animated:YES];
                }
            }
        };
        
        //就医
        cell.jiuyi = ^{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    MedicalTreatmentViewController *medical = [[MedicalTreatmentViewController alloc]init];
                    medical.title  =@"绿色通道";
                    medical.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:medical animated:YES];
                }
            }
        };
        
        //国际保险
        cell.guoji = ^{
            if ([Utils showLoginPageIfNeeded]) {
            } else {
                if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
                    [Utils postMessage:@"网络连接已断开" onView:self.view];
                }else{
                    NationInsureViewController *nation = [NationInsureViewController new];
                    [nation loadWebURLSring:NationInsure_URL];
                    nation.title = @"国际保险";
                    nation.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:nation animated:YES];
                }
            }
        };
        
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
                        PopularDetailViewController *popula = [PopularDetailViewController new];
                        popula.title = @"科普详情";
                        popula.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:popula animated:YES];
    }
   
}
#pragma mark JQFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(JQFlowView *)flowView
{
    return CGSizeMake(kScreenWidth - 84, (kScreenWidth - 84) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
//    IndexBannerModel *model = [self.banners objectAtIndex:subIndex];
//    WKWebViewController *nation = [WKWebViewController new];
//    [nation loadWebURLSring:model.url];
//    nation.title = model.des;
//    nation.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:nation animated:YES];
}

#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(JQFlowView *)flowView
{
    return self.imageArray.count;
}

- (UIView *)flowView:(JQFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    JQIndexBannerSubview *bannerView = (JQIndexBannerSubview *)[flowView dequeueReusableCell];
    bannerView = [[JQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 84, (kScreenWidth - 84) * 9 / 16)];
    bannerView.layer.cornerRadius = 4;
    bannerView.layer.shadowColor=DefaultGrayTextClor.CGColor;
    bannerView.layer.shadowOffset= CGSizeMake(0, 1);
    bannerView.layer.shadowOpacity=0.3;
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index]] placeholderImage:nil];
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(JQFlowView *)flowView
{
  
//    NSLog(@"滚动到了第%ld页",pageNumber);
//    [Utils postMessage:@"即将开通" onView:self.view];
}


- (void)dealloc
{
    [self.pageFlowView stopTimer];
}

@end
