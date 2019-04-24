//
//  AppionmentPriceTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppionmentListDetailModel;
typedef void (^cancelAppionment)();
typedef void (^PayAppionment)();
@interface AppionmentPriceTableViewCell : UITableViewCell
@property (nonatomic,strong)cancelAppionment cancel;
@property (nonatomic,strong)PayAppionment pay;
- (void)refreshWithAppionmentDetailModel:(AppionmentListDetailModel *)model;
@end
