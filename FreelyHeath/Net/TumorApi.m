//
//  TumorApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TumorApi.h"
#import "TumorTreamentModel.h"
@implementation TumorApi

- (void)tumInfo:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSArray *arr = [TumorTreamentModel mj_objectArrayWithKeyValuesArray:responseObject[@"goods"]];
    
    return arr;
    
}


@end
