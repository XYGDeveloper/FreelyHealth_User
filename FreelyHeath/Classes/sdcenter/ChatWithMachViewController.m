//
//  ChatWithMachViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ChatWithMachViewController.h"

@interface ChatWithMachViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation ChatWithMachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].userid;
    
    [RCIM sharedRCIM].currentUserInfo.name = [User LocalUser].nickname;
    
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].userid name:[User LocalUser].nickname portrait:[User LocalUser].facepath];
    
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
}


- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSLog(@"------%@",userId);
    
    if ([userId isEqualToString:[User LocalUser].userid]) {
        
        
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].nickname portrait:[User LocalUser].facepath]);
        
    }else
    {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""]);
        
    }
    
    
}



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
