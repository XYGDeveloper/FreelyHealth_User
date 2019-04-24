//
//  MyViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/9.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()<RCIMUserInfoDataSource,RCIMGroupInfoDataSource>

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    // Do any additional setup after loading the view.
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
//
//                            atIndexPath:(NSIndexPath *)indexPath
//
//{
//    
//    //获取cell对应的model
//    
//    RCConversationModel *model=cell.model;
//    
//    //根据model的某个属性判断
//    
//    if (model.conversationType == ConversationType_PRIVATE) {
//        
//        //强转为具体的cell
//        
//        RCConversationCell *concell = (RCConversationCell *)cell;
//        
//        if (![model.targetId isEqualToString:[User LocalUser].userid]) {
//            
//            concell.conversationTitle.textColor = [UIColor whiteColor];
// 
//            concell.backgroundColor = AppStyleColor;
//
//        }
//        
//    }
//    
//}


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
