//
//  BLListViewController.h
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseListModel;
typedef void (^getBLModel)(CaseListModel *model);
@interface BLListViewController : UIViewController
@property (nonatomic,strong)getBLModel blBlock;
@property (nonatomic,strong)NSString *id;

@end
