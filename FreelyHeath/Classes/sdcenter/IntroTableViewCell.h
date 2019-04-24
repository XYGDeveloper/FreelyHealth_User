//
//  IntroTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DoctorModel;

@interface IntroTableViewCell : UITableViewCell

@property (nonatomic,strong)UITextView *contentLabel1;

- (void)refreWithdocModel:(DoctorModel *)model;

- (void)refreWithdocModelTime:(DoctorModel *)model;

@end
