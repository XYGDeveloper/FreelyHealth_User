//
//  QuaryTeamRequest.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllteamQuryHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface AllteamQuryBody : NSObject

//hospitalid	string	否	医院id
//departmentid	string	否	科室id

@property (nonatomic , copy) NSString *hospitalid;

@property (nonatomic , copy) NSString *departmentid;


@end


@interface QuaryTeamRequest : NSObject

@property (nonatomic , strong) AllteamQuryHeader *head;

@property (nonatomic , strong) AllteamQuryBody *body;

@end
