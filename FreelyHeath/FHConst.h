//
//  FHConst.h
//  FreelyHeath
//
//  Created by L on 2017/7/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#ifndef FHConst_h
#define FHConst_h

#define RCIM_APPKEY   @"qd46yzrfqel8f"

#define Service_ID    @"KEFU150539755915325"

static NSString *const kLoginOutNotify = @"kloginOutNotify";

static NSString *const kLoginInNotification = @"kLoginInNotification";

static NSString *const kOrderPaySuccessNotify = @"kOrderPaySuccessNotify";

static NSString *const PayResultTypeSuccess = @"success";
static NSString *const PayResultTypeFailed = @"failure";
static NSString *const PayResultTypeCancel = @"cancel";
typedef void(^LocalPayResultBlock)(NSString *result);

#endif /* FHConst_h */
