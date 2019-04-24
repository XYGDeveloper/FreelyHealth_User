//
//  OrderFillViewController.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TunorDetail;

@class OrderDetailModel;

@interface OrderFillViewController : UIViewController

@property (nonatomic,strong)TunorDetail *model;

@property (nonatomic,assign)BOOL revireOrder;

@property (nonatomic,strong)OrderDetailModel *orderDetailModel;

@property (nonatomic,strong)NSString *holpId;

@end
