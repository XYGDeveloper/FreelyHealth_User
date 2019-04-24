//
//  MyProfileViewController.h
//  FreelyHeath
//
//  Created by xyg on 2017/12/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;
@interface MyProfileViewController : UIViewController
@property (nonatomic,assign)BOOL isLoginEntrance;   //资料设置和资料修改
@property (nonatomic,strong) User *user;            //用户资料信息
@property (nonatomic,strong) NSString *token;       //暂时借用token设置头像资料
@end
