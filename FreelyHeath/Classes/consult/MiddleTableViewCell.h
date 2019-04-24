//
//  MiddleTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJHeadLineModel.h"
#import "ZYJHeadLineView.h"
@class ConsultIndexModel;
@class TumorZoneListModel;
@class infomationModel;

typedef void (^questionBlock)();

@interface MiddleTableViewCell : UITableViewCell

//@property (nonatomic,strong) ZYJHeadLineView *TopLineView;
//
@property (nonatomic,strong)questionBlock ques;

- (void)refreshcellWithModel:(NSArray *)informations;

@end
