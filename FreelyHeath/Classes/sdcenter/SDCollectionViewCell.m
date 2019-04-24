//
//  SDCollectionViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SDCollectionViewCell.h"
#import "sdModel.h"
#import "PublicServiceModel.h"
@interface SDCollectionViewCell ()

@property (nonatomic,strong)UIView *bgview;


@end


@implementation SDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
       
        self.bgImage = [UIImageView new];
        
        self.bgImage.layer.cornerRadius = 12;
        
        self.bgImage.layer.masksToBounds = YES;
        
        self.bgview = [[UIView alloc]init];
        
        self.layer.cornerRadius = 12;
        
        self.bgview.layer.masksToBounds = YES;
        
        self.bgview.alpha = 0.4;
        
        self.bgview.backgroundColor = [UIColor blackColor];
        
        [self.bgImage addSubview:self.bgview];
        
        
        [self.contentView addSubview:self.bgImage];
        
        [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.bottom.mas_equalTo(0);
        }];
        
        self.middleLabel = [[UILabel alloc]init];
        
        [self.contentView addSubview:self.middleLabel];
        
        [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(100);
            make.width.mas_equalTo((kScreenWidth - 60-20)/2);
            
        }];
        
        self.middleLabel.font = [UIFont systemFontOfSize:20 weight:0.2f];
        
        self.middleLabel.textColor = [UIColor whiteColor];
        
        self.middleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.middleLabel.numberOfLines = 0;
        
        self.bottomimage = [UIImageView new];
        
        self.bottomimage.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.bottomimage];
        
        [self.bottomimage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(24);
        }];
        
        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,(kScreenWidth - 60)/2, 24) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.path = maskPath1.CGPath;
        
        self.bottomimage.layer.mask = maskLayer1;
        
        self.bottomLabel = [[UILabel alloc]init];
        
        self.bottomLabel.text = @"";
        
        self.bottomLabel.font = [UIFont systemFontOfSize:14 weight:0.2f];
        
        self.bottomLabel.textColor = [UIColor whiteColor];
        
        self.bottomLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomimage addSubview:self.bottomLabel];
        
        [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(120);
            make.centerX.mas_equalTo(self.bottomimage.mas_centerX);
            make.centerY.mas_equalTo(self.bottomimage.mas_centerY);
            
        }];
        
    }
    
    return self;
    

}

- (void)refreshWithModel:(sdModel *)model
{
    self.bgImage.image = [UIImage imageNamed:model.url];

    self.middleLabel.text = model.name;
    
    if ([model.isvaliable isEqualToString:@"1"]) {
        
        self.bottomimage.hidden = YES;
        
        self.bottomLabel.hidden = YES;
    }else{
    
        self.bottomimage.hidden = NO;
        
        self.bottomLabel.text = model.valiablename;
    
    }
    
}

- (void)refreshWithMorePublicModel:(PublicServiceModel *)model
{

    [self.bgImage sd_setImageWithURL:[NSURL URLWithString:model.imagepath] placeholderImage:[UIImage imageNamed:@""]];
    
    self.middleLabel.text = model.project;
    
    self.bottomimage.hidden = YES;
        
    self.bottomLabel.hidden = YES;

}



@end
