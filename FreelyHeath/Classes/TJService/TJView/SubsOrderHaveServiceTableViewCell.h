//
//  SubsOrderHaveServiceTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/21.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJOrderDetailModel;
@interface SubsOrderHaveServiceTableViewCell : UITableViewCell
- (void)refreshWithModel:(TJOrderDetailModel *)model;

@end
