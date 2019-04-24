//
//  SelectBLTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseListModel;
typedef void (^editCase)();
@interface SelectBLTableViewCell : UITableViewCell
@property (nonatomic,strong)editCase editcase;
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic, assign) BOOL accessoryViewSelected;

- (void)refreshWithModel:(CaseListModel *)model;
@end
