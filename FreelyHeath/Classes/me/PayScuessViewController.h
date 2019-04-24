//
//  PayScuessViewController.h
//  FreelyHeath
//
//  Created by L on 2017/8/1.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayScuessViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *serviceType;

@property (weak, nonatomic) IBOutlet UILabel *serviceObj;

@property (weak, nonatomic) IBOutlet UIButton *scanOrder;

@property (nonatomic,strong)NSString *service;

@property (nonatomic,strong)NSString *name;

@property (nonatomic,strong)NSString *phone;

@property (nonatomic,strong)NSString *hzid;

@property (nonatomic,assign)BOOL  aEnter;

@property (nonatomic,assign)BOOL  aEnterHZ;

@end
