//
//  MyfileTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class recordModel;

@interface MyfileTableViewCell : UITableViewCell

@property (nonatomic, strong) recordModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

- (void)refreshWithModel:(recordModel *)model;


@end
