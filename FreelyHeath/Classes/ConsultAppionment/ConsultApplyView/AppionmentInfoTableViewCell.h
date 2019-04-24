//
//  AppionmentInfoTableViewCell.h
//  app
//
//  Created by XI YANGUI on 2018/4/26.
//  Copyright © 2018年 XI YANGUI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppionmentListDetailModel;
@interface AppionmentInfoTableViewCell : UITableViewCell

- (void)refreshWIithDetailModel:(AppionmentListDetailModel *)model;

@end
