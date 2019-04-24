//
//  TJDistriTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJDistriTableViewCell.h"
#import "PriceModel.h"
@implementation TJDistriTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.tjImg = [[UIImageView alloc]init];
        self.tjImg.layer.cornerRadius = 2;
        self.tjImg.layer.borderWidth = 0.4;
        self.tjImg.layer.borderColor = DividerGrayColor.CGColor;
        self.tjImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.tjImg];
        self.tjName = [[UILabel alloc]init];
        self.tjName.font = FontNameAndSize(16);
        self.tjName.textAlignment = NSTextAlignmentLeft;
        self.tjName.textColor = DefaultBlackLightTextClor;
        self.tjName.text = @"专家会诊";
        [self.contentView addSubview:self.tjName];
        self.tipLabel = [[UIImageView alloc]init];
        self.tipLabel.image = [UIImage imageNamed:@"tj_tipheader"];
        [self.contentView addSubview:self.tipLabel];
        self.tjDetail = [[UILabel alloc]init];
        self.tjDetail.font = FontNameAndSize(14);
        self.tjDetail.textAlignment = NSTextAlignmentLeft;
        self.tjDetail.textColor = DefaultGrayLightTextClor;
        self.tjDetail.text = @"客服将与您联系，请保持手机畅通";
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
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tjImg.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(self.tjDetail.mas_centerY);
            make.width.height.mas_equalTo(15);
        }];
        [self.tjDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.tipLabel.mas_right).mas_equalTo(5);
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(-10);
            make.top.mas_equalTo(self.tjName.mas_bottom).mas_equalTo(0);
        }];
    }
    
    return self;
    
}

- (void)refreshWithModel:(PriceModel *)model{
    self.tjName.text = model.name;
    [self.tjImg sd_setImageWithURL:[NSURL URLWithString:model.imagepath]];
    self.tjDetail.text = @"请提前与客服联系，以便及时安排服务";
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
