//
//  OrderListApi.m
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderListApi.h"
#import "OrderListModel.h"
@implementation OrderListApi

- (void)getOrderList:(NSMutableDictionary *)detail
{
    [self startRequestWithParams:detail];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}


- (id)reformData:(id)responseObject {
    
    
    NSArray *arr = [OrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"orders"]];
    
    return arr;
    
}



@end
