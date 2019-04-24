//
//  EditPatientsViewController.h
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditPatientsViewController : UIViewController
@property (nonatomic,strong)NSString *id;
@property (nonatomic,assign)BOOL isSamePatientments;//判断是否有相同患者存在

@end
