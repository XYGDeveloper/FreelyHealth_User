//
//  ResultViewController.h
//  FreelyHeath
//
//  Created by L on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASSModel;

@interface ResultViewController : UIViewController

@property (nonatomic,strong)NSString *id;

@property (nonatomic,strong)ASSModel *model;

@property (nonatomic,strong)NSString *redult;


@end
