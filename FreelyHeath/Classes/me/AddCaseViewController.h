//
//  AddCaseViewController.h
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseDetailModel;

@interface AddCaseViewController : UIViewController
@property (nonatomic,assign)BOOL ptlistEnter;   //从患者列表进入
@property (nonatomic,assign)BOOL btlistEnter;   //从病历列表进入
@property (nonatomic,assign)BOOL hzEnter;   //从病历列表进入

@property (nonatomic,strong)CaseDetailModel *bmodel;
@property (nonatomic,strong)NSString *id;
@end
