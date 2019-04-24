//
//  CustomerViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CustomerViewController.h"

@interface CustomerViewController ()

@end

@implementation CustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self notifyUpdateUnreadMessageCount];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    if (self.isConsultQuestion) {
        
        //发送文字消息
        RCTextMessage *txtMsg = [RCTextMessage messageWithContent:self.consultText];
        
        [self sendMessage:txtMsg pushContent:nil];
        
//        for (NSString *imageURL in self.consultImages) {
//            
//            NSLog(@"%@",self.consultImages);
//            
//            //发送图片消息
//            RCImageMessage *imageMessage = [RCImageMessage messageWithImageURI:imageURL];
//            
//            [self sendMediaMessage:imageMessage pushContent:nil appUpload:nil];
//            
//        }

    }
    
    // Do any additional setup after loading the view.
}


- (void)leftBarButtonItemPressed:(id)sender {
    //需要调用super的实现
    [super leftBarButtonItemPressed:sender];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//评价客服，并离开当前会话
//如果您需要自定义客服评价界面，请把本函数注释掉，并打开“应用自定义评价界面开始1/2”到“应用自定义评价界面结束”部分的代码，然后根据您的需求进行修改。
//如果您需要去掉客服评价界面，请把本函数注释掉，并打开下面“应用去掉评价界面开始”到“应用去掉评价界面结束”部分的代码，然后根据您的需求进行修改。
- (void)commentCustomerServiceWithStatus:(RCCustomerServiceStatus)serviceStatus
                               commentId:(NSString *)commentId
                        quitAfterComment:(BOOL)isQuit {
    [super commentCustomerServiceWithStatus:serviceStatus
                                  commentId:commentId
                           quitAfterComment:isQuit];
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
