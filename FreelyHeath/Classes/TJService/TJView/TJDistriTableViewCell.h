//
//  TJDistriTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PriceModel;

@interface TJDistriTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *tjImg;

@property (nonatomic,strong)UILabel *tjName;

@property (nonatomic,strong)UIImageView *tipLabel;

@property (nonatomic,strong)UILabel *tjDetail;

- (void)refreshWithModel:(PriceModel *)model;

@end
