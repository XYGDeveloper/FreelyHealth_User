//
//  PriceDisplayTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/5/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TunorDetail;
@interface PriceDisplayTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *tjImg;

@property (nonatomic,strong)UILabel *tjName;

@property (nonatomic,strong)UIImageView *tipLabel;

@property (nonatomic,strong)UILabel *tjDetail;
- (void)refreshWithModel:(TunorDetail *)model;
@end
