//
//  MymessageConListViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/28.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MymessageConListViewController.h"
#import "ConversationViewController.h"
#import "RootManager.h"
@interface MymessageConListViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation MymessageConListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBadgeValueForTabBarItem];
    self.showConversationListWhileLogOut = YES;
    if (self.conversationListDataSource.count <= 0) {
        self.conversationListTableView.separatorStyle  =  UITableViewCellSeparatorStyleNone;
    }
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
    [RCIM sharedRCIM].currentUserInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_GROUP)
                                           ]];
    }
    
    return self;
    
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    [self updateBadgeValueForTabBarItem];
    NSLog(@"--------jjj-------%@  %@",model.conversationTitle,model.targetId);
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        ConversationViewController *conversation = [[ConversationViewController alloc]init];
        conversation.conversationType = model.conversationType;
        conversation.targetId = model.targetId;
        conversation.displayUserNameInCell = YES;
        conversation.enableNewComingMessageIcon = YES; //开启消息提醒
        conversation.enableUnreadMessageIcon = YES;
        [self.navigationController pushViewController:conversation animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    
    [self.conversationListTableView reloadData];
    //定位未读数会话
    //接收定位到未读数会话的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(GotoNextCoversation)
                                                 name:@"GotoNextCoversation"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateForSharedMessageInsertSuccess)
                                                 name:@"RCDSharedMessageInsertSuccess"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCell:)
                                                 name:@"RefreshConversationList"
                                               object:nil];
    
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    
    [self updateBadgeValueForTabBarItem];
    
    [self.conversationListTableView reloadData];
    
    // Do any additional setup after loading the view.
    
}

- (void)updateBadgeValueForTabBarItem {
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        if (count > 0) {
            [RootManager sharedManager].tabbarController.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
        } else {
            [RootManager sharedManager].tabbarController.viewControllers[2].tabBarItem.badgeValue = nil;
        }
    });
}

//- (void)jumpToCustom{
//
//    if ([Utils showLoginPageIfNeeded]) {} else {
//        UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
//        [UdeskManager setupCustomerOnline];
//        //设置头像
//        [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
//        [manager pushUdeskInViewController:self completion:nil];
//        //点击留言回调
//        [manager leaveMessageButtonAction:^(UIViewController *viewController){
//            UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
//            [viewController presentViewController:offLineTicket animated:YES completion:nil];
//        }];
//    }
//}
//
//

- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    
    NSLog(@"------%@",userId);
    
    if ([userId isEqualToString:[User LocalUser].id]) {
        
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].name portrait:[User LocalUser].facepath]);
        
    }else
    {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""]);
    }
    
}


//- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
//{
//
//    if ([groupId isEqualToString:[User LocalUser].tgroupid]) {
//
//        RCGroup *userInfo = [[RCGroup alloc]init];
//
//        userInfo.groupId = [User LocalUser].tgroupid;
//
//        userInfo.groupName = [User LocalUser].tname;
//
//        userInfo.portraitUri = @"http://zhiyi365.oss-cn-shanghai.aliyuncs.com/img/20170915/90f4ee8723b24ea08fe85915dad7c7b7.jpg";
//
//        return completion(userInfo);
//
//    }else{
//
//        RCGroup *userInfo = [[RCGroup alloc]init];
//
//        userInfo.groupId = [User LocalUser].mdtgroupid;
//
//        userInfo.groupName = [User LocalUser].mdtgroupname;
//
//        userInfo.portraitUri = [User LocalUser].mdtgroupfacepath;
//        return completion(userInfo);
//    }
//
//}


- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    
    
    
}

/*!
 更新SDK中的群组信息缓存
 
 @param groupInfo   需要更新的群组信息
 @param groupId     需要更新的群组ID
 
 @discussion 使用此方法，可以更新SDK缓存的群组信息。
 但是处于性能和使用场景权衡，SDK不会在当前View立即自动刷新（会在切换到其他View的时候再刷新该群组的显示信息）。
 如果您想立即刷新，您可以在会话列表或者会话页面reload强制刷新。
 */
- (void)refreshGroupInfoCache:(RCGroup *)groupInfo
                  withGroupId:(NSString *)groupId{
    
    
}

- (void)refreshCell:(NSNotification *)notify {
    /*
     NSString *row = [notify object];
     RCConversationModel *model = [self.conversationListDataSource objectAtIndex:[row intValue]];
     model.unreadMessageCount = 0;
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[row integerValue] inSection:0];
     dispatch_async(dispatch_get_main_queue(), ^{
     [self.conversationListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
     withRowAnimation:UITableViewRowAnimationNone];
     });
     */
    [self refreshConversationTableViewIfNeeded];
}

- (void)notifyUpdateUnreadMessageCount{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [[RCIMClient sharedRCIMClient] getUnreadCount:self.displayConversationTypeArray];
        if (count > 0) {
            [RootManager sharedManager].tabbarController.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",count];
        } else {
            [RootManager sharedManager].tabbarController.viewControllers[2].tabBarItem.badgeValue = nil;
        }
    });
    
    [self playSound];
    
}

- (void)playSound{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);  // 震动
    AudioServicesPlaySystemSound(1007);
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
