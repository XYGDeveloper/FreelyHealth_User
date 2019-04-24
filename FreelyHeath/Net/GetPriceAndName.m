//
//  GetPriceAndName.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetPriceAndName.h"
#import "PriceModel.h"
@implementation GetPriceAndName
- (void)getPrice:(NSMutableDictionary *)price
{
    [self startRequestWithParams:price];
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
     PriceModel *model = [PriceModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
