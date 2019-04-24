//
//  ISTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "VipEditCell.h"
typedef void (^selectType)(NSString *type);

static NSString *const SexMale2 = @"1";
static NSString *const SexFemale2 = @"0";

@interface ISTableViewCell : VipEditCell
@property (nonatomic, strong) selectType type;
@property (nonatomic, copy) NSString *sex;
@end
