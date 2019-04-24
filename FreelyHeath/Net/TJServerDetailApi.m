//
//  TJServerDetailApi.m
//  FreelyHeath
//
//  Created by L on 2018/1/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJServerDetailApi.h"
#import "TJServerDetailModel.h"
@implementation TJServerDetailApi
- (void)sublistDetail:(NSMutableDictionary *)price{
    [self startRequestWithParams:price];
    
}

- (ApiCommand *)buildCommand {
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
}

- (id)reformData:(id)responseObject {
    TJServerDetailModel *model = [TJServerDetailModel mj_objectWithKeyValues:responseObject];
    return model;
}
@end
