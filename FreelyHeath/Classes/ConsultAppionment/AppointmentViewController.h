//
//  AppointmentViewController.h
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentViewController : UIViewController
@property (nonatomic,strong)NSString *teamid;
@property (nonatomic,strong)NSArray *teamMember;
@property (nonatomic,assign)BOOL isLSTD ;

@end
