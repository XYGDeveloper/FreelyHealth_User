//
//  DoctoTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DoctoTableViewCell.h"


@interface DoctoTableViewCell ()


@property (weak, nonatomic) IBOutlet UIImageView *headImage;

@property (weak, nonatomic) IBOutlet UILabel *bageValue;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *hotelName;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end


@implementation DoctoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bageValue.layer.cornerRadius = 9;
    
    self.bageValue.layer.masksToBounds = YES;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
