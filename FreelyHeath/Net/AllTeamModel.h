//
//  AllTeamModel.h
//  FreelyHeath
//
//  Created by L on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface memberModel : NSObject

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@end


@interface departModel : NSObject

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@end



@interface allCityModel : NSObject

//departments参数：
//字段	类型	必填	说明
//id	string	是	科室id
//name	string	是	科室名称

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,strong)NSArray *members;


@end


@interface AllTeamModel : NSObject

//
//citys
//departments

@property (nonatomic,strong)NSArray *citys;

@property (nonatomic,strong)NSArray *departments;


@end
