//
//  GenDetailViewController.h
//  FreelyHeath
//
//  Created by L on 2017/9/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WKWebViewController.h"

@interface GenDetailViewController : WKWebViewController

@property (nonatomic,assign)BOOL isOrder;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *id;

@end
