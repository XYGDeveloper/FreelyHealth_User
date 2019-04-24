//
//  SelectTeamApi.m
//  MedicineClient
//
//  Created by L on 2017/9/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectTeamApi.h"
#import "JopModel.h"
@implementation SelectTeamApi


- (void)gethosteamList:(NSMutableDictionary *)acha
{
    [self startRequestWithParams:acha];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"请求成功%@",responseObject);
    
    NSArray *jopArr = [JopModel mj_objectArrayWithKeyValuesArray:responseObject[@"teams"]];
    
    return jopArr;
    
}


@end
