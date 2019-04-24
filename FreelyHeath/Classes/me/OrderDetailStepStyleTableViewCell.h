//
//  OrderDetailStepStyleTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class itemModel;

@interface OrderDetailStepStyleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stepNum;

- (void)refreshWithModel:(itemModel *)model;


@end
