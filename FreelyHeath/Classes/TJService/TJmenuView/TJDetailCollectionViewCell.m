//
//  TJDetailCollectionViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/1/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJDetailCollectionViewCell.h"
#import "IMGModel.h"
#import "UIView+AnimationProperty.h"
@interface TJDetailCollectionViewCell()

@property (nonatomic,strong)UIImageView *img;

@end

@implementation TJDetailCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect imageViewFrame = CGRectMake(0.f, 0.f,
                                           CGRectGetMaxX(self.contentView.bounds),
                                           CGRectGetMaxY(self.contentView.bounds));
        
        self.img                  = [UIImageView new];
        self.img.contentMode      = UIViewContentModeScaleAspectFill;
        self.img.frame            = imageViewFrame;
        self.img.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.img.clipsToBounds    = YES;
        [self.contentView addSubview:self.img];
        
    }
    return self;
}

-(void)refreshWithModel:(IMGModel *)model{
    
    weakify(self);
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.url]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     strongify(self);
                                     self.img.image = image;
                                     self.img.alpha = 0;
                                     self.img.scale = 1.1f;
                                     [UIView animateWithDuration:0.5f animations:^{
                                         self.img.alpha = 1.f;
                                         self.img.scale = 1.f;
                                     }];
                                 }];
    
}
@end
