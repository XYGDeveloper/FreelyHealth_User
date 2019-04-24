//
//  HZOrderdetailTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/5/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HZOrderdetailTableViewCell.h"
#import "TJOrderDetailModel.h"

@interface HZOrderdetailTableViewCell()
@property (nonatomic,strong)UILabel *orderNo;
@property (nonatomic,strong)UILabel *orderSum;
@property (nonatomic,strong)UILabel *orderConpon;
@property (nonatomic,strong)UILabel *orderConponCon;
@property (nonatomic,strong)UILabel *orderRealPay;
@property (nonatomic,strong)UILabel *orderRealPayCon;
@property (nonatomic,strong)UILabel *count;
@property (nonatomic,strong)UILabel *orderPrice;
@property (nonatomic,strong)UILabel *countCon;
@property (nonatomic,strong)UILabel *orderPriceCon;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *telephone;
@property (nonatomic,strong)UILabel *status;
@property (nonatomic,strong)UILabel *orderNocon;
@property (nonatomic,strong)UILabel *orderSumcon;
@property (nonatomic,strong)UILabel *namecon;
@property (nonatomic,strong)UILabel *telephonecon;
@property (nonatomic,strong)UILabel *statusCon;
@end

@implementation HZOrderdetailTableViewCell

- (UILabel *)orderNo{
    if (!_orderNo) {
        _orderNo = [[UILabel alloc]init];
        _orderNo.text = @"订单编号:";
        _orderNo.textColor = DefaultBlackLightTextClor;
        _orderNo.font =FontNameAndSize(14);
        _orderNo.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNo;
}

- (UILabel *)orderSum{
    if (!_orderSum) {
        _orderSum = [[UILabel alloc]init];
        _orderSum.text = @"商品总额:";
        _orderSum.textColor = DefaultBlackLightTextClor;
        _orderSum.font =FontNameAndSize(14);
        _orderSum.textAlignment = NSTextAlignmentLeft;
    }
    return _orderSum;
}

- (UILabel *)orderConpon{
    if (!_orderConpon) {
        _orderConpon = [[UILabel alloc]init];
        _orderConpon.text = @"订单优惠:";
        _orderConpon.textColor = DefaultBlackLightTextClor;
        _orderConpon.font =FontNameAndSize(14);
        _orderConpon.textAlignment = NSTextAlignmentLeft;
    }
    return _orderConpon;
}
- (UILabel *)orderRealPay{
    if (!_orderRealPay) {
        _orderRealPay = [[UILabel alloc]init];
        _orderRealPay.text = @"订单总额:";
        _orderRealPay.textColor = DefaultBlackLightTextClor;
        _orderRealPay.font =FontNameAndSize(14);
        _orderRealPay.textAlignment = NSTextAlignmentLeft;
    }
    return _orderRealPay;
}
- (UILabel *)count{
    if (!_count) {
        _count = [[UILabel alloc]init];
        _count.text = @"服务对象:";
        _count.textColor = DefaultBlackLightTextClor;
        _count.font =FontNameAndSize(14);
        _count.textAlignment = NSTextAlignmentLeft;
    }
    return _count;
}

- (UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc]init];
        _name.text = @"联系人:";
        _name.textColor = DefaultBlackLightTextClor;
        _name.font =FontNameAndSize(14);
        _name.textAlignment = NSTextAlignmentLeft;
    }
    return _name;
}

- (UILabel *)telephone{
    if (!_telephone) {
        _telephone = [[UILabel alloc]init];
        _telephone.text = @"联系电话:";
        _telephone.textColor = DefaultBlackLightTextClor;
        _telephone.font =FontNameAndSize(14);
        _telephone.textAlignment = NSTextAlignmentLeft;
    }
    return _telephone;
}

- (UILabel *)status{
    if (!_status) {
        _status = [[UILabel alloc]init];
        _status.text = @"订单状态:";
        _status.textColor = DefaultBlackLightTextClor;
        _status.font =FontNameAndSize(14);
        _status.textAlignment = NSTextAlignmentLeft;
    }
    return _status;
}

