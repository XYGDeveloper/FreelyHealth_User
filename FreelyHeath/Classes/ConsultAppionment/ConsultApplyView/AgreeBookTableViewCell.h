//
//  AgreeBookTableViewCell.h
//  MedicineClient
//
//  Created by L on 2018/5/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AgreeBookModel;
@interface AgreeBookTableViewCell : UITableViewCell
- (void)refreshWithModel:(AgreeBookModel *)model;

@end
