//
//  PatientListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PatientListTableViewCell.h"
#import "PatientModel.h"
@interface PatientListTableViewCell()
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UIButton *addcaseButton;
@property (nonatomic,strong)UIButton *modifyButton;

@end
@implementation PatientListTableViewCell

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"病历资料";
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = FontNameAndSize(15);
        _nameLabel.textColor =DefaultBlackLightTextClor;
    }
    return _nameLabel;
}

- (UIButton *)addcaseButton{
    if (!_addcaseButton) {
        _addcaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addcaseButton setTitle:@"新增病历" forState:UIControlStateNormal];
        [_addcaseButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _addcaseButton.titleLabel.font  =FontNameAndSize(14);
        [_addcaseButton addTarget:self action:@selector(addcase) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addcaseButton;
}

- (UIButton *)modifyButton{
    if (!_modifyButton) {
        _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyButton setTitle:@"修改资料" forState:UIControlStateNormal];
        [_modifyButton setTitleColor:[UIColor colorWithRed:108/255.0 green:226/255.0 blue:189/255.0 alpha:1] forState:UIControlStateNormal];
        _modifyButton.titleLabel.font  =FontNameAndSize(14);
        [_modifyButton addTarget:self action:@selector(modifys) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyButton;
}

- (void)addcase{
    if (self.add) {
        self.add();
    }
}

- (void)modifys{
    if (self.modify) {
        self.modify();
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addcaseButton];
        [self.contentView addSubview:self.modifyButton];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    [self.modifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.addcaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.modifyButton.mas_left).mas_equalTo(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)refreshWithModel:(PatientModel *)model{
    self.nameLabel.text = model.name;
}

@end
