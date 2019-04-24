//
//  ApplyHZViewController.h
//  FreelyHeath
//
//  Created by L on 2018/5/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WKWebViewController.h"

@interface ApplyHZViewController : WKWebViewController
@property (nonatomic,copy)NSString *teamId;
@property (nonatomic,copy)NSArray *teamMember;
@property (nonatomic,assign)BOOL isLSTD;

@end
