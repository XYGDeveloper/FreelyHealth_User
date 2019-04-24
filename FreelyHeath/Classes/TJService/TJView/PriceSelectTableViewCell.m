//
//  PriceSelectTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/3/16.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PriceSelectTableViewCell.h"
#import "PriceModel.h"

@interface PriceSelectTableViewCell()


@end

@implementation PriceSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat height = 111;
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
            make.height.mas_equalTo((height-40)/3);
        }];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.text = @"选择数量";
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = DefaultBlackLightTextClor;
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.amoutLabel.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo((height-40)/3);
        }];
        self.otherLabel = [[UILabel alloc]init];
        self.otherLabel.text = @"选择数量";
        self.otherLabel.textAlignment = NSTextAlignmentLeft;
        self.otherLabel.textColor = DefaultBlackLightTextClor;
        self.otherLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.otherLabel];
        [self.otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo((height-40)/3);
        }];
        
        self.amoutLabelContent = [PPNumberButton numberButtonWithFrame:CGRectMake(kScreenWidth - 140, 10, 120, (height-40)/3)];
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
            make.height.mas_equalTo((height-40)/3);
        }];
        
        self.otherLabelContent = [[UILabel alloc]init];
        self.otherLabelContent.text = @"+300";
        self.otherLabelContent.textAlignment = NSTextAlignmentRight;
        self.otherLabelContent.textColor = AppStyleColor;
        self.otherLabelContent.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.otherLabelContent];
        [self.otherLabelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.otherLabel.mas_centerY);
            make.right.mas_equalTo(-20);
            make.width.mas_equalTo(kScreenWidth/2);
            make.height.mas_equalTo((height-40)/3);
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
    self.otherLabel.text = @"服务费";
    if (model.count >= 10) {
        self.otherLabelContent.text = @"+0";
    }else{
        self.otherLabelContent.text = @"+300";
    }
}


@end
