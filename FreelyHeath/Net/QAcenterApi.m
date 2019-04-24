//
//  QAcenterApi.m
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QAcenterApi.h"
#import "bannerModel.h"
@implementation QAcenterApi

- (void)getBannerListWithRequest:(NSMutableDictionary *)bannerRequest{

    [self startRequestWithParams:bannerRequest];

}

- (ApiCommand *)buildCommand {
    
    ApiCommand *command = [ApiCommand defaultApiCommand];
    command.requestURLString = APIURL(@"");
    
    return command;
    
}

- (id)reformData:(id)responseObject {
    
    NSArray *array = [bannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"banners"]];
    
    return array;
    
}


@end
