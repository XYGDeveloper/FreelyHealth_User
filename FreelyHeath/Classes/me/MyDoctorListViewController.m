//
//  MyDoctorListViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyDoctorListViewController.h"
#import "MyViewController.h"
#import "MBProgressHUD+BWMExtension.h"
@interface MyDoctorListViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation MyDoctorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    //设置需要显示哪些类型的会话
    
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_GROUP)]];
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].userid;
    
    [RCIM sharedRCIM].currentUserInfo.name = [User LocalUser].nickname;
    
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].userid name:[NSString stringWithFormat:@"患者：%@",[User LocalUser].phone] portrait:[User LocalUser].facepath];
    
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
    UIView *emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    UIImageView *img = [[UIImageView alloc]init];
    
    img.image = [UIImage imageNamed:@"orderList_empty"];
    
    [emptyView addSubview:img];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(200);
        
        make.height.width.mas_equalTo(80);
        
        make.centerX.mas_equalTo(emptyView.mas_centerX);
        
    }];
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text  =@"暂无会话列表";
    
    label.textColor = DefaultGrayLightTextClor;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [emptyView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(img.mas_bottom).mas_equalTo(20);
        
        make.width.mas_equalTo(200);
        
        make.height.mas_equalTo(25);
        
        make.centerX.mas_equalTo(emptyView.mas_centerX);
    }];
    
    self.emptyConversationView = emptyView;
  
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSLog(@"------%@",userId);
    
    if ([userId isEqualToString:[User LocalUser].userid]) {
        
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].phone portrait:[User LocalUser].facepath]);
        
    }else
    {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""]);
        
    }
    
    
}


- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    
    
    
    
}





- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {

    MyViewController *conversationVC = [[MyViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
    
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
