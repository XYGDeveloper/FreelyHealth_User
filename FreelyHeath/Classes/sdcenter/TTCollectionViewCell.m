//
//  TTCollectionViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/11/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TTCollectionViewCell.h"
#import "TeamListModel.h"
#import "UIView+AnimationProperty.h"
@implementation TTCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Headimage.layer.cornerRadius = 4;
    self.Headimage.layer.masksToBounds  = YES;
    self.hospitalName.textColor = DefaultGrayLightTextClor;
    self.jopName.textColor = DefaultGrayLightTextClor;
    self.leaderName.textColor = AppStyleColor;
    self.backgroundColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:0.6];
}

- (void)refreshwithModel:(TeamListModel *)model
{
    weakify(self);
    [self.Headimage sd_setImageWithURL:[NSURL URLWithString:model.lfacepath]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                strongify(self);
                                self.Headimage.image = image;
                                self.Headimage.alpha = 0;
                                self.Headimage.scale = 1.1f;
                                [UIView animateWithDuration:0.5f animations:^{
                                    self.Headimage.alpha = 1.f;
                                    self.Headimage.scale = 1.f;
                                }];
                            }];
    self.teamName.text = model.name;
    self.hospitalName.text = model.lhname;
    self.jopName.text = [NSString stringWithFormat:@"职称: %@",model.ljob];
    self.leaderName.text = [NSString stringWithFormat:@"学科领头人:   %@",model.lname];
}

@end
