//
//  User.h
//  FreelyHealth
//
//  Created by L on 2017/7/15.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

//==============================================================
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *age;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *IMtoken;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *facepath;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *isvip;

@property (nonatomic, copy) NSString *update;

//company    string    否    公司
//isvip    string    否    0否 1 是
//update    string    否    0 未填（初始）1 跳过 2  已填

/** 本地登陆的用户信息 */
+ (instancetype)LocalUser;

/** 设置本地登陆用户信息，并保存到沙盒 */
+ (void)setLocalUser:(User *)user;

/** 修改用户名，头像等后，将信息保存到沙盒的方法 */
+ (void)saveToDisk;

/** 退出登陆后，调用该方法清理本地用户信息*/
+ (void)clearLocalUser;

/** 返回当前是否有用户登陆 */
+ (BOOL)hasLogin;


@end
