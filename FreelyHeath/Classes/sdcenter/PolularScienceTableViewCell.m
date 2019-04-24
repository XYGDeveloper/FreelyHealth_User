//
//  PolularScienceTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PolularScienceTableViewCell.h"
#import "UIView+AnimationProperty.h"
#import "TumorZoneListModel.h"
@interface PolularScienceTableViewCell ()

@property (nonatomic)UIImageView *headImage;

@property (nonatomic)UILabel *titlelLabel;

@property (nonatomic)UILabel *content;


@end

@implementation PolularScienceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headImage = [UIImageView new];
        
        self.headImage.image = [UIImage imageNamed:@"machine"];
        
        self.headImage.layer.cornerRadius = 4;
        
        self.headImage.layer.masksToBounds = YES;
    
        [self.contentView addSubview:self.headImage];
        
        self.titlelLabel = [UILabel new];
        
        self.titlelLabel.textAlignment = NSTextAlignmentLeft;
        
        self.titlelLabel.textColor = DefaultBlackLightTextClor;
        
        self.titlelLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        
        [self.contentView addSubview:self.titlelLabel];
        
        self.content = [UILabel new];
        
        self.content.textAlignment = NSTextAlignmentLeft;
        
        self.content.numberOfLines = 0;
        
        self.content.textColor = DefaultGrayTextClor;
        
        self.content.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        [self.contentView addSubview:self.content];
        
        self.sep = [[UILabel alloc]init];
        
        self.sep.backgroundColor = DividerDarkGrayColor;
        
        [self.contentView addSubview:self.sep];
        
    }
    
    return self;
    
}


- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(16);
        
        make.bottom.mas_equalTo(-16);
        
        make.top.mas_equalTo(16);
        
        make.width.mas_equalTo(110);
        
    }];
    
    [self.titlelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);

        make.top.mas_equalTo(self.headImage.mas_top).mas_equalTo(5);
        
        make.right.mas_equalTo(-16);
        
        make.height.mas_equalTo(20);
        
    }];

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(10);
        
        make.top.mas_equalTo(self.titlelLabel.mas_bottom).mas_equalTo(0);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(self.headImage.mas_bottom);
    }];

    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
    }];
    
}


- (void)refreshWithModel:(infomationModel *)model
{

    weakify(self);
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.imagepath]
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
    
    self.titlelLabel.text  =model.title;
    
    self.content.text = model.content;
    
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
