//
//  PatientListTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientModel;
typedef void (^toadd)();
typedef void (^tomodify)();
@interface PatientListTableViewCell : UITableViewCell
@property (nonatomic,strong)toadd add;
@property (nonatomic,strong)tomodify modify;
- (void)refreshWithModel:(PatientModel *)model;

@end
