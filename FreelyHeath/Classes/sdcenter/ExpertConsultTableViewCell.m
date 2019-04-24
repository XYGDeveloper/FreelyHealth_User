//
//  ExpertConsultTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ExpertConsultTableViewCell.h"
#import "TeamdetailModel.h"
#import "UIView+AnimationProperty.h"
@interface ExpertConsultTableViewCell ()

@property (nonatomic,strong)UIImageView *headImage;

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *makeAppointmentLabel;

@property (nonatomic,strong)UILabel *OnlineDoctorLabel;

@property (nonatomic,strong)UILabel *jopLabel;

@property (nonatomic,strong)UILabel *introduceLabel;


@end


@implementation ExpertConsultTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headImage = [UIImageView new];
        
        self.headImage.layer.cornerRadius = 55/2;
        
        self.headImage.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.headImage];
        
        self.name = [UILabel new];
        
        self.name.textAlignment = NSTextAlignmentLeft;
        
        self.name.textColor = DefaultBlackLightTextClor;
        
        self.name.font = Font(16);
        
        
        [self.contentView addSubview:self.name];
        
//        self.makeAppointmentLabel = [[UILabel alloc]init];
//        
//        self.makeAppointmentLabel.layer.cornerRadius = 3;
//        
//        self.makeAppointmentLabel.layer.borderWidth = 1.0;
//        
//        self.makeAppointmentLabel.layer.borderColor = AppStyleColor.CGColor;
//        
//        self.makeAppointmentLabel.textAlignment = NSTextAlignmentCenter;
//        
//        self.makeAppointmentLabel.textColor = AppStyleColor;
//        
//        self.makeAppointmentLabel.font = Font(12);
//        
//        self.makeAppointmentLabel.text = @"门诊可预约";
//        
//        [self.contentView addSubview:self.makeAppointmentLabel];
        
//        self.OnlineDoctorLabel = [[UILabel alloc]init];
//        
//        self.OnlineDoctorLabel.layer.cornerRadius = 3;
//        
//        self.OnlineDoctorLabel.layer.borderWidth = 1.0;
//        
//        self.OnlineDoctorLabel.layer.borderColor = AppStyleColor.CGColor;
//        
//        self.OnlineDoctorLabel.textAlignment = NSTextAlignmentCenter;
//        
//        self.OnlineDoctorLabel.textColor = AppStyleColor;
//        
//        self.OnlineDoctorLabel.font = Font(12);
//        
//        self.OnlineDoctorLabel.text = @"在线看病";

        [self.contentView addSubview:self.OnlineDoctorLabel];
        
        self.jopLabel = [[UILabel alloc]init];
        
        self.jopLabel.textAlignment = NSTextAlignmentLeft;
        
        self.jopLabel.textColor = DefaultGrayTextClor;
        
        self.jopLabel.font = Font(14);
        
        [self.contentView addSubview:self.jopLabel];
        
        self.introduceLabel = [[UILabel alloc]init];
        
        self.introduceLabel.textAlignment = NSTextAlignmentLeft;
        
        self.introduceLabel.textColor = DefaultGrayTextClor;
        
        self.introduceLabel.font = Font(12);
        
        
        [self.contentView addSubview:self.introduceLabel];
        
    }
    
    return self;
    
}


- (void)refreshWithModel:(members *)model
{
    weakify(self);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.facepath]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    strongify(self);
                                    self.headImage.image = image;
                                    self.headImage.alpha = 0;
                                    self.headImage.scale = 1.1f;
                                    [UIView animateWithDuration:0.5f animations:^{
                                    self.headImage.alpha = 1.f;
                                    self.headImage.scale = 1.f;
                                    }];
                                }];
    
    self.name.text  =  model.name;
    
    self.jopLabel.text = [NSString stringWithFormat:@"%@  %@",model.job,model.hname];
    
    self.introduceLabel.text = model.introduction;
    
    
}



- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(26);
        
        make.width.height.mas_equalTo(55);
        
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.headImage.mas_top);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(14.5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(65);
    }];
    
    [self.makeAppointmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.name.mas_centerY);
        make.left.mas_equalTo(self.name.mas_right).mas_equalTo(-11.5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    [self.OnlineDoctorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.name.mas_centerY);
        make.left.mas_equalTo(self.makeAppointmentLabel.mas_right).mas_equalTo(11.5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    [self.jopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.name.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(14.5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-26);
    }];
    
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.jopLabel.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(14.5);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(-26);
    }];
    
    
    
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
