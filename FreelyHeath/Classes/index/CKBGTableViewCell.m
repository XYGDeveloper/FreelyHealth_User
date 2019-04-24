//
//  CKBGTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/3/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CKBGTableViewCell.h"

@interface CKBGTableViewCell()
@property (nonatomic,strong)UIView *layserview;

@end

@implementation CKBGTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.layserview = [[UIView alloc]init];
        self.layserview.backgroundColor=[UIColor whiteColor];
        //v.layer.masksToBounds=YES;这行去掉
        self.layserview.layer.cornerRadius = 8;
        self.layserview.layer.shadowColor=DefaultGrayTextClor.CGColor;
        self.layserview.layer.shadowOffset=CGSizeMake(0, 1);
        self.layserview.layer.shadowOpacity=0.3;
        self.layserview.layer.shadowRadius= 2;
        [self.bgView addSubview:self.layserview];
        [self.contentView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(240);
        }];
        [self.layserview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        self.img = [[UIImageView alloc]init];
        [self.bgView addSubview:self.img];
        CAShapeLayer *styleLayer = [CAShapeLayer layer];
        UIBezierPath *shadowPath =[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth - 40, 190) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)  cornerRadii:CGSizeMake(8.0, 8.0)];
        styleLayer.path = shadowPath.CGPath;
        self.img.layer.mask = styleLayer;
        self.img.backgroundColor = [UIColor blueColor];
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-50);
        }];
        self.titleLabel = [[UILabel alloc]init];
        [self.bgView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textColor = DefaultBlackLightTextClor;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self.img.mas_bottom);
            make.height.mas_equalTo(50);
        }];
        
    }
    return self;
}

@end
