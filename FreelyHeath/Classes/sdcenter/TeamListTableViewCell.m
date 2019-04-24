//
//  TeamListTableViewCell.m
//  MedicineClient
//
//  Created by L on 2017/8/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamListTableViewCell.h"
#import "TeamdetailModel.h"
#import "UIView+AnimationProperty.h"
#import "AppionmentListDetailModel.h"

@interface TeamListTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *jopLabel;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;


@end

@implementation TeamListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImg.layer.cornerRadius = 4;

    self.headImg.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)refreshWithModel:(members *)model
{
    weakify(self);
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.facepath]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           strongify(self);
                           self.headImg.image = image;
                           self.headImg.alpha = 0;
                           self.headImg.scale = 1.1f;
                           [UIView animateWithDuration:0.5f animations:^{
                               self.headImg.alpha = 1.f;
                               self.headImg.scale = 1.f;
                           }];
                       }];
    self.nameLabel.text = model.name;
    
    if (!model.hname) {
        
        self.jopLabel.text = [NSString stringWithFormat:@"%@",model.job];

    }else{
        
        self.jopLabel.text = [NSString stringWithFormat:@"%@ %@",model.hname,model.job];
        
    }
    self.introLabel.text = model.introduction;
}

- (void)refreshWithAppionmentModel:(AppionmentDetailModel *)model{
    weakify(self);
    if (!model.dfacepath || model.dfacepath.length <= 0) {
        self.headImg.image = [UIImage imageNamed:@"Logo"];
    }else{
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.dfacepath]
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   strongify(self);
                                   self.headImg.image = image;
                                   self.headImg.alpha = 0;
                                   self.headImg.scale = 1.1f;
                                   [UIView animateWithDuration:0.5f animations:^{
                                       self.headImg.alpha = 1.f;
                                       self.headImg.scale = 1.f;
                                   }];
                               }];
    }
    
    self.nameLabel.text = model.dname;
    if (!model.hname) {
        self.jopLabel.text = model.dname;
        self.nameLabel.text = @"";
        self.jopLabel.textColor = DefaultBlackLightTextClor;
    }else{
        self.jopLabel.text = [NSString stringWithFormat:@"%@ %@",model.hname,model.dpost];
    }
    self.introLabel.text = model.dintroduction;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
