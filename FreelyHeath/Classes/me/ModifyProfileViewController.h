//
//  ModifyProfileViewController.h
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "SelectSexCell.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "OSSImageUploader.h"
#import "UploadToolRequest.h"
#import "MBProgressHUD+BWMExtension.h"
#import "PhotoPickManager.h"
#import "UpdateUserInfoApi.h"
#import "UpdateUserInfo.h"
#import "UpdateUserModel.h"
#import "Udesk.h"
#import "UdeskManager.h"
#import "Utils.h"
#import "ValidatorUtil.h"
#import "IMapi.h"
#import "IMTokenRequest.h"
static NSString *const JumpNotSet = @"1";
static NSString *const UpfateProfile = @"2";
@class User;
@interface ModifyProfileViewController : UIViewController
@property (nonatomic,assign)BOOL isLoginEntrance;   //资料设置和资料修改
@property (nonatomic,strong) User *user;            //用户资料信息
@property (nonatomic,strong) NSString *token;       //暂时借用token设置头像资料
@end
