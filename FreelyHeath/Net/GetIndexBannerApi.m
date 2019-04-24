//
//  GetIndexBannerApi.m
//  FreelyHeath
//
//  Created by L on 2017/9/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GetIndexBannerApi.h"
#import "IndexBannerModel.h"
@implementation GetIndexBannerApi

- (void)getBannerList:(NSMutableDictionary *)acha
{

    [self startRequestWithParams:acha];


}


- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    
    NSArray *arr = [IndexBannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"banners"]];
    
    return arr;
    
    
}


@end