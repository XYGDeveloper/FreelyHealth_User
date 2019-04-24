//
//  AppionmentPriceTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentPriceTableViewCell.h"
#import "AppionmentListDetailModel.h"
@interface AppionmentPriceTableViewCell()
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIButton *payButton;

@end

@implementation AppionmentPriceTableViewCell

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc]init];
        _priceLabel.textColor = AppStyleColor;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = FontNameAndSize(15);
    }
    return _priceLabel;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.borderColor = RGB(236, 236, 236).CGColor;
        [_cancelButton setTitle:@"取消会诊" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGB(206, 206, 206) forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.backgroundColor = AppStyleColor;
        _payButton.layer.cornerRadius = 5;
        _payButton.layer.masksToBounds = YES;
        [_payButton setTitle:@"支  付" forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _payButton;
}

- (void)layOutSubview{
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth - 45)/2);
    }];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo((kScreenWidth - 45)/2);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.cancelButton];
        [self.contentView addSubview:self.payButton];
        [self layOutSubview];
        [self.cancelButton addTarget:self action:@selector(toCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.payButton addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)toCancel{
    if (self.cancel) {
        self.cancel();
    }
}

- (void)toPay{
    if (self.pay) {
        self.pay();
    }
}

- (void)refreshWithAppionmentDetailModel:(AppionmentListDetailModel *)model{

    self.priceLabel.text = [NSString stringWithFormat:@"价格: ￥%@",model.huizhenprice];
    
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
