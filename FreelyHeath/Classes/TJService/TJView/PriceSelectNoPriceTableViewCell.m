//
//  PriceSelectNoPriceTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/3/20.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PriceSelectNoPriceTableViewCell.h"
#import "PriceModel.h"
@interface PriceSelectNoPriceTableViewCell()

@end

@implementation PriceSelectNoPriceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat height = 80;
        self.amoutLabel = [[UILabel alloc]init];
        self.amoutLabel.text = @"选择数量";
        self.amoutLabel.textAlignment = NSTextAlignmentLeft;
        self.amoutLabel.textColor = DefaultBlackLightTextClor;
        self.amoutLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.amoutLabel];
        [self.amoutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(kScreenWidth - 140);
            make.height.mas_equalTo((height-30)/2);
        }];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = DefaultBlackLightTextClor;
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.amoutLabel.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo((height-30)/2);
        }];
        self.amoutLabelContent = [PPNumberButton numberButtonWithFrame:CGRectMake(kScreenWidth - 140, 10, 120, (height-30)/2)];
        self.amoutLabelContent.shakeAnimation = YES;
        self.amoutLabelContent.minValue = 1;
        self.amoutLabelContent.maxValue = 500;
        self.amoutLabelContent.currentNumber = 1;
        self.amoutLabelContent.increaseImage = [UIImage imageNamed:@"amout_add"];
        self.amoutLabelContent.decreaseImage = [UIImage imageNamed:@"amout_gray"];
        weakify(self);
        self.amoutLabelContent.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            NSLog(@"%ld",num);
            strongify(self);
            if (self.amout) {
                self.amout(num, increaseStatus);
            };
        };
        [self.contentView addSubview:self.amoutLabelContent];
        
        self.nameLabelContent = [[UILabel alloc]init];
        self.nameLabelContent.text = @"￥1000x2";
        self.nameLabelContent.textAlignment = NSTextAlignmentRight;
        self.nameLabelContent.textColor = AppStyleColor;
        self.nameLabelContent.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabelContent];
        [self.nameLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo((height-30)/2);
        }];
        
    }
    return self;
}

- (void)refreshWithModel:(PriceModel *)model{
    self.nameLabel.text = model.name;
    if (!model.count) {
        model.count = 1;
        self.nameLabelContent.text = [NSString stringWithFormat:@"￥%@x%d",model.price,model.count];
    }else{
        self.nameLabelContent.text = [NSString stringWithFormat:@"￥%@x%d",model.price,model.count];
    }
//    self.otherLabel.text = @"服务费";
//    if ([model.fuwufei isEqualToString:@"0"]) {
//        self.otherLabelContent.text = @"+0";
//    }else{
//        self.otherLabelContent.text = @"+300";
//    }
}


@end