- (UILabel *)orderNocon{
    if (!_orderNocon) {
        _orderNocon = [[UILabel alloc]init];
        _orderNocon.textColor = DefaultGrayLightTextClor;
        _orderNocon.font =FontNameAndSize(14);
        _orderNocon.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNocon;
}

- (UILabel *)orderSumcon{
    if (!_orderSumcon) {
        _orderSumcon = [[UILabel alloc]init];
        _orderSumcon.textColor = AppStyleColor;
        _orderSumcon.font =FontNameAndSize(14);
        _orderSumcon.textAlignment = NSTextAlignmentLeft;
    }
    return _orderSumcon;
}
- (UILabel *)orderConponCon{
    if (!_orderConponCon) {
        _orderConponCon = [[UILabel alloc]init];
        _orderConponCon.textColor = AppStyleColor;
        _orderConponCon.font =FontNameAndSize(14);
        _orderConponCon.textAlignment = NSTextAlignmentLeft;
    }
    return _orderConponCon;
}

- (UILabel *)orderRealPayCon{
    if (!_orderRealPayCon) {
        _orderRealPayCon = [[UILabel alloc]init];
        _orderRealPayCon.textColor = AppStyleColor;
        _orderRealPayCon.font =FontNameAndSize(14);
        _orderRealPayCon.textAlignment = NSTextAlignmentLeft;
    }
    return _orderRealPayCon;
}

- (UILabel *)countCon{
    if (!_countCon) {
        _countCon = [[UILabel alloc]init];
        _countCon.textColor = AppStyleColor;
        _countCon.font =FontNameAndSize(14);
        _countCon.textAlignment = NSTextAlignmentLeft;
    }
    return _countCon;
}

- (UILabel *)namecon{
    if (!_namecon) {
        _namecon = [[UILabel alloc]init];
        _namecon.textColor = DefaultGrayLightTextClor;
        _namecon.font =FontNameAndSize(14);
        _namecon.textAlignment = NSTextAlignmentLeft;
    }
    return _namecon;
}

- (UILabel *)telephonecon{
    if (!_telephonecon) {
        _telephonecon = [[UILabel alloc]init];
        _telephonecon.textColor = DefaultGrayLightTextClor;
        _telephonecon.font =FontNameAndSize(14);
        _telephonecon.textAlignment = NSTextAlignmentLeft;
    }
    return _telephonecon;
}
- (UILabel *)statusCon{
    if (!_statusCon) {
        _statusCon = [[UILabel alloc]init];
        _statusCon.textColor = DefaultGrayLightTextClor;
        _statusCon.font =FontNameAndSize(14);
        _statusCon.textAlignment = NSTextAlignmentLeft;
    }
    return _statusCon;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.orderNo];
        [self.contentView addSubview:self.orderSum];
        [self.contentView addSubview:self.orderNocon];
        [self.contentView addSubview:self.orderSumcon];
        [self.contentView addSubview:self.status];
        [self.contentView addSubview:self.statusCon];
        [self.contentView addSubview:self.count];
        [self.contentView addSubview:self.countCon];
        [self.contentView addSubview:self.orderConpon];
        [self.contentView addSubview:self.orderConponCon];
        [self.contentView addSubview:self.orderRealPay];
        [self.contentView addSubview:self.orderRealPayCon];
        [self.orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(15.5);
        }];  //10 +15.5
        [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.orderNo.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(15.5);
        }];//10 +15.5
        [self.orderSum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.count.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(15.5);
        }];
        [self.orderConpon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.orderSum.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(15.5);
        }];
        [self.orderRealPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.orderConpon.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(15.5);
        }];
        //10 +15.5
        [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.orderRealPay.mas_bottom).mas_equalTo(10);
            make.width.mas_equalTo(90);
            make.height.mas_equalTo(15.5);
            make.bottom.mas_equalTo(-10);
        }];
        
        [self.orderNocon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderNo.mas_right);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15.5);
        }];
        
        [self.countCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.count.mas_right);
            make.top.mas_equalTo(self.orderNo.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15.5);
        }];
    
        [self.orderConponCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderConpon.mas_right);
            make.top.mas_equalTo(self.orderSumcon.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15.5);
        }];
        [self.orderSumcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderSum.mas_right);
            make.top.mas_equalTo(self.countCon.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15.5);
        }];
        [self.orderRealPayCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.orderRealPay.mas_right);
            make.top.mas_equalTo(self.orderConponCon.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15.5);
        }];
        [self.statusCon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.status.mas_right);
            make.top.mas_equalTo(self.orderRealPayCon.mas_bottom).mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(15.5);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

- (void)refreshWithModel:(TJOrderDetailModel *)model
{
    self.orderNocon.text = model.orderno;
    self.orderSumcon.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.countCon.text = [User LocalUser].name;
    if (!model.couponprice) {
        self.orderConponCon.text = [NSString stringWithFormat:@"-￥%@",@"0"];
    }else{
        self.orderConponCon.text = [NSString stringWithFormat:@"-￥%@",model.couponprice];
    }
    self.orderRealPayCon.text = [NSString stringWithFormat:@"￥%.1f",model.sumprice];
    if (!model.patientphone) {
        self.telephonecon.text = [User LocalUser].phone;
    }else{
        self.telephonecon.text = model.patientphone;
    }
    if (!model.patientphone) {
        self.namecon.text = model.hzname;
    }else{
        self.namecon.text = model.patientname;
    }
    if ([model.status isEqualToString:@"1"]) {
        self.statusCon.text = @"待支付";
    }else if ([model.status isEqualToString:@"2"]){
        self.statusCon.text = @"已支付";
    }else if ([model.status isEqualToString:@"4"]){
        self.statusCon.text = @"已取消";
    }
}


@end
