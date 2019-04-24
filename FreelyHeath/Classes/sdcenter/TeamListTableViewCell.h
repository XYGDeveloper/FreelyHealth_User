//
//  TeamListTableViewCell.h
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class members;
@class AppionmentDetailModel;
@interface TeamListTableViewCell : UITableViewCell

- (void)refreshWithModel:(members *)model;

- (void)refreshWithAppionmentModel:(AppionmentDetailModel *)model;
@end
