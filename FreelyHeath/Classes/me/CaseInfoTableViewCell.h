//
//  CaseInfoTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseDetailModel;
@interface CaseInfoTableViewCell : UITableViewCell

- (void)refreshWithModel:(CaseDetailModel *)model;

@end
