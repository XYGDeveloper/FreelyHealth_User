//
//  AppionmentDetailDesTableViewCell.h
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/20.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppionmentListDetailModel;

@interface AppionmentDetailDesTableViewCell : UITableViewCell
- (void)refreshWIithDetailModel:(AppionmentListDetailModel *)model;

@end
