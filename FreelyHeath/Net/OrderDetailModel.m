//
//  OrderDetailModel.m
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation itemModel



@end


@implementation OrderDetailModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"items":@"itemModel"};
}



@end