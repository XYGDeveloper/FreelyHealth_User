//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WKWebViewController.h"
#import "ResultViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "ASSModel.h"
#import "CustomerViewController.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import <UShareUI/UShareUI.h>
#import "PhyicalModel.h"
#import <UMSocialQQHandler.h>
#import <UMengUShare/TencentOpenAPI/QQApiInterface.h>
#import <UMengUShare/WXApi.h>
#import "UIImage+InsetEdge.h"
#import "FSActionSheet.h"
#import <APOpenAPI.h>
#import <DTShareKit/DTOpenAPI.h>
typedef enum{
    loadWebURLString = 0,
    loadWebHTMLString,
    POSTWebURLString,
}wkWebLoadType;

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UIGestureRecognizerDelegate,UIActionSheetDelegate>
{
    UIImage *_saveImage;
    NSString *_qrCodeString;
}
@property (nonatomic, strong) UIActionSheet *alert0;
@property (nonatomic, strong) UIActionSheet *alert1;
@property (nonatomic, strong) WKWebView *wkWebView;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
//网页加载的类型
@property(nonatomic,assign) wkWebLoadType loadType;
//保存的网址链接
@property (nonatomic, copy) NSString *URLString;
//保存POST请求体
@property (nonatomic, copy) NSString *postData;
//保存请求链接
@property (nonatomic)NSMutableArray* snapShotsArray;
//返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@end

@implementation WKWebViewController

