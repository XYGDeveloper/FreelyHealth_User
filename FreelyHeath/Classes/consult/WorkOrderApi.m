//
//  WorkOrderApi.m
//  FreelyHeath
//
//  Created by L on 2017/10/31.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WorkOrderApi.h"
#import "WorkOrderModel.h"

@interface WorkOrderApi()

@property (nonatomic,copy)NSString *timestamp;

@property (nonatomic,copy)NSString *sign;

@end

@implementation WorkOrderApi

- (id)initWithOrderStatus:(NSString *)timestamp hotelid:(NSString *)sign {
    if (self = [super init]) {
        self.timestamp = timestamp;
        self.sign = sign;
    }
    return self;
}

- (void)workorder:(NSMutableDictionary *)detail
{
      [self startRequestWithParams:detail];
}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    NSString *url = [NSString stringWithFormat:@"http://shanghaidemo0705.udesk.cn/open_api_v1/tickets?email=shudesk@163.com&timestamp=%@&sign=%@",self.timestamp,self.sign];
    command.requestURLString = url;
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    WorkOrderModel *model = [WorkOrderModel mj_objectWithKeyValues:responseObject];
    return model;
    
}


@end
