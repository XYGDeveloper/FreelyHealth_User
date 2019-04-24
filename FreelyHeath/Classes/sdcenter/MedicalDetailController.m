//
//  MedicalDetailController.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MedicalDetailController.h"
#import "TumorDetailApi.h"
#import "TumorDetalRequest.h"
#import "TunorDetail.h"
#import "OrderFillViewController.h"
#import <UShareUI/UShareUI.h>
#import "CustomerViewController.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "UIView+AnimationProperty.h"
@interface MedicalDetailController ()<ApiRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titileLabel;

@property (weak, nonatomic) IBOutlet UIImageView *pic1;

@property (weak, nonatomic) IBOutlet UILabel *content1;

@property (weak, nonatomic) IBOutlet UIImageView *pic2;

@property (weak, nonatomic) IBOutlet UILabel *content2;

@property (nonatomic,strong)UIButton *serviceButton;

@property (nonatomic,strong)UIButton *commitApply;

@property (nonatomic,strong)TumorDetailApi *api;

@property (nonatomic,strong)TunorDetail *model;

@end

@implementation MedicalDetailController


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    TdetailHeader *head = [[TdetailHeader alloc]init];
    
    head.target = @"hfOrderControl";
    
    head.method = @"goodsDetail";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    TdetailBody *body = [[TdetailBody alloc]init];
    
    body.goodsid = self.gooid;
    
    TumorDetalRequest *request = [[TumorDetalRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api getDetail:request.mj_keyValues.mutableCopy];

    
}



- (TumorDetailApi *)api
{

    if (!_api) {
        
        _api = [[TumorDetailApi alloc]init];
        
        _api.delegate  =self;
    }
    
    return _api;
    

}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{


}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    
    NSLog(@"88888888888888   %@",responsObject);
    
    TunorDetail *model = responsObject;
    
    self.model  = model;
 
    self.titileLabel.text  = model.name;
    
    weakify(self);
    [self.pic1 sd_setImageWithURL:[NSURL URLWithString:model.imagepatho]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 strongify(self);
                                 self.pic1.image = image;
                                 self.pic1.alpha = 0;
                                 self.pic1.scale = 1.1f;
                                 [UIView animateWithDuration:0.5f animations:^{
                                     self.pic1.alpha = 1.f;
                                     self.pic1.scale = 1.f;
                                 }];
                             }];
    
    [self.pic2 sd_setImageWithURL:[NSURL URLWithString:model.imagepatht]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            strongify(self);
                            self.pic2.image = image;
                            self.pic2.alpha = 0;
                            self.pic2.scale = 1.1f;
                            [UIView animateWithDuration:0.5f animations:^{
                                self.pic2.alpha = 1.f;
                                self.pic2.scale = 1.f;
                            }];
                        }];

    NSString *_test  = model.datailo;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    [paraStyle01  setLineSpacing:10];
    paraStyle01.alignment = NSTextAlignmentLeft;
    paraStyle01.headIndent = 0.0f;
    CGFloat emptylen = self.content1.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;
    paraStyle01.tailIndent = 0.0f;
    paraStyle01.lineSpacing = 2.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    self.content1.attributedText = attrText;

    NSString *_test1  = model.datailt;
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    [paraStyle02  setLineSpacing:10];
    paraStyle02.alignment = NSTextAlignmentLeft;
    paraStyle02.headIndent = 0.0f;
    CGFloat emptylen1 = self.content2.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen1;
    paraStyle01.tailIndent = 0.0f;
    paraStyle01.lineSpacing = 2.0f;
    NSAttributedString *attrText1 = [[NSAttributedString alloc] initWithString:_test1 attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    self.content2.attributedText = attrText1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//   [self setRightNavigationItemWithTitle:@"分享" action:@selector(share)];

    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    // Do any additional setup after loading the view from its nib.
    
    self.serviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:self.serviceButton];
    
    self.titileLabel.font = [UIFont systemFontOfSize:18 weight:1];
    
    self.content1.textColor = DefaultGrayLightTextClor;
    
    self.content2.textColor = DefaultGrayLightTextClor;

}


//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//
//    //创建网页内容对象
//    NSString* thumbURL = @"https://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/2f9f6f1e022845b89d9303e01a3aa236.jpg";
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.model.name descr:self.model.datailt thumImage:thumbURL];
//    //设置网页地址
//    shareObject.webpageUrl = self.model.url;
//
//    messageObject.shareObject = shareObject;
//
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//
//        //        [Utils postMessage:error.description onView:self.view];
//
//    }];
//}
//
//
//
////fenxiang
//
//- (void)share{
//
//
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//
//        [self shareWebPageToPlatformType:platformType];
//
//    }];
//
//}

//客服
- (IBAction)jumpToService:(id)sender {
    
    
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        
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


- (IBAction)commitApply:(id)sender {
    
    
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        
        OrderFillViewController *fill = [OrderFillViewController new];
        
        fill.holpId = self.holpid;
        
        fill.title = @"订单填写";
        
        fill.model = self.model;
        
        [self.navigationController pushViewController:fill animated:YES];
        
    }
    
    
}


//

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
