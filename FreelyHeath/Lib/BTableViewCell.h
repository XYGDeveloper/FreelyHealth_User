//
//  BTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "VipEditCell.h"
typedef void (^selectType)(NSString *);

static NSString *const SexMale0 = @"1";
static NSString *const SexFemale0 = @"0";

@interface BTableViewCell : VipEditCell
@property (nonatomic, strong) selectType type;
@property (nonatomic, copy) NSString *sex;
@end
