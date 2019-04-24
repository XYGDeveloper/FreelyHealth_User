//
//  AppionmentDetailDesTableViewCell.m
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/20.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentDetailDesTableViewCell.h"
#import "AppionmentListDetailModel.h"
@interface AppionmentDetailDesTableViewCell()
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detailLabel;

@end
@implementation AppionmentDetailDesTableViewCell
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = DefaultGrayTextClor;
        _titleLabel.font = FontNameAndSize(16);
        _titleLabel.text = @"病史资料";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = DefaultBlackLightTextClor;
        _detailLabel.font = FontNameAndSize(16);
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self layOut];
    }
    return self;
}

- (void)layOut{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
  
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
    }];

}

- (void)refreshWIithDetailModel:(AppionmentListDetailModel *)model{
    if (!model.zhengzhuang || model.zhengzhuang.length <= 0) {
        self.detailLabel.text = @"无病史资料";
    }else{
        self.detailLabel.text = model.zhengzhuang;
    }
    self.titleLabel.text = @"病史资料";
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
