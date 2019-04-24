//
//  NewModel.h
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *imagepath;
@property (nonatomic,copy)NSString *zilist;
@property (nonatomic,copy)NSString *pay;
@end

@interface NewModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *des;
@property (nonatomic,strong)NSArray *services;


@end
