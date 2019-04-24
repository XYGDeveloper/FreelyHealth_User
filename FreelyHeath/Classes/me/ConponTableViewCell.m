//
//  ConponTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/5/4.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ConponTableViewCell.h"
#import "MyconponListModel.h"

@interface ConponTableViewCell()
@property (nonatomic,strong)UIImageView *topImage;
@property (nonatomic,strong)UIImageView *bottomImage;
@property (nonatomic,strong)UILabel *dealtimeLine;
@property (nonatomic,strong)UILabel *isSelect;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *nameConpon;
@property (nonatomic,strong)UILabel *conditionLabel;

@end

@implementation ConponTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = DefaultBackgroundColor;
        self.topImage = [UIImageView new];
        [self.contentView addSubview:self.topImage];
        self.bottomImage = [UIImageView new];
        [self.contentView addSubview:self.bottomImage];
        [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7.5);
            make.right.mas_equalTo(-7.5);
            make.top.mas_equalTo(6);
            make.height.mas_equalTo(110.5);
        }];
        [self.bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(7.5);
            make.right.mas_equalTo(-7.5);
            make.top.mas_equalTo(self.topImage.mas_bottom);
            make.bottom.mas_equalTo(-6);
        }];
        self.dealtimeLine = [[UILabel alloc]init];
        self.dealtimeLine.font = FontNameAndSize(12.5);
        self.dealtimeLine.textAlignment = NSTextAlignmentLeft;
        self.dealtimeLine.textColor = DefaultGrayTextClor;
        [self.bottomImage addSubview:self.dealtimeLine];
        [self.dealtimeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-60);
            make.centerY.mas_equalTo(self.bottomImage.mas_centerY);
            make.height.mas_equalTo(15);
        }];
        self.isSelect = [[UILabel alloc]init];
        self.isSelect.font = FontNameAndSize(12.5);
        self.isSelect.textAlignment = NSTextAlignmentRight;
        self.isSelect.textColor = DefaultGrayTextClor;
        [self.bottomImage addSubview:self.isSelect];
        [self.isSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.dealtimeLine.mas_right);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.bottomImage.mas_centerY);
            make.height.mas_equalTo(30);
        }];
        //
        self.priceLabel = [[UILabel alloc]init];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.topImage addSubview:self.priceLabel];
        //
        self.priceLabel.preferredMaxLayoutWidth = 100;
        [self.priceLabel
         setContentCompressionResistancePriority:UILayoutPriorityRequired
         forAxis:UILayoutConstraintAxisHorizontal
         ];
        //
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.centerY.mas_equalTo(self.topImage.mas_centerY);
        }];
       //
        self.nameConpon = [[UILabel alloc]init];
        self.nameConpon.font = FontNameAndSize(19);
        self.nameConpon.textAlignment = NSTextAlignmentLeft;
        self.nameConpon.textColor = [UIColor whiteColor];
        [self.topImage addSubview:self.nameConpon];
        [self.nameConpon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceLabel.mas_right).mas_equalTo(15);
            make.width.mas_equalTo(kScreenWidth/2);
            make.centerY.mas_equalTo(self.topImage.mas_centerY).mas_equalTo(-12);
            make.height.mas_equalTo(30);
        }];
        //
        self.conditionLabel = [[UILabel alloc]init];
        self.conditionLabel.font = FontNameAndSize(13.1);
        self.conditionLabel.textAlignment = NSTextAlignmentLeft;
        self.conditionLabel.textColor = [UIColor whiteColor];
        [self.topImage addSubview:self.conditionLabel];
        [self.conditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.priceLabel.mas_right).mas_equalTo(15);
            make.width.mas_equalTo(kScreenWidth/2);
            make.centerY.mas_equalTo(self.topImage.mas_centerY).mas_equalTo(12);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

