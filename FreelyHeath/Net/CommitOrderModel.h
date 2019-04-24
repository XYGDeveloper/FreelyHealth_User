//
//  CommitOrderModel.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommitOrderModel : NSObject

//{"msg":"请求成功","data":{"orderno":"170801815829","orderid":"5579ef526a4141da8ad8778e55af3e49"},"returncode":"10000"}

@property (nonatomic,copy)NSString *orderno;

@property (nonatomic,copy)NSString *orderid;

@end
