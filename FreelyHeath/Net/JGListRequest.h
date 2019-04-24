//
//  JGListRequest.h
//  FreelyHeath
//
//  Created by L on 2018/1/12.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JGListHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end
@interface JGListBody : NSObject

@property (nonatomic , copy) NSString *id;
@property (nonatomic , copy) NSString *cityid;
@property (nonatomic , copy) NSString *keyword;

@end
@interface JGListRequest : NSObject
@property (nonatomic,strong) JGListHeader*head;
@property (nonatomic,strong)JGListBody *body;
@end