- (void)refreshWithMyconponModel:(MyconponListModel *)model{
    if ([model.type isEqualToString:@"1"]) {
        self.topImage.image = [UIImage imageNamed:@"topImage"];
        self.bottomImage.image = [UIImage imageNamed:@"bottomimage"];
        self.priceLabel.textColor = [UIColor whiteColor];
        self.conditionLabel.textColor = [UIColor whiteColor];
        self.nameConpon.textColor = [UIColor whiteColor];
        self.conditionLabel.text = [NSString stringWithFormat:@"满%d减", [model.quota intValue]];
        NSString *price = [NSString stringWithFormat:@"￥%d",[model.denominat intValue]];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:price];
        // 改变文字大小
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:0.5] range:NSMakeRange(0, 1)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36 weight:0.5] range:NSMakeRange(1, price.length-1)];
        // 改变文字颜色
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, price.length)];
        self.priceLabel.attributedText = attributedText;
    }else {
        self.topImage.image = [UIImage imageNamed:@"topimage_1"];
        self.bottomImage.image = [UIImage imageNamed:@"bottomimage_1"];
        self.priceLabel.textColor = DefaultBlueTextClor;
        self.conditionLabel.textColor = DefaultBlueTextClor;
        self.nameConpon.textColor = DefaultBlueTextClor;
        self.conditionLabel.text = [NSString stringWithFormat:@"满%d减", [model.quota intValue]];
        NSString *price = [NSString stringWithFormat:@"￥%d",[model.denominat intValue]];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:price];
        // 改变文字大小
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:0.5] range:NSMakeRange(0, 1)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36 weight:0.5] range:NSMakeRange(1, price.length-1)];
        // 改变文字颜色
        [attributedText addAttribute:NSForegroundColorAttributeName value:DefaultBlueTextClor range:NSMakeRange(0, price.length)];
        self.priceLabel.attributedText = attributedText;
    }
    self.nameConpon.text = model.name;
    self.dealtimeLine.text =[self dataHandleToolWithStartTime:model.starttime endTime:model.endtime];
//    if ([model.status isEqualToString:@"0"]) {
//        self.isSelect.text = @"未选";
//    }else{
//        self.isSelect.text = @"已选";
//    }
//    self.isSelect.text = model.status;
}

- (void)refreshWithMyOrderconponModel:(MyconponListModel *)model{
    if ([model.type isEqualToString:@"1"]) {
        self.topImage.image = [UIImage imageNamed:@"topImage"];
        self.bottomImage.image = [UIImage imageNamed:@"bottomimage"];
        self.priceLabel.textColor = [UIColor whiteColor];
        self.conditionLabel.textColor = [UIColor whiteColor];
        self.nameConpon.textColor = [UIColor whiteColor];
        self.conditionLabel.text = [NSString stringWithFormat:@"满%d减", [model.quota intValue]];
        NSString *price = [NSString stringWithFormat:@"￥%d",[model.denominat intValue]];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:price];
        // 改变文字大小
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:0.5] range:NSMakeRange(0, 1)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36 weight:0.5] range:NSMakeRange(1, price.length-1)];
        // 改变文字颜色
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, price.length)];
        self.priceLabel.attributedText = attributedText;
    }else {
        self.topImage.image = [UIImage imageNamed:@"topimage_1"];
        self.bottomImage.image = [UIImage imageNamed:@"bottomimage_1"];
        self.priceLabel.textColor = DefaultBlueTextClor;
        self.conditionLabel.textColor = DefaultBlueTextClor;
        self.nameConpon.textColor = DefaultBlueTextClor;
        self.conditionLabel.text = [NSString stringWithFormat:@"满%d减", [model.quota intValue]];
        NSString *price = [NSString stringWithFormat:@"￥%d",[model.denominat intValue]];
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:price];
        // 改变文字大小
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:0.5] range:NSMakeRange(0, 1)];
        [attributedText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36 weight:0.5] range:NSMakeRange(1, price.length-1)];
        // 改变文字颜色
        [attributedText addAttribute:NSForegroundColorAttributeName value:DefaultBlueTextClor range:NSMakeRange(0, price.length)];
        self.priceLabel.attributedText = attributedText;
    }
    self.nameConpon.text = model.name;
    self.dealtimeLine.text =[self dataHandleToolWithStartTime:model.starttime endTime:model.endtime];
    if ([model.status isEqualToString:@"0"]) {
        self.isSelect.text = @"未选";
    }else{
        self.isSelect.text = @"已选";
    }
}
-(NSString *)dataHandleToolWithStartTime:(NSString *)startTime
                                 endTime:(NSString *)endTime{
    NSArray *start = [startTime componentsSeparatedByString:@" "];
    NSString *startString = [start firstObject];
    NSArray *end = [endTime componentsSeparatedByString:@" "];
    NSString *endString = [end firstObject];
    return [NSString stringWithFormat:@"使用期限：%@ ~ %@",startString,endString];
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
