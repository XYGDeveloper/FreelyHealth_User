//
//  MyIntroTableViewCell.h
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CaseDetailModel;

@interface MyIntroTableViewCell : UITableViewCell

@property (nonatomic,strong)UILabel *introContent;

- (void)refreshWirthModel:(CaseDetailModel *)model;

- (void)refreshWirthModel1:(CaseDetailModel *)model;

- (void)refreshWirthModel2:(CaseDetailModel *)model;

- (void)refreshWirthModel3:(CaseDetailModel *)model;

- (void)refreshWirthModel4:(CaseDetailModel *)model;

- (void)refreshWirthModel5:(CaseDetailModel *)model;

@end
