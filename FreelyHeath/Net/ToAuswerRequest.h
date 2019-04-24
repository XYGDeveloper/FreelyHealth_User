//
//  ToAuswerRequest.h
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AuswerRequestHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface AuswerRequestBody : NSObject

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *detail;


@end


@interface ToAuswerRequest : NSObject

@property (nonatomic,strong)AuswerRequestHeader *head;

@property (nonatomic,strong)AuswerRequestBody *body;
@end
