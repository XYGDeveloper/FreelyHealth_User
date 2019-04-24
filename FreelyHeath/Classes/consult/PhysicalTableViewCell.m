//
//  PhysicalTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhysicalTableViewCell.h"
#import "SecondModel.h"
#import "PhyicalModel.h"
#import "TumorTreamentModel.h"
#import "MBProgressHUD+BWMExtension.h"
#import "UIView+AnimationProperty.h"
@interface PhysicalTableViewCell()



@end


@implementation PhysicalTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.bgView = [[UIImageView alloc]init];
        
        [self.contentView addSubview:self.bgView];
        
        self.showLayer = [[UIView alloc]init];
        
        self.showLayer.backgroundColor=[UIColor whiteColor];
        //v.layer.masksToBounds=YES;这行去掉
        self.showLayer.layer.cornerRadius = 8;
        self.showLayer.layer.shadowColor=DefaultGrayTextClor.CGColor;
        self.showLayer.layer.shadowOffset=CGSizeMake(0, 1);
        self.showLayer.layer.shadowOpacity=0.5;
        self.showLayer.layer.shadowRadius= 2;
        
        [self.bgView addSubview:self.showLayer];

        self.topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth- 40, 180)];
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.topImage.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.path = maskPath1.CGPath;
        
        self.topImage.layer.mask = maskLayer1;
        
        [self.bgView addSubview:self.topImage];
        
        self.name = [[UILabel alloc]init];
        
        [self.bgView addSubview:self.name];
        
        self.name.textAlignment  = NSTextAlignmentCenter;
        
        self.name.textColor = DefaultBlackLightTextClor;
        
        self.name.font = Font(16);
        
        self.content = [[UILabel alloc]init];
        
        self.content.numberOfLines = 0;
        
        self.content.textColor = DefaultGrayLightTextClor;
        
        self.content.font  = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        
        [self.bgView addSubview:self.content];
        
        [self layOutview];
        
    }
    
    return self;
    
}

- (void)layOutview{

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        
        make.bottom.mas_equalTo(-10);
        
        make.left.mas_equalTo(20);
        
        make.right.mas_equalTo(-20);
        
    }];
    
    [self.showLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topImage.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.name.mas_bottom);
        make.bottom.mas_equalTo(-20);
        
    }];
    
}

- (void)refreshWithModel1:(PhyicalModel *)model
{

    NSString* imagepath = [model.imagepath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    weakify(self);
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imagepath]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           strongify(self);
                           self.topImage.image = image;
                           self.topImage.alpha = 0;
                           self.topImage.scale = 1.1f;
                           [UIView animateWithDuration:0.5f animations:^{
                               self.topImage.alpha = 1.f;
                               self.topImage.scale = 1.f;
                           }];
                       }];
   
    self.name.text = model.name;

    //设置行间距
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    // 行间距设置为30
    [paragraphStyle  setLineSpacing:10];

    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:model.des];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.des length])];

    // 设置Label要显示的text
    [self.content  setAttributedText:setString];
    
}
- (void)refreshWithModel:(serverModel *)model
{
    NSString* imagepath = [model.imagepath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    weakify(self);
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imagepath]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                strongify(self);
                                self.topImage.image = image;
                                self.topImage.alpha = 0;
                                self.topImage.scale = 1.1f;
                                [UIView animateWithDuration:0.5f animations:^{
                                    self.topImage.alpha = 1.f;
                                    self.topImage.scale = 1.f;
                                }];
                            }];
    
    self.name.text = model.name;
    
    //设置行间距
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:10];
    
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:model.des];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.des length])];
    
    // 设置Label要显示的text
    [self.content  setAttributedText:setString];
    
}

- (void)refreshWithTurModel:(TumorTreamentModel *)model
{
    weakify(self);
    NSString* imagepath = [model.imagepath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:imagepath]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                strongify(self);
                                self.topImage.image = image;
                                self.topImage.alpha = 0;
                                self.topImage.scale = 1.1f;
                                [UIView animateWithDuration:0.5f animations:^{
                                    self.topImage.alpha = 1.f;
                                    self.topImage.scale = 1.f;
                                }];
                            }];
    
    self.name.text = model.name;
    self.content.text = model.des;
    //设置行间距
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:10];

    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:model.des];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [model.des length])];
    // 设置Label要显示的text
    [self.content  setAttributedText:setString];
    
}

- (void)refreshWithTurTJBG{
    
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
