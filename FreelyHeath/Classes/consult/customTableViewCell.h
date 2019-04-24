//
//  customTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJHeadLineModel.h"
#import "ZYJHeadLineView.h"
@class ConsultIndexModel;

typedef void (^jumpResult)();
typedef void (^questionBlock)(NSInteger index);

@interface customTableViewCell : UITableViewCell

@property (nonatomic,strong)questionBlock ques;

@property (nonatomic,strong)jumpResult result;

- (void)refreshWithModel:(ConsultIndexModel *)model;

@end
