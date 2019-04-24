//
//  AppiontmentTopTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppiontmentTopTableViewCell.h"
#import "CommitApplyModel.h"
@interface AppiontmentTopTableViewCell()
@property (nonatomic,strong)UIImageView *topimage;
@property (nonatomic,strong)UILabel *des;

@end

@implementation AppiontmentTopTableViewCell

- (UIImageView *)topimage{
    if (!_topimage) {
        _topimage = [[UIImageView alloc]init];
        _topimage.backgroundColor = [UIColor clearColor];
    }
    return _topimage;
}

- (UILabel *)des{
    if (!_des) {
        _des = [[UILabel alloc]init];
        _des.backgroundColor = [UIColor whiteColor];
        _des.textColor = DefaultBlackLightTextClor;
        _des.font = FontNameAndSize(14);
        _des.textAlignment = NSTextAlignmentLeft;
        _des.numberOfLines = 0;
    }
    return _des;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

   self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topimage];
        [self.contentView addSubview:self.des];
        [self layOut];
    }
    return self;
}

- (void)layOut{
    [self.topimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(175);
    }];
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topimage.mas_bottom).mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)refeshWIthModel:(CommitApplyModel *)model{
    [self.topimage sd_setImageWithURL:[NSURL URLWithString:model.topImage] placeholderImage:[UIImage imageNamed:@""]];
    self.des.text = model.des;
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
