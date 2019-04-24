//
//  PDFWebViewViewController.m
//  PDFViewAndDownload
//
//  Created by Dustin on 17/4/6.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import "PDFWebViewViewController.h"
#import "MBProgressHUD.h"
#import "Masonry.h"
#import "HistoryViewController.h"
#import "UdeskSDKManager.h"
#import "Udesk_WHC_HttpManager.h"
#import "UdeskTicketViewController.h"
#import "UIImage+GradientColor.h"
@interface PDFWebViewViewController ()<UIWebViewDelegate,ApiRequestDelegate>

@property (nonatomic,strong)UIWebView *myWebView;

@property (nonatomic,strong)UIButton *customerButton;

@end

@implementation PDFWebViewViewController

- (GetBgApi *)api
{
    if (!_api) {
        
        _api = [[GetBgApi alloc]init];
        _api.delegate = self;
    }
    
    return _api;
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    self.urlStr = [responsObject[@"imgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    [self creatUI];
    
    [[EmptyManager sharedManager]removeEmptyFromView:self.view];

}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
    [[EmptyManager sharedManager]showEmptyOnView:self.view withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无体检报告" operationText:nil operationBlock:nil];
    
    [self.view bringSubviewToFront:self.customerButton];
    
}

- (UIButton *)customerButton
{
    
    if (!_customerButton) {
        
        _customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _customerButton.backgroundColor = Customer_Color;
        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        [_customerButton setBackgroundImage:bgImg forState:UIControlStateNormal];
        //button标题的偏移量，这个偏移量是相对于图片的
        [_customerButton setImage:[UIImage imageNamed:@"service-1"] forState:UIControlStateNormal];
        
        _customerButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:2];
        
        [_customerButton setTitle:@"报告解读" forState:UIControlStateNormal];
        
        _customerButton.contentMode = UIViewContentModeCenter;
        
        CGFloat imageWidth = _customerButton.imageView.bounds.size.width;
        CGFloat labelWidth = _customerButton.titleLabel.bounds.size.width;
        _customerButton.titleEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        _customerButton.imageEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth);
        
        [_customerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    
    return _customerButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    if ([self.his isEqualToString:@"1"]) {
        
        [self setRightNavigationItemWithTitle:@"历史报告" action:@selector(historyBg)];

    }else{
        
        [self setRightNavigationItemWithTitle:@"" action:nil];

    }
    

    [self.view addSubview:self.customerButton];

    [self.customerButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);

    }];

    [self.customerButton addTarget:self action:@selector(toCustomer) forControlEvents:UIControlEventTouchUpInside];
    
//    [self hudTipWillShow:YES];
    
        GetBgHeader *head = [[GetBgHeader alloc]init];
    
        head.target = @"tjbgControl";
    
        head.method = @"getUserTjbgByYzm";
    
        head.versioncode = Versioncode;
    
        head.devicenum = Devicenum;
    
        head.fromtype = Fromtype;
    
        head.token = [User LocalUser].token;
    
        GetBgBody *body = [[GetBgBody alloc]init];
    
        GetBgRequest *request = [[GetBgRequest alloc]init];
        request.head = head;
        request.body = body;
        [self.api getBgList:request.mj_keyValues.mutableCopy];
    
    
}

- (void)creatUI{
 
    [self.view addSubview:self.myWebView];
    
    [self.myWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.mas_equalTo(-49);
        
    }];
    
    NSURL *pathUrl = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:pathUrl];
    [self.myWebView loadRequest:request];
    //使文档的显示范围适合UIWebView的bounds
    [self.myWebView setScalesPageToFit:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在加载中...";
    
}

- (void)back:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIWebView *)myWebView{
    if (!_myWebView) {
        _myWebView = [[UIWebView alloc] init];
        _myWebView.backgroundColor = [UIColor whiteColor];
        _myWebView.delegate = self;
    }
    return _myWebView;
}

- (void)historyBg{
    
    HistoryViewController *hisbg = [HistoryViewController new];
    hisbg.title = @"历史报告";
    [self.navigationController pushViewController:hisbg animated:YES];
    
}



- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

- (void)webViewDidFinishLoad:(UIWebView *)webView{
   
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
