//
//  MyfileApi.m
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyfileApi.h"
#import "FileModel.h"
@implementation MyfileApi

- (void)getmyfile:(NSMutableDictionary *)detail
{

    [self startRequestWithParams:detail];

}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    FileModel *model = [FileModel mj_objectWithKeyValues:responseObject];
    
    return model;
    
}


@end
