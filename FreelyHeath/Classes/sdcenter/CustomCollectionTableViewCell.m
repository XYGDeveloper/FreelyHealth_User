//
//  CustomCollectionTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CustomCollectionTableViewCell.h"
#import "TumorZoneListModel.h"
@interface CustomCollectionTableViewCell ()


@end


@implementation CustomCollectionTableViewCell


- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.machineImage = [UIImageView new];
        
        self.machineImage.layer.cornerRadius = 4;
        
        self.machineImage.layer.masksToBounds = YES;
        
        self.machineImage.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.machineImage];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 0;
//        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.titleLabel setContentMode:UIViewContentModeTop];
        [self.titleLabel sizeToFit];
        self.titleLabel.textColor = DefaultBlackLightTextClor;
        
        self.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:1];
        
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        [self.contentView addSubview:self.titleLabel];

        [self layOutSubview];
        
    }

    return self;
    

}

- (void)layOutSubview{

    
    [self.machineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(185);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.machineImage.mas_bottom).mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
    }];
    
}

@end
