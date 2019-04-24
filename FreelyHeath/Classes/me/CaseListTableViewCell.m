//
//  CaseListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/3/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseListTableViewCell.h"
#import "CaseListModel.h"
@interface CaseListTableViewCell()
@property (nonatomic,strong)UIView *bgContent;

@property (nonatomic,strong)UILabel *profileLabel;
@property (nonatomic,strong)UIButton *detailButton;
@property (nonatomic,strong)UILabel *topLine;

@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *nameContent;
@property (nonatomic,strong)UILabel *normalLabel;
@property (nonatomic,strong)UILabel *normalContent;
@property (nonatomic,strong)UILabel *conditionLabel;
@property (nonatomic,strong)UILabel *conditionLContent;
@property (nonatomic,strong)UIView *layserview;
@property (nonatomic,strong)UILabel *bottomLine;
@property (nonatomic,strong)UIButton *editButton;
@property (nonatomic,strong)UIButton *delButton;
@end
@implementation CaseListTableViewCell

- (UIView *)bgContent{
    if (!_bgContent) {
        _bgContent = [[UIView alloc] init];
//        _bgContent.backgroundColor = [UIColor whiteColor];
        self.layserview = [[UIView alloc]init];
        self.layserview.backgroundColor=[UIColor whiteColor];
        //v.layer.masksToBounds=YES;这行去掉
        self.layserview.layer.cornerRadius = 5;
        self.layserview.layer.shadowColor=DefaultGrayTextClor.CGColor;
        self.layserview.layer.shadowOffset=CGSizeMake(0, 1);
        self.layserview.layer.shadowOpacity=0.3;
        self.layserview.layer.shadowRadius= 2;
        [_bgContent addSubview:self.layserview];
    }
    return _bgContent;
}
- (UILabel *)profileLabel{
    if (!_profileLabel) {
        _profileLabel = [[UILabel alloc]init];
        _profileLabel.text = @"病历资料";
        _profileLabel.textAlignment = NSTextAlignmentLeft;
        _profileLabel.font = FontNameAndSize(16);
        _profileLabel.textColor =DefaultBlackLightTextClor;
    }
    return _profileLabel;
}

- (UIButton *)detailButton{
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        _detailButton.titleLabel.font  =FontNameAndSize(14);
        [_detailButton addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

- (UILabel *)topLine{
    if (!_topLine) {
        _topLine = [[UILabel alloc] init];
        _topLine.backgroundColor = DefaultBackgroundColor;
    }
    return _topLine;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = FontNameAndSize(15);
        _nameLabel.text  =@"姓      名";
        _nameLabel.textColor =DefaultGrayTextClor;
    }
    return _nameLabel;
}

- (UILabel *)nameContent{
    if (!_nameContent) {
        _nameContent = [[UILabel alloc]init];
        _nameContent.textAlignment = NSTextAlignmentLeft;
        _nameContent.font = FontNameAndSize(15);
        _nameContent.textColor =DefaultBlackLightTextClor;
    }
    return _nameContent;
}

- (UILabel *)normalLabel{
    if (!_normalLabel) {
        _normalLabel = [[UILabel alloc]init];
        _normalLabel.textAlignment = NSTextAlignmentLeft;
        _normalLabel.font = FontNameAndSize(15);
        _normalLabel.text  =@"基础状况";
        _normalLabel.textColor =DefaultGrayTextClor;
    }
    return _normalLabel;
}

- (UILabel *)normalContent{
    if (!_normalContent) {
        _normalContent = [[UILabel alloc]init];
        _normalContent.textAlignment = NSTextAlignmentLeft;
        _normalContent.font = FontNameAndSize(15);
        _normalContent.textColor =DefaultBlackLightTextClor;
    }
    return _normalContent;
}

- (UILabel *)conditionLabel{
    if (!_conditionLabel) {
        _conditionLabel = [[UILabel alloc]init];
        _conditionLabel.textAlignment = NSTextAlignmentLeft;
        _conditionLabel.font = FontNameAndSize(15);
        _conditionLabel.text  =@"主要症状";
        _conditionLabel.textColor =DefaultGrayTextClor;
    }
    return _conditionLabel;
}

- (UILabel *)conditionLContent{
    if (!_conditionLContent) {
        _conditionLContent = [[UILabel alloc]init];
        _conditionLContent.textAlignment = NSTextAlignmentLeft;
        _conditionLContent.font = FontNameAndSize(15);
        _conditionLContent.textColor =DefaultBlackLightTextClor;
    }
    return _conditionLContent;
}

- (UILabel *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UILabel alloc] init];
        _bottomLine.backgroundColor = DefaultBackgroundColor;
    }
    return _bottomLine;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"  编辑" forState:UIControlStateNormal];
        [_editButton setImage:[UIImage imageNamed:@"case_edit"] forState:UIControlStateNormal];
        [_editButton setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
        _editButton.titleLabel.font  =FontNameAndSize(14);
        [_editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (UIButton *)delButton{
    if (!_delButton) {
        _delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_delButton setTitle:@"  删除" forState:UIControlStateNormal];
        [_delButton setImage:[UIImage imageNamed:@"case_del"] forState:UIControlStateNormal];
        [_delButton setTitleColor:DefaultGrayLightTextClor forState:UIControlStateNormal];
        _delButton.titleLabel.font  =FontNameAndSize(14);
        [_delButton addTarget:self action:@selector(del) forControlEvents:UIControlEventTouchUpInside];

    }
    return _delButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = DefaultBackgroundColor;
        [self.contentView addSubview:self.bgContent];
        [self.bgContent addSubview:self.profileLabel];
        [self.bgContent addSubview:self.detailButton];
        [self.bgContent addSubview:self.topLine];
        [self.bgContent addSubview:self.nameLabel];
        [self.bgContent addSubview:self.nameContent];
        [self.bgContent addSubview:self.normalLabel];
        [self.bgContent addSubview:self.normalContent];
        [self.bgContent addSubview:self.conditionLabel];
        [self.bgContent addSubview:self.conditionLContent];
        [self.bgContent addSubview:self.bottomLine];
        [self.bgContent addSubview:self.editButton];
        [self.bgContent addSubview:self.delButton];
    }
    return self;
}

-(void)detail{
    if (self.todetail) {
        self.todetail();
    }
}

-(void)edit{
    if (self.toedit) {
        self.toedit();
    }
}
-(void)del{
    if (self.todel) {
        self.todel();
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    [self.layserview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.profileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(kScreenWidth - 100 - 40);
        make.height.mas_equalTo(35);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.profileLabel.mas_right);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(35);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.profileLabel.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.topLine.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    [self.nameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(self.topLine.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    [self.normalContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.normalLabel.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.normalLabel.mas_bottom).mas_equalTo(10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(20);
    }];
    [self.conditionLContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.conditionLabel.mas_right).mas_equalTo(10);
        make.top.mas_equalTo(self.normalLabel.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(self.conditionLContent.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.bottomLine.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.delButton.mas_left);
        make.top.mas_equalTo(self.bottomLine.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(70);
    }];
}

- (void)refreshWithModel:(CaseListModel *)model{
    self.nameContent.text = model.name;
    self.normalContent.text = [NSString stringWithFormat:@"性别：%@  年龄：%@",model.sex,model.age];
    self.conditionLContent.text = model.zhengzhuang;
}

@end
