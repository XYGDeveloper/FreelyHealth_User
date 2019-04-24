//
//  OrderListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "OrderListModel.h"
@interface OrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *serviceName;

@property (weak, nonatomic) IBOutlet UILabel *states;

@property (weak, nonatomic) IBOutlet UILabel *setviceObj;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@property (weak, nonatomic) IBOutlet UIButton *scanStep;

@end

@implementation OrderListTableViewCell


- (void)refreshWithModel:(OrderListModel *)model
{
    self.serviceName.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.1f",model.sumprice];
    if (model.status == 1) {
        self.states.text = @"待支付";
        self.states.textColor = [UIColor redColor];
        [self.scanStep setTitle:@"订单支付" forState:UIControlStateNormal];

    }else if (model.status == 2){
        self.states.text = @"进行中";
        self.states.textColor = AppStyleColor;
        [self.scanStep setTitle:@"查看进度" forState:UIControlStateNormal];

    }else if (model.status == 3){
        self.states.text = @"已完成";
        self.states.textColor = DefaultGrayTextClor;
        [self.scanStep setTitle:@"再次预定" forState:UIControlStateNormal];
    }else{
        self.states.text = @"已取消";
        self.states.textColor = DefaultGrayTextClor;
        [self.scanStep setTitle:@"重新预定" forState:UIControlStateNormal];
    }

    if (!model.patientname && !model.patientphone) {
        NSRange range = {3,4};
        NSString *phone = [[User LocalUser].phone stringByReplacingCharactersInRange:range withString:@"****"];
        self.setviceObj.text = [NSString stringWithFormat:@"服务对象：%@(%@)",model.hzname,phone];
    }else{
        NSRange range = {3,4};
        NSString *phone = [model.patientphone stringByReplacingCharactersInRange:range withString:@"****"];
        self.setviceObj.text = [NSString stringWithFormat:@"服务对象：%@(%@)",model.patientname,phone];
    }

}


- (IBAction)ScanStep:(id)sender {
    
    if (self.step) {
        self.step();
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scanStep.layer.cornerRadius = 3;
    
    self.scanStep.layer.masksToBounds = YES;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
