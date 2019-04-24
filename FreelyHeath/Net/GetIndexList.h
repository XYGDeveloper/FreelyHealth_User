//
//  GetIndexList.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BaseApi.h"
@class IndexListModel;

@interface GetIndexList : BaseApi

- (void)getIndexList:(NSMutableDictionary *)detail;


@end
