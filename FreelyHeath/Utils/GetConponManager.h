//
//  GetConponManager.h
//  FreelyHeath
//
//  Created by L on 2018/5/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadToolRequest.h"
#import "LYZAdView.h"
#import "BaseMessageView.h"

typedef void (^block)();
@interface GetConponManager : NSObject<BaseMessageViewDelegate>
@property (nonatomic,strong)block block;
+ (instancetype)sharedConpon;
- (void)getConpon;
@end
