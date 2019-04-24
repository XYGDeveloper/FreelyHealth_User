//
//  TjServiceTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJListModel;

@interface TjServiceTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *leftView;

- (void)refdreshWith:(TJListModel *)model;

@end
