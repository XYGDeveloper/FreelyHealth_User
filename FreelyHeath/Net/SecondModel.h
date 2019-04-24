//
//  SecondModel.h
//  FreelyHeath
//
//  Created by L on 2018/1/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface serverModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *imagepath;
@property (nonatomic,copy)NSString *des;

@end

@interface SecondModel : NSObject

@property (nonatomic,strong)NSArray *services;
@property (nonatomic,copy)NSString *zilist;

@end
