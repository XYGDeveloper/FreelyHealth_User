//
//  HisBgTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/11/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryModel;

@interface HisBgTableViewCell : UITableViewCell

- (void)refreshWithModel:(HistoryModel *)model;


@end
