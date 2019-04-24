//
//  TumorDetailApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TumorDetailApi.h"
#import "TunorDetail.h"
@implementation TumorDetailApi

- (void)getDetail:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    
    TunorDetail *model = [TunorDetail mj_objectWithKeyValues:responseObject];
    
    return model;
    
    
}


@end
