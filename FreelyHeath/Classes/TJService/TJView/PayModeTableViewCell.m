//
//  PayModeTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/5/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PayModeTableViewCell.h"
@interface PayModeTableViewCell()

@end

@implementation PayModeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.payIMage = [[UIImageView alloc]init];
        self.payIMage.layer.cornerRadius = 4;
        [self.contentView addSubview:self.payIMage];
        [self.payIMage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.height.mas_equalTo(26);
        }];
        self.paylabel = [[UILabel alloc]init];
        self.paylabel.textColor = DefaultBlackLightTextClor;
        self.paylabel.textAlignment = NSTextAlignmentLeft;
        self.paylabel.font = Font(18);
        [self.contentView addSubview:self.paylabel];
        [self.paylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.payIMage.mas_right).mas_equalTo(15);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo(30);
        }];
        
        if (self.accessoryView == nil) {
            UIButton *accessoryView = [UIButton buttonWithType:UIButtonTypeCustom];
            [accessoryView setImage:[UIImage imageNamed:@"pay_normal"] forState:UIControlStateNormal];
            [accessoryView setImage:[UIImage imageNamed:@"pay_select"] forState:UIControlStateSelected];
            accessoryView.frame = CGRectMake(0, 22 / 2, 22, 22);
            accessoryView.userInteractionEnabled = NO;
            self.accessoryView = accessoryView;
        }
    }
    return self;
}


- (void)setAccessoryViewSelected:(BOOL)accessoryViewSelected {
    [(UIButton *)self.accessoryView setSelected:accessoryViewSelected];
}

- (BOOL)accessoryViewSelected {
    return [(UIButton *)self.accessoryView isSelected];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
