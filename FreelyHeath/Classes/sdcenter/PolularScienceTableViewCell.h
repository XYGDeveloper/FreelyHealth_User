//
//  PolularScienceTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class infomationModel;

@interface PolularScienceTableViewCell : UITableViewCell

@property (nonatomic)UILabel *sep;

- (void)refreshWithModel:(infomationModel *)model;

@end
