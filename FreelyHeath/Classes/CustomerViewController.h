//
//  CustomerViewController.h
//  FreelyHeath
//
//  Created by L on 2017/8/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface CustomerViewController : RCConversationViewController

@property (nonatomic,assign)BOOL isConsultQuestion;

@property (nonatomic,strong)NSString *consultText;

@property (nonatomic,strong)NSArray *consultImages;



@end
