//
//  TJItemTableviewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJItemTableviewCell.h"
#import "BigItemModel.h"
#import "UIView+AnimationProperty.h"
@interface TJItemTableviewCell()

@property (nonatomic,strong)UIImageView *imag;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *detail;
@property (nonatomic,strong)UILabel *price;

@end

@implementation TJItemTableviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imag = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imag];
        self.imag.contentMode = UIViewContentModeScaleAspectFill;
        self.imag.layer.cornerRadius = 4;
        self.imag.layer.masksToBounds = YES;
        self.imag.clipsToBounds = YES;
        [self.imag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.width.height.mas_equalTo(67);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        self.name = [[UILabel alloc]init];
        self.name.textColor = DefaultBlackLightTextClor;
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.font = FontNameAndSize(16);
        [self.contentView addSubview:self.name];
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imag.mas_top);
            make.left.mas_equalTo(self.imag.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-120);
            make.height.mas_equalTo(15);
        }];
        self.detail = [[UILabel alloc]init];
        self.detail.textColor = DefaultGrayLightTextClor;
        self.detail.textAlignment = NSTextAlignmentLeft;
        self.detail.font = FontNameAndSize(14);
        self.detail.numberOfLines = 0;
        [self.contentView addSubview:self.detail];
        [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.name.mas_bottom).mas_equalTo(5);
            make.left.mas_equalTo(self.imag.mas_right).mas_equalTo(10);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(self.imag.mas_bottom);
        }];
        
        self.price = [[UILabel alloc]init];
        self.price.textColor = AppStyleColor;
        self.price.textAlignment = NSTextAlignmentLeft;
        self.price.font = FontNameAndSize(15);
        self.price.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.price];
        [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imag.mas_top);
            make.left.mas_equalTo(self.name.mas_right).mas_equalTo(0);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)refreshWIthModel:(BigItemModel *)model{
    
    weakify(self);
    [self.imag sd_setImageWithURL:[NSURL URLWithString:model.imagepath]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           strongify(self);
                           self.imag.image = image;
                           self.imag.alpha = 0;
                           self.imag.scale = 1.1f;
                           [UIView animateWithDuration:0.5f animations:^{
                               self.imag.alpha = 1.f;
                               self.imag.scale = 1.f;
                           }];
                       }];
    self.name.text = model.name;
    self.detail.text = model.des;
//    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
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
