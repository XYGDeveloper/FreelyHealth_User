//
//  GetTJListRequest.h
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tjHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;


@end


@interface tjBody : NSObject

@property (nonatomic , copy) NSString *age;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *sex;

@property (nonatomic , copy) NSString *facepath;

@end

@interface GetTJListRequest : NSObject

@property (nonatomic,strong)tjHeader *head;

@property (nonatomic,strong)tjBody *body;

@end
