//
//  SelectAddressTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectAddressTableViewCell.h"
#import "JGModel.h"
@interface SelectAddressTableViewCell()

@property (nonatomic,strong)UILabel *organizationName;

@property (nonatomic,strong)UILabel *organizationAddress;

@end
@implementation SelectAddressTableViewCell

- (UILabel *)organizationName{
    if (!_organizationName) {
        _organizationName = [[UILabel alloc]init];
        _organizationName.textColor = DefaultBlackLightTextClor;
        _organizationName.font =FontNameAndSize(16);
        _organizationName.textAlignment = NSTextAlignmentLeft;
    }
    return _organizationName;
}

- (UILabel *)organizationAddress{
    if (!_organizationAddress) {
        _organizationAddress = [[UILabel alloc]init];
        _organizationAddress.textColor = DefaultGrayLightTextClor;
        _organizationAddress.font =FontNameAndSize(14);
        _organizationAddress.textAlignment = NSTextAlignmentLeft;
    }
    return _organizationAddress;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.organizationName];
        [self.contentView addSubview:self.organizationAddress];
        [self.organizationName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(15.5);
        }];
        [self.organizationAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.organizationName.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(15.5);
            make.bottom.mas_equalTo(-10);
        }];
        
        //        test
    
    
    }
    return self;
    
}

- (void)refreshWithModel:(JGModel *)model{
    self.organizationName.text = model.name;
    self.organizationAddress.text = @"地址：上海市张杨路560号中隆恒瑞大厦6楼西区";
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
