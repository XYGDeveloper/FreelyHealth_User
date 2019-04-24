//
//  AddIndexListRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addIndexHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface addIndexbody : NSObject

@property (nonatomic , copy) NSString *id;

@property (nonatomic , copy) NSString *num;

@end


@interface AddIndexListRequest : NSObject

@property (nonatomic , strong) addIndexHeader *head;

@property (nonatomic , strong) addIndexbody *body;



@end
