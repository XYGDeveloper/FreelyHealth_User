//
//  ConversationViewController.m
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ConversationViewController.h"
#import "getGroupsApi.h"
#import "GetGroupRequest.h"
#import "GroupInfoModel.h"
#import "GroupModel.h"
#import "GetGroupInfo.h"
@interface ConversationViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMGroupMemberDataSource,ApiRequestDelegate>
@property (nonatomic,strong)GetGroupInfo *getGroupApi;
@property (nonatomic,strong)getGroupsApi *GroupApi;
@property (nonatomic,strong)NSMutableArray *memberList;

@end

@implementation ConversationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    groupHeader *head = [[groupHeader alloc]init];
//    head.target = @"userHuizhenControl";
//    head.method = @"groupDetail";
//    head.versioncode = Versioncode;
//    head.devicenum = Devicenum;
//    head.fromtype = Fromtype;
//    head.token = [User LocalUser].token;
//    groupBody *body = [[groupBody alloc]init];
//    GetGroupRequest *request = [[GetGroupRequest alloc]init];
//    request.head = head;
//    request.body = body;
//    NSLog(@"%@",request);
//    [self.getGroupApi getGroup:request.mj_keyValues.mutableCopy];
    
}

- (NSMutableArray *)memberList{
    if (!_memberList) {
        _memberList = [NSMutableArray array];
    }
    return _memberList;
}

- (getGroupsApi *)getGroupApi{
    if (!_getGroupApi) {
        _getGroupApi = [[getGroupsApi alloc]init];
        _getGroupApi.delegate  =self;
    }
    return _getGroupApi;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    if (api == _getGroupApi) {
        GroupInfoModel *model = responsObject;
        self.title = model.groupname;
        NSArray *member = [groupMemberModel mj_objectArrayWithKeyValuesArray:model.peoples];
        self.memberList = member.mutableCopy;
        for (groupMemberModel *model in member) {
            RCUserInfo *user = [[RCUserInfo alloc]initWithUserId:model.id name:model.name portrait:model.facepath];
            [[RCIM sharedRCIM] refreshGroupUserInfoCache:user withUserId:model.id withGroupId:self.targetId];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupMemberDataSource:self];
    [RCIM sharedRCIM].currentUserInfo.userId = [User LocalUser].id;
    
    [RCIM sharedRCIM].currentUserInfo.name = [NSString stringWithFormat:@"%@",[User LocalUser].name];
    
    [RCIM sharedRCIM].currentUserInfo.portraitUri = [User LocalUser].facepath;
    RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:[User LocalUser].id name:[NSString stringWithFormat:@"%@",[User LocalUser].name] portrait:[User LocalUser].facepath];
    [[RCIM sharedRCIM] setCurrentUserInfo:info];
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1101];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1102];
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];
    // Do any additional setup after loading the view.
    
    
}



- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
    if ([userId isEqualToString:[User LocalUser].id]) {
        return completion([[RCUserInfo alloc] initWithUserId:userId name:[User LocalUser].name portrait:[User LocalUser].facepath]);
    }else{
        return completion([[RCUserInfo alloc] initWithUserId:userId name:@"" portrait:@""]);
    }
}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion
{
    
  
}

- (void)getAllMembersOfGroup:(NSString *)groupId result:(void (^)(NSArray<NSString *> *userIdList))resultBlock{
    NSLog(@"00000     %@",groupId);
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    for (groupMemberModel *model in self.memberList) {
       [ret addObject:model.id];
    }
    resultBlock(ret);
}

- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
                  withUserId:(NSString *)userId{
    
    NSLog(@"%@",userInfo);
    
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
    NSLog(@"%@",groupId);
    NSLog(@"%@",groupInfo);
}

- (void)scanDetail{
    
//    TeamDetailViewController *detail = [[TeamDetailViewController alloc]init];
//
//    detail.isShow = YES;
//
//    detail.ID = self.targetId;
//
//    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)didTapCellPortrait:(NSString *)userId {
   
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
