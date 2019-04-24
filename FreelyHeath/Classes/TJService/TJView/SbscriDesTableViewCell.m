//
//  SbscriDesTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SbscriDesTableViewCell.h"
#import "TJOrderDetailModel.h"
@interface SbscriDesTableViewCell()
@property (nonatomic,strong)UILabel *subsName;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *subsDetail;
@property (nonatomic,strong)UIButton *scanDetail;
@end

@implementation SbscriDesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.subsDetail = [[UILabel alloc]init];
        self.subsDetail.numberOfLines = 0;
        self.subsDetail.font = FontNameAndSize(16);
        self.subsDetail.textAlignment = NSTextAlignmentLeft;
        self.subsDetail.textColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.subsDetail];
        
        self.subsName = [[UILabel alloc]init];
        self.subsName.font = FontNameAndSize(16);
        self.subsName.textAlignment = NSTextAlignmentLeft;
        self.subsName.textColor = DefaultBlackLightTextClor;
        [self.contentView addSubview:self.subsName];
        self.priceLabel = [[UILabel alloc]init];
        self.priceLabel.font = FontNameAndSize(16);
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        self.priceLabel.textColor = AppStyleColor;
        [self.contentView addSubview:self.priceLabel];
        self.scanDetail = [UIButton buttonWithType:UIButtonTypeCustom];
        self.scanDetail.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.scanDetail];
        [self.scanDetail setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [self.scanDetail setTitle:@"查看详情" forState:UIControlStateNormal];
        self.scanDetail.titleLabel.font = FontNameAndSize(16);
        [self.scanDetail addTarget:self action:@selector(toDetail) forControlEvents:UIControlEventTouchUpInside];
        [self layOut];
    }
    return self;
}
- (void)toDetail{
    if (self.detail) {
        self.detail();
    }
}

- (void)layOut{
    [self.subsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-120);
        make.height.mas_equalTo(30);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.subsName.mas_right);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(30);
    }];
    [self.subsDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.subsName.mas_bottom).mas_equalTo(5);
        make.right.mas_equalTo(-16);
    }];
    [self.scanDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.subsDetail.mas_bottom).mas_equalTo(5);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)refreshWithModel:(TJOrderDetailModel *)model{
    
    self.subsName.text = model.name;
    self.subsDetail.text = model.des;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.payment];
}

@end
