//
//  EvaluteResultTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/8/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASSModel;
@class ResultModel;

@interface EvaluteResultTableViewCell : UITableViewCell

- (void)refreshWithModel:(ASSModel *)model;

- (void)refreshWithResult:(ResultModel *)result;


@end
