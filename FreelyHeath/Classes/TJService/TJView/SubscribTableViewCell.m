//
//  SubscribTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SubscribTableViewCell.h"
#import "SubModel.h"
@interface SubscribTableViewCell()

@property (nonatomic,strong)UILabel *serviceType;
@property (nonatomic,strong)UILabel *pname;
@property (nonatomic,strong)UILabel *serviceTime;
@property (nonatomic,strong)UIButton *serviceEdit;
@property (nonatomic,strong)UILabel *serviceAddress;
@property (nonatomic,strong)UILabel *serviceDate;
@end

@implementation SubscribTableViewCell

- (UILabel *)serviceType{
    if (!_serviceType) {
        _serviceType = [[UILabel alloc]init];
        _serviceType.textColor = DefaultBlackLightTextClor;
        _serviceType.font =FontNameAndSize(16);
        _serviceType.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceType;
}
- (UILabel *)pname{
    if (!_pname) {
        _pname = [[UILabel alloc]init];
        _pname.textColor = DefaultGrayLightTextClor;
        _pname.font =FontNameAndSize(15);
        _pname.textAlignment = NSTextAlignmentLeft;
    }
    return _pname;
}

- (UILabel *)serviceTime{
    if (!_serviceTime) {
        _serviceTime = [[UILabel alloc]init];
        _serviceTime.textColor = DefaultGrayLightTextClor;
        _serviceTime.font =FontNameAndSize(15);
        _serviceTime.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceTime;
}

- (UILabel *)serviceAddress{
    if (!_serviceAddress) {
        _serviceAddress = [[UILabel alloc]init];
        _serviceAddress.textColor = DefaultGrayLightTextClor;
        _serviceAddress.font =FontNameAndSize(15);
        _serviceAddress.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceAddress;
}

- (UILabel *)serviceDate{
    if (!_serviceDate) {
        _serviceDate = [[UILabel alloc]init];
        _serviceDate.textColor = DefaultGrayLightTextClor;
        _serviceDate.font =FontNameAndSize(15);
        _serviceDate.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceDate;
}

- (UIButton *)serviceEdit
{
    if (!_serviceEdit) {
        _serviceEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_serviceEdit setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    }
    return _serviceEdit;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.serviceType];
        [self.contentView addSubview:self.pname];
        [self.contentView addSubview:self.serviceTime];
        [self.contentView addSubview:self.serviceAddress];
        [self.contentView addSubview:self.serviceDate];
        [self.contentView addSubview:self.serviceEdit];
        [self.serviceEdit addTarget:self action:@selector(editSub) forControlEvents:UIControlEventTouchUpInside];
        [self.serviceType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-50);
            make.height.mas_equalTo(15.5);
        }];
        [self.pname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.serviceType.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(15.5);
        }];
        [self.serviceTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.pname.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(15.5);
        }];
        
        [self.serviceAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.serviceTime.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(15.5);
        }];
        [self.serviceDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.serviceAddress.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(15.5);
            make.bottom.mas_equalTo(-10);
        }];
        [self.serviceEdit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.centerY.mas_equalTo(self.serviceType.mas_centerY);
            make.width.height.mas_equalTo(15);
        }];
    }
    return self;
    
}

- (void)editSub{
    if (self.et) {
        self.et();
    }
}
- (void)refreshWithModel:(SubModel *)model{
    self.serviceType.text = model.taocanname;
    self.serviceTime.text = [NSString stringWithFormat:@"体检时间：%@",model.tjtime];
    self.serviceAddress.text = [NSString stringWithFormat:@"体检地点：%@",model.jgdetail];
    self.serviceDate.text = [NSString stringWithFormat:@"创建时间：%@",model.createtime];
    self.pname.text = [NSString stringWithFormat:@"体检人姓名：%@",model.patientname];
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
