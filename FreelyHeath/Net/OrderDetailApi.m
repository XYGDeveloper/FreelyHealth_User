//
//  OrderDetailApi.m
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderDetailApi.h"
#import "OrderDetailModel.h"
@implementation OrderDetailApi

- (void)getOrderdetail:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    
    OrderDetailModel *model = [OrderDetailModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}


@end
