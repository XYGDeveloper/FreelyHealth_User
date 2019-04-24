//
//  CancerModel.h
//  FreelyHeath
//
//  Created by L on 2018/1/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *content;

@end

@interface CancerModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSArray *shuxing;


@end
