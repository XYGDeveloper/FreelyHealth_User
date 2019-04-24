//
//  CaseInfoTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/3/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseInfoTableViewCell.h"
#import "CaseDetailModel.h"
@interface CaseInfoTableViewCell()

@property (nonatomic,strong)UILabel *infoDes;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *sexLabel;
@property (nonatomic,strong)UILabel *ageLabel;
@property (nonatomic,strong)UILabel *hunLabel;
@property (nonatomic,strong)UILabel *nameLabelContent;
@property (nonatomic,strong)UILabel *sexLabelContent;
@property (nonatomic,strong)UILabel *ageLabelContent;
@property (nonatomic,strong)UILabel *hunLabelContent;
@property (nonatomic,strong)UIView *sep0;
@property (nonatomic,strong)UIView *sep1;
@property (nonatomic,strong)UIView *sep2;
@property (nonatomic,strong)UIView *sep3;
@property (nonatomic,strong)UIView *sep4;

@end

@implementation CaseInfoTableViewCell
- (UILabel *)infoDes{
    if (!_infoDes) {
        _infoDes = [[UILabel alloc]init];
        _infoDes.text = @"患者信息";
        _infoDes.textAlignment = NSTextAlignmentLeft;
        _infoDes.font = [UIFont systemFontOfSize:16.0f weight:0.3];
        _infoDes.textColor = DefaultBlackLightTextClor;
    }
    return _infoDes;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"姓名";
        _nameLabel.textColor  =DefaultGrayTextClor;
        _nameLabel.font = FontNameAndSize(16);
        _nameLabel.textAlignment  = NSTextAlignmentLeft;
    }
    return _nameLabel;
}
- (UILabel *)nameLabelContent{
    if (!_nameLabelContent) {
        _nameLabelContent = [[UILabel alloc]init];
        _nameLabelContent.textColor  =DefaultBlackLightTextClor;
        _nameLabelContent.font = FontNameAndSize(16);
        _nameLabelContent.textAlignment  = NSTextAlignmentLeft;
    }
    return _nameLabelContent;
}

- (UILabel *)sexLabel{
    if (!_sexLabel) {
        _sexLabel = [[UILabel alloc]init];
        _sexLabel.text = @"性别";
        _sexLabel.textColor  =DefaultGrayTextClor;
        _sexLabel.font = FontNameAndSize(16);
        _sexLabel.textAlignment  = NSTextAlignmentLeft;
    }
    return _sexLabel;
}
- (UILabel *)sexLabelContent{
    if (!_sexLabelContent) {
        _sexLabelContent = [[UILabel alloc]init];
        _sexLabelContent.textColor  =DefaultBlackLightTextClor;
        _sexLabelContent.font = FontNameAndSize(16);
        _sexLabelContent.textAlignment  = NSTextAlignmentLeft;
    }
    return _sexLabelContent;
}
- (UILabel *)ageLabel{
    if (!_ageLabel) {
        _ageLabel = [[UILabel alloc]init];
        _ageLabel.text = @"年龄";
        _ageLabel.textColor  =DefaultGrayTextClor;
        _ageLabel.font = FontNameAndSize(16);
        _ageLabel.textAlignment  = NSTextAlignmentLeft;
    }
    return _ageLabel;
}
- (UILabel *)ageLabelContent{
    if (!_ageLabelContent) {
        _ageLabelContent = [[UILabel alloc]init];
        _ageLabelContent.textColor  =DefaultBlackLightTextClor;
        _ageLabelContent.font = FontNameAndSize(16);
        _ageLabelContent.textAlignment  = NSTextAlignmentLeft;
    }
    return _ageLabelContent;
}

- (UILabel *)hunLabel{
    if (!_hunLabel) {
        _hunLabel = [[UILabel alloc]init];
        _hunLabel.text = @"婚姻";
        _hunLabel.textColor  =DefaultGrayTextClor;
        _hunLabel.font = FontNameAndSize(16);
        _hunLabel.textAlignment  = NSTextAlignmentLeft;
    }
    return _hunLabel;
}
- (UILabel *)hunLabelContent{
    if (!_hunLabelContent) {
        _hunLabelContent = [[UILabel alloc]init];
        _hunLabelContent.textColor  =DefaultBlackLightTextClor;
        _hunLabelContent.font = FontNameAndSize(16);
        _hunLabelContent.textAlignment  = NSTextAlignmentLeft;
    }
    return _hunLabelContent;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.infoDes];
        self.sep0 = [[UIView alloc]init];
        self.sep0.alpha  =0.5;
        self.sep0.backgroundColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.sep0];
      
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.nameLabelContent];
        self.sep1 = [[UIView alloc]init];
        self.sep1.alpha  =0.5;
        self.sep1.backgroundColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.sep1];
        
        [self.contentView addSubview:self.sexLabel];
        [self.contentView addSubview:self.sexLabelContent];
        self.sep2 = [[UIView alloc]init];
        self.sep2.alpha  =0.5;
        self.sep2.backgroundColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.sep2];
        
        [self.contentView addSubview:self.ageLabel];
        [self.contentView addSubview:self.ageLabelContent];
        self.sep3 = [[UIView alloc]init];
        self.sep3.alpha  =0.5;
        self.sep3.backgroundColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.sep3];
        
        [self.contentView addSubview:self.hunLabel];
        [self.contentView addSubview:self.hunLabelContent];
    }
    return self;
}

//201.5

- (void)layoutSubviews{
    [super layoutSubviews];     //40
    [self.infoDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];                         //0.5
    [self.sep0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.infoDes.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];                        //40
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.sep0.mas_bottom);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.nameLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.top.mas_equalTo(self.sep0.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];                        //0.5
    [self.sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
                               //40
    [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.sep1.mas_bottom);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.sexLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sexLabel.mas_right);
        make.top.mas_equalTo(self.sep1.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];                       //0.5
    [self.sep2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.sexLabel.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
                              //40
    [self.ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.sep2.mas_bottom);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.ageLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ageLabel.mas_right);
        make.top.mas_equalTo(self.sep2.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];                        //0.5
    [self.sep3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.ageLabel.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
                             //40
    [self.hunLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.sep3.mas_bottom);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    [self.hunLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hunLabel.mas_right);
        make.top.mas_equalTo(self.sep3.mas_bottom);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
}

- (void)refreshWithModel:(CaseDetailModel *)model{
    self.nameLabelContent.text = model.name;
    self.sexLabelContent.text = model.sex;
    self.ageLabelContent.text = model.age;
    if ([model.ismarry isEqualToString:@"1"]) {
        self.hunLabelContent.text = @"已婚";
    }else{
        self.hunLabelContent.text = @"未婚";
    }
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
