//
//  RightTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "RightTableViewCell.h"
#import "CategoryModel.h"
#import "UIImage+GradientColor.h"
@interface RightTableViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation RightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageV = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageV];
//        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
//        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
//        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
       self.imageV.backgroundColor =AppStyleColor;
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.textColor = DefaultBlackLightTextClor;
        [self.contentView addSubview:self.typeLabel];
        self.typeLabel.font = [UIFont systemFontOfSize:25];
        self.contentLabel = [[UILabel alloc]init];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        self.contentLabel.font = FontNameAndSize(15);
        self.contentLabel.textColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.contentLabel];
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(5);
        }];
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageV.mas_right).mas_equalTo(10);
            make.centerY.mas_equalTo(self.imageV.mas_centerY);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(44);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageV.mas_bottom).mas_equalTo(20);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-20);
        }];
        
    }
    return self;
}

- (void)refreshWithModel:(FoodModel *)model{
    
    self.typeLabel.text = model.type;
    NSString *_test  = model.content;
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.alignment = NSTextAlignmentLeft;
    paraStyle01.headIndent = 0.0f;
    CGFloat emptylen = self.contentLabel.font.pointSize * 2;
    paraStyle01.firstLineHeadIndent = emptylen;
    paraStyle01.tailIndent = 0.0f;
    paraStyle01.lineSpacing = 2.0f;
    NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
    self.contentLabel.attributedText = attrText;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
