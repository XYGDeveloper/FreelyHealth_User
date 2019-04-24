//
//  ThumpRequest.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface thumpHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end


@interface thumpBody : NSObject

@property (nonatomic , copy) NSString *id;

@end

@interface ThumpRequest : NSObject

@property (nonatomic,strong)thumpHeader *head;

@property (nonatomic,strong)thumpBody *body;

@end
