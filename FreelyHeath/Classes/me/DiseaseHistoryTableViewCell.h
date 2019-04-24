//
//  DiseaseHistoryTableViewCell.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel;

@interface DiseaseHistoryTableViewCell : UITableViewCell

@property (nonatomic,strong)FileModel *model;

@property (nonatomic, assign) CGFloat cellHeight;

- (void)refreshWithModel:(FileModel *)model;

@end
