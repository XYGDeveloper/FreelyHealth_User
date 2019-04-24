//
//  PhysicalTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TumorTreamentModel;
@class serverModel;
@class PhyicalModel;
@interface PhysicalTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *bgView;

@property (nonatomic,strong)UIView *showLayer;

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *content;

@property (nonatomic,strong)UIImageView *topImage;

- (void)refreshWithModel1:(PhyicalModel *)model;

- (void)refreshWithModel:(serverModel *)model;

- (void)refreshWithTurModel:(TumorTreamentModel *)model;

- (void)refreshWithTurTJBG;

@end
