//
//  ConponTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyconponListModel;
@interface ConponTableViewCell : UITableViewCell
@property (nonatomic,assign)BOOL isSel;
- (void)refreshWithMyconponModel:(MyconponListModel *)model;
- (void)refreshWithMyOrderconponModel:(MyconponListModel *)model;

@end
