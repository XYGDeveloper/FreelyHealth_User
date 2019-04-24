//
//  QuestionAndAuswerCellTableViewCell.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TumorZoneListModel;

typedef void (^questionBlock)(NSInteger index);

@interface QuestionAndAuswerCellTableViewCell : UITableViewCell

@property (nonatomic,strong)questionBlock ques;




@end
