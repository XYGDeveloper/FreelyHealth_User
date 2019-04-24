//
//  PriceSelectNoPriceTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/20.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQNumCalculateView.h"
#import "PPNumberButton.h"
@class PriceModel;
typedef void (^getAmout)(NSInteger num ,BOOL increaseStatus);
@interface PriceSelectNoPriceTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *amoutLabel;
@property (nonatomic,strong)PPNumberButton *amoutLabelContent;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *nameLabelContent;
@property (nonatomic,strong)getAmout amout;

- (void)refreshWithModel:(PriceModel *)model;
@end
