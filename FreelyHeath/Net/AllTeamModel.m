//
//  AllTeamModel.m
//  FreelyHeath
//
//  Created by L on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AllTeamModel.h"


@implementation memberModel


@end


@implementation allCityModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"members":@"memberModel"
             };
}

@end

@implementation departModel



@end

@implementation AllTeamModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"citys":@"allCityModel",
             @"departments":@"departModel",
             };
}


@end
