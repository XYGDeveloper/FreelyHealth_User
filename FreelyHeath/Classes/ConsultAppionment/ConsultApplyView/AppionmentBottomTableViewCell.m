//
//  AppionmentBottomTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/24.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentBottomTableViewCell.h"
#import "CommitApplyModel.h"
@interface AppionmentBottomTableViewCell()
@property (nonatomic,strong)UILabel *detailDes;
@end

@implementation AppionmentBottomTableViewCell

- (UILabel *)detailDes{
    if (!_detailDes) {
        _detailDes = [[UILabel alloc]init];
        _detailDes.backgroundColor = [UIColor whiteColor];
        _detailDes.textColor = DefaultBlackLightTextClor;
        _detailDes.font = FontNameAndSize(14);
        _detailDes.textAlignment = NSTextAlignmentLeft;
        _detailDes.numberOfLines = 0;
    }
    return _detailDes;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.detailDes];
        [self layOut];
    }
    return self;
}
- (void)layOut{
    [self.detailDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(20);
        make.right.bottom.mas_equalTo(-20);
    }];
}

- (void)refeshWIthModel:(CommitApplyModel *)model{
    self.detailDes.text = model.detailkDes;
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
