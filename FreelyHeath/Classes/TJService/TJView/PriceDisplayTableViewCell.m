//
//  PriceDisplayTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/5/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PriceDisplayTableViewCell.h"
#import "TunorDetail.h"
@implementation PriceDisplayTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.tjImg = [[UIImageView alloc]init];
        self.tjImg.layer.cornerRadius = 2;
        self.tjImg.layer.borderWidth = 0.4;
        self.tjImg.image = [UIImage imageNamed:@"Appionment_tjimage"];
        self.tjImg.layer.borderColor = DividerGrayColor.CGColor;
        self.tjImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.tjImg];
        self.tjName = [[UILabel alloc]init];
        self.tjName.font = FontNameAndSize(16);
        self.tjName.textAlignment = NSTextAlignmentLeft;
        self.tjName.textColor = DefaultBlackLightTextClor;
        [self.contentView addSubview:self.tjName];
        self.tjDetail = [[UILabel alloc]init];
        self.tjDetail.font = FontNameAndSize(16);
        self.tjDetail.textAlignment = NSTextAlignmentLeft;
        self.tjDetail.textColor = DefaultBlueTextClor;
        self.tjDetail.numberOfLines = 0;
        [self.contentView addSubview:self.tjDetail];
        [self.tjImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.width.height.mas_equalTo(50);
            make.left.mas_equalTo(20);
        }];
        
        [self.tjName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tjImg.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(self.tjImg.mas_top);
            make.height.mas_equalTo(20);
        }];
      
        [self.tjDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tjImg.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(25);
            make.top.mas_equalTo(self.tjName.mas_bottom).mas_equalTo(5);
        }];
    }
    
    return self;
    
}

- (void)refreshWithModel:(TunorDetail *)model{
    self.tjName.text = model.name;
    self.tjDetail.text = [NSString stringWithFormat:@"¥%@",model.datailo];
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
