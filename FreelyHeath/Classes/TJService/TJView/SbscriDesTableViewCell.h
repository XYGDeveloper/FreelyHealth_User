//
//  SbscriDesTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJOrderDetailModel;
typedef void (^toDetail)();
@interface SbscriDesTableViewCell : UITableViewCell
@property (nonatomic,strong)toDetail detail;
- (void)refreshWithModel:(TJOrderDetailModel *)model;

@end
