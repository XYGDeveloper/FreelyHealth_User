//
//  GroupInfoModel.m
//  FreelyHeath
//
//  Created by L on 2018/5/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GroupInfoModel.h"

@implementation groupMemberModel

@end

@implementation GroupInfoModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"peoples":@"groupMemberModel"};
}

@end
