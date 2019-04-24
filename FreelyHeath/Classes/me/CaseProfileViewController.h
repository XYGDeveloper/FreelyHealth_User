//
//  CaseProfileViewController.h
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseDetailModel;
@interface CaseProfileViewController : UIViewController
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)CaseDetailModel *model;
@property (nonatomic,assign)BOOL isEdit;
@property (nonatomic,assign)BOOL hzenter;

@end
