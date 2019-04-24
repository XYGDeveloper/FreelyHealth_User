//
//  AppionmentListModel.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentListModel.h"

@implementation MemberChildModel
@end

@implementation AppionmentListModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"members":@"MemberChildModel",
             };
}
@end
