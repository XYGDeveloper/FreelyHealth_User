//
//  TJOrderDetailApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/11.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJOrderDetailApi.h"
#import "TJOrderDetailModel.h"
@implementation TJOrderDetailApi

- (void)getOrderDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];

    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    TJOrderDetailModel *model = [TJOrderDetailModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
