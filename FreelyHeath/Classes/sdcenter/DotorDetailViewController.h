//
//  DotorDetailViewController.h
//  FreelyHeath
//
//  Created by L on 2017/11/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountTableViewCell.h"
#import "IntroTableViewCell.h"
#import "UIButton+LXMImagePosition.h"
#import "DoctorApi.h"
#import "DoctorIntroduceRuquset.h"
#import "DoctorModel.h"
#import <UShareUI/UShareUI.h>
#import "CustomerViewController.h"
#import "ChatWithMachViewController.h"
#import "UINavigationBar+Extion.h"
#import "UIView+Extion.h"
#import "ButtonTableViewCell.h"
#import "MedicalDetailController.h"
#import "ZJImageMagnification.h"
#import "MBProgressHUD+BWMExtension.h"
@interface DotorDetailViewController : UIViewController

@property (nonatomic,strong)NSString *ID;

@property (nonatomic,strong)NSString *chatID;

@end
