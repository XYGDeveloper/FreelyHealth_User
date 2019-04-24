//
//  ResultRequest.h
//  FreelyHeath
//
//  Created by L on 2017/8/9.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface resultHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface resultBody : NSObject

@property (nonatomic , copy) NSString *id;

@end



@interface ResultRequest : NSObject

@property (nonatomic , strong) resultHeader *head;

@property (nonatomic , strong) resultBody *body;


@end
