//
//  teamQuaryApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "teamQuaryApi.h"
#import "AllTeamModel.h"
@implementation teamQuaryApi

- (void)teamQuaryList:(NSMutableDictionary *)detail{

    [self startRequestWithParams:detail];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSLog(@"ppp%@",responseObject);
    
    AllTeamModel *model = [AllTeamModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
    
}

@end