-(UIBarButtonItem *)itemWithImageNamed:(NSString *)imageName
                           target:(id)target
                           action:(SEL)action{
    UIButton * Barbutton = [[UIButton alloc]init];
    [Barbutton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [Barbutton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [Barbutton sizeToFit];
    return [[UIBarButtonItem alloc]initWithCustomView:Barbutton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载web页面
    [self webViewloadURLType];
    //添加到主控制器上
    [self.view addSubview:self.wkWebView];
    self.wkWebView.UIDelegate =self;
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.allowsBackForwardNavigationGestures = YES;
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPress.minimumPressDuration = 1;
//    longPress.delegate = self;
//    [self.wkWebView addGestureRecognizer:longPress];
    //添加进度条
    [self.view addSubview:self.progressView];
    
    //添加右边刷新按钮    
//    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:nil action:@selector(customBackItemClicked)];
//
    [self configReturnButton];
    if (self.isShare == YES) {
        [self setRightNavigationItemWithTitle:@"分享" action:@selector(toshare)];

    }else{
        
//         [self setRightNavigationItemWithImage:[UIImage imageNamed:@"index_refresh"] highligthtedImage:[UIImage imageNamed:@"index_refresh"] action:@selector(roadLoadClicked)];
    }
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)close{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.name descr:self.model.des thumImage:thumbURL];
    shareObject.webpageUrl = self.model.url;
    messageObject.shareObject = shareObject;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isNavHidden == YES) {
        self.navigationController.navigationBarHidden = YES;
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        //设置成绿色
        statusBarView.backgroundColor=[UIColor whiteColor];
        // 添加到 navigationBar 上
        [self.view addSubview:statusBarView];
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
}


- (void)roadLoadClicked{
    [self.wkWebView reload];
}

-(void)customBackItemClicked{
    if (self.wkWebView.goBack) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)closeItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ================ 加载方式 ================

- (void)webViewloadURLType{
    switch (self.loadType) {
        case loadWebURLString:{
           
            //创建一个NSURLRequest 的对象
            NSURLRequest * Request_zsj = [NSURLRequest requestWithURL:[NSURL URLWithString:[self.URLString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            //加载网页
            [self.wkWebView loadRequest:Request_zsj];
            break;
        }
        case loadWebHTMLString:{
            [self loadHostPathURL:self.URLString];
            break;
        }
        case POSTWebURLString:{
            // JS发送POST的Flag，为真的时候会调用JS的POST方法
            self.needLoadJSPOST = YES;
            //POST使用预先加载本地JS方法的html实现，请确认WKJSPOST存在
//            [self loadHostPathURL:@"WKJSPOST"];
            break;
        }
    }
}
//
- (void)loadHostPathURL:(NSString *)url{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 调用JS发送POST请求
//- (void)postRequestWithJS {
//    // 拼装成调用JavaScript的字符串
//    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, self.postData];
//    // 调用JS代码
//    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
//    }];
//
//
//    //调用H5方法
//
//    NSString *jscript1 = [NSString stringWithFormat:@"post('%@');", [User LocalUser].token];
//
//    [self.wkWebView evaluateJavaScript:jscript1 completionHandler:^(id object, NSError * _Nullable error) {
//
//
//        NSLog(@"%@   %@",object,error);
//
//    }];
//
//}


- (void)loadWebURLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebURLString;
}

- (void)loadWebHTMLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebHTMLString;
}

//- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData{
//    self.URLString = string;
//    self.postData = postData;
//    self.loadType = POSTWebURLString;
//}

//#pragma mark   ============== URL pay 开始支付 ==============
//
//- (void)payWithUrlOrder:(NSString*)urlOrder
//{
//    if (urlOrder.length > 0) {
//        __weak XFWkwebView* wself = self;
//        [[AlipaySDK defaultService] payUrlOrder:urlOrder fromScheme:@"giftcardios" callback:^(NSDictionary* result) {
//            // 处理支付结果
//            NSLog(@"===============%@", result);
//            // isProcessUrlPay 代表 支付宝已经处理该URL
//            if ([result[@"isProcessUrlPay"] boolValue]) {
//                // returnUrl 代表 第三方App需要跳转的成功页URL
//                NSString* urlStr = result[@"returnUrl"];
//                [wself loadWithUrlStr:urlStr];
//            }
//        }];
//    }
//}
//
//- (void)WXPayWithParam:(NSDictionary *)WXparam{
//
//}
////url支付成功回调地址
//- (void)loadWithUrlStr:(NSString*)urlStr
//{
//    if (urlStr.length > 0) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad
//                                                    timeoutInterval:15];
//            [self.wkWebView loadRequest:webRequest];
//        });
//    }
//}

#pragma mark ================ 自定义返回/关闭按钮 ================

#pragma mark - left NavigationItem
- (void)setNormalBackItem {
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:nil action:@selector(popButtonClicked:)];
}

- (void)setMultiBackItem {
    UIButton *backButton = [self navigationButtonWithImage:[UIImage imageNamed:@"nav_back"] highligthtedImage:nil action:@selector(popButtonClicked:)];
    UIButton *closeButton = [self navigationButtonWithTitle:@"关闭" action:@selector(closeButtonClicked:)];
    [self setLeftNavigationItems:@[backButton, closeButton]];
}

- (void)configReturnButton {
    NSLog(@"\\\\\\\\\\-----%lu",self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count > 1 && self.wkWebView.canGoBack) {
        [self setMultiBackItem];
    } else if (self.navigationController.viewControllers.count <= 1 && !self.wkWebView.canGoBack) {
        [self setLeftNavigationItemWithTitle:@"" action:nil];
    } else {
        [self setNormalBackItem];
    }
}

- (void)closeButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)popButtonClicked:(id)sender {
    if (self.wkWebView.canGoBack) {
        [self.wkWebView goBack];
        self.navigationItem.rightBarButtonItems = nil;
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//请求链接处理
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    NSLog(@"push with request %@",request);
    NSURLRequest* lastRequest = (NSURLRequest*)[[self.snapShotsArray lastObject] objectForKey:@"request"];

    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return;
    }
    UIView* currentSnapShotView = [self.wkWebView snapshotViewAfterScreenUpdates:YES];
    [self.snapShotsArray addObject:@{@"request":request,@"snapShotView":currentSnapShotView}];
}

#pragma mark ================ WKNavigationDelegate ================
//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
//        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    // 获取加载网页的标题
//    self.title = self.wkWebView.title;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self setMultiBackItem];
    
}



//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
    
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    
    
}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeFormSubmitted: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        case WKNavigationTypeBackForward: {
            break;
        }
        case WKNavigationTypeReload: {
            break;
        }
        case WKNavigationTypeFormResubmitted: {
            break;
        }
        case WKNavigationTypeOther: {
            [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
            break;
        }
        default: {
            break;
        }
    }
    
    [self setMultiBackItem];
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    [self setMultiBackItem];
    
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
    
    
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    
}

#pragma mark ================ WKUIDelegate ================

// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
            
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

#pragma mark ================ WKScriptMessageHandler ================


//- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
//    if (jsonString == nil) {
//        return nil;
//    }
//    
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return dic;
//    
//}

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    if ([message.name isEqualToString:@"consultation"]) {
        
        NSLog(@"调用本方法%@", message.body);
        
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

#pragma mark ================ 懒加载 ================

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
        //允许视频播放
        Configuration.allowsAirPlayForMediaPlayback = YES;
        // 允许在线播放
        Configuration.allowsInlineMediaPlayback = YES;
        // 允许可以与网页交互，选择视图
        Configuration.selectionGranularity = YES;
        // web内容处理池
        Configuration.processPool = [[WKProcessPool alloc] init];
        // CSS选中样式取消
        NSString *css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";
        NSMutableString *javascript = [NSMutableString string];
        [javascript appendString:@"var style = document.createElement('style');"];
        [javascript appendString:@"style.type = 'text/css';"];
        [javascript appendFormat:@"var cssContent = document.createTextNode('%@');",css];
        [javascript appendString:@"style.appendChild(cssContent);"];
        [javascript appendString:@"document.body.appendChild(style);"];
        // javascript注入
        WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
  
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * UserContentController = [[WKUserContentController alloc]init];
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        [UserContentController addScriptMessageHandler:self name:@"consultation"];
        [UserContentController addUserScript:noneSelectScript];

        // 是否支持记忆读取
        Configuration.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        Configuration.userContentController = UserContentController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-64) configuration:Configuration];
        _wkWebView.backgroundColor = DefaultBackgroundColor;
        // 设置代理
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        self.wkWebView.scrollView.delegate = self;
//        _wkWebView.userInteractionEnabled = NO;
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        //开启手势触摸
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.multipleTouchEnabled = NO;
        
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
        
     
        
    }
    return _wkWebView;
    
    
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (_isNavHidden == YES) {
            _progressView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 4);
        }else{
            _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 4);
        }
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor whiteColor]];
        _progressView.progressTintColor = AppStyleColor;
    }
    return _progressView;
}

-(NSMutableArray*)snapShotsArray{
    if (!_snapShotsArray) {
        _snapShotsArray = [NSMutableArray array];
    }
    return _snapShotsArray;
}

-(void)viewWillDisappear:(BOOL)animated{
 
    
}

//注意，观察的移除
-(void)dealloc{
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"consultation"];
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    _wkWebView.scrollView.delegate=nil;
    _wkWebView.UIDelegate = nil;
    _wkWebView.navigationDelegate = nil;
    [_wkWebView loadHTMLString:@"" baseURL:nil];
    [_wkWebView stopLoading];
    [_wkWebView removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    _wkWebView = nil;

}

//- (void)handleLongPress:(UILongPressGestureRecognizer *)sender{
//    if (sender.state != UIGestureRecognizerStateBegan) {
//        return;
//    }
//    CGPoint touchPoint = [sender locationInView:self.wkWebView];
//    // 获取长按位置对应的图片url的JS代码
//    NSString *imgJS = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
//    // 执行对应的JS代码 获取url
//    [self.wkWebView evaluateJavaScript:imgJS completionHandler:^(id _Nullable imgUrl, NSError * _Nullable error) {
//        if (imgUrl) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
//            UIImage *image = [UIImage imageWithData:data];
//            if (!image) {
//                NSLog(@"读取图片失败");
//                return;
//            }
//            _saveImage = image;
//            if ([self isAvailableQRcodeIn:image]) {
//                self.alert0 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", @"识别二维码", nil];
//                // 显示
//                [self.alert0 showInView:self.view];
//            } else {
//                self.alert1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
//                // 显示
//                [self.alert1 showInView:self.view];
//            }
//        }
//    }];
//}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"%ld",buttonIndex);
//    if (actionSheet == self.alert0) {
//        if (buttonIndex == 0) {
//            UIImageWriteToSavedPhotosAlbum(_saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }else{
//            NSURL *qrUrl = [NSURL URLWithString:_qrCodeString];
//            // Safari打开
//            if ([[UIApplication sharedApplication] canOpenURL:qrUrl]) {
//                [[UIApplication sharedApplication] openURL:qrUrl];
//            }
//            // 内部应用打开
//            [self.wkWebView loadRequest:[NSURLRequest requestWithURL:qrUrl]];
//        }
//    }
//    if (actionSheet == self.alert1) {
//        if (buttonIndex == 0) {
//            UIImageWriteToSavedPhotosAlbum(_saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        }
//    }
//}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *message = @"Succeed";
    if (error) {
        message = @"Fail";
    }
    NSLog(@"save result :%@", message);
}

//长按操作
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)isAvailableQRcodeIn:(UIImage *)img{
    UIImage *image = [img imageByInsetEdge:UIEdgeInsetsMake(-20, -20, -20, -20) withColor:[UIColor lightGrayColor]];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{}];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        _qrCodeString = [feature.messageString copy];
        NSLog(@"二维码信息:%@", _qrCodeString);
        return YES;
    } else {
        NSLog(@"无可识别的二维码");
        return NO;
    }
}


@end
