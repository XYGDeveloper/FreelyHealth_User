//
//  TJMenuCollectionViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJMenuCollectionViewCell.h"
#import "NewModel.h"
#import "SecondModel.h"
#import "UIView+AnimationProperty.h"
@interface TJMenuCollectionViewCell()

@property (nonatomic,strong)UIImageView *headimage;
@property (nonatomic,strong)UILabel *nameLabel;

@end

@implementation TJMenuCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.headimage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.headimage];
        [self.headimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.contentView.width/3);
            make.height.mas_equalTo(self.contentView.width/3);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY).mas_equalTo(-10);
        }];
        self.nameLabel = [[UILabel alloc]init];
        self.nameLabel.textColor = DefaultGrayTextClor;
        self.nameLabel.font  = FontNameAndSize(14);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.top.mas_equalTo(self.headimage.mas_bottom).mas_equalTo(5);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
    }
    return self;
    
}

- (void)refreshWithModel:(ServiceModel *)model{
    weakify(self);
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:model.imagepath]
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            strongify(self);
                            self.headimage.image = image;
                            self.headimage.alpha = 0;
                            self.headimage.scale = 1.1f;
                            [UIView animateWithDuration:0.5f animations:^{
                                self.headimage.alpha = 1.f;
                                self.headimage.scale = 1.f;
                            }];
                        }];
    self.nameLabel.text  = model.name;
}

- (void)refreshWithserverModel:(serverModel *)model{
    weakify(self);
    [self.headimage sd_setImageWithURL:[NSURL URLWithString:model.imagepath]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 strongify(self);
                                 self.headimage.image = image;
                                 self.headimage.alpha = 0;
                                 self.headimage.scale = 1.1f;
                                 [UIView animateWithDuration:0.5f animations:^{
                                     self.headimage.alpha = 1.f;
                                     self.headimage.scale = 1.f;
                                 }];
                             }];
    self.nameLabel.text  = model.name;
    
}

@end
