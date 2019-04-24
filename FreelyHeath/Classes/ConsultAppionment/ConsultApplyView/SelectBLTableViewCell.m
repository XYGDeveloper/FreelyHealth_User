//
//  SelectBLTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectBLTableViewCell.h"
#import "CaseListModel.h"
@interface SelectBLTableViewCell()
@property (nonatomic,copy)UILabel *infoLabel;
@property (nonatomic,copy)UIButton *editButton;
@property (nonatomic,copy)UILabel *deftailLabel;
@end

@implementation SelectBLTableViewCell

- (UIImageView *)chooseImageView{
    if (!_chooseImageView) {
        _chooseImageView = [[UIImageView alloc]init];
    }
    return _chooseImageView;
}
- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = DefaultBlackLightTextClor;
        _infoLabel.font = FontNameAndSize(15);
        _infoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _infoLabel;
}

- (UILabel *)deftailLabel{
    if (!_deftailLabel) {
        _deftailLabel = [[UILabel alloc]init];
        _deftailLabel.textColor = DefaultGrayLightTextClor;
        _deftailLabel.font = FontNameAndSize(15);
        _deftailLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _deftailLabel;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _editButton.backgroundColor = [UIColor whiteColor];
        [_editButton setBackgroundImage:[UIImage imageNamed:@"bl_edit_sel"] forState:UIControlStateNormal];
        [_editButton addTarget:self action:@selector(editCase) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (void)layOutsubview{
    [self.chooseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(17);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.chooseImageView.mas_right).mas_equalTo(20);
        make.right.mas_equalTo(-45);
        make.height.mas_equalTo(15);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLabel.mas_right).mas_equalTo(10);
        make.centerY.mas_equalTo(self.infoLabel.mas_centerY);
        make.width.height.mas_equalTo(15);
    }];
    [self.deftailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chooseImageView.mas_bottom).mas_equalTo(-2);
        make.left.mas_equalTo(self.infoLabel.mas_left);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(16);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.chooseImageView];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.editButton];
        [self.contentView addSubview:self.deftailLabel];
        [self layOutsubview];
    }
    return self;
}

- (void)refreshWithModel:(CaseListModel *)model{
    self.infoLabel.text = [NSString stringWithFormat:@"%@  %@  %@",model.name,model.sex,model.age];
    self.deftailLabel.text = model.zhengzhuang;
    if (model.select == YES) {
        self.chooseImageView.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    }else{
        self.chooseImageView.image = [UIImage imageNamed:@"normal_n"];
    }
}

- (void)editCase{
    if (self.editcase) {
        self.editcase();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//       _chooseImageView.image = selected?[UIImage imageNamed:@"mycollection_dele_sel"]:[UIImage imageNamed:@"normal_n"];
}

@end
