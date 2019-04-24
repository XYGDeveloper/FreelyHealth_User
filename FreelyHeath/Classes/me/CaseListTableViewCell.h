//
//  CaseListTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseListModel;
typedef void (^detail)();
typedef void (^edit)();
typedef void (^del)();
@interface CaseListTableViewCell : UITableViewCell

@property (nonatomic,strong)detail todetail;
@property (nonatomic,strong)edit toedit;
@property (nonatomic,strong)del todel;
- (void)refreshWithModel:(CaseListModel *)model;

@end
