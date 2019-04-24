//
//  SDCollectionViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class sdModel;
@class PublicServiceModel;
@interface SDCollectionViewCell : UICollectionViewCell


@property (nonatomic,strong)UIImageView *bgImage;

@property (nonatomic,strong)UILabel *middleLabel;

@property (nonatomic,strong)UILabel *bottomLabel;

@property (nonatomic,strong)UIImageView *bottomimage;

- (void)refreshWithModel:(sdModel *)model;

//配置更多公共服务

- (void)refreshWithMorePublicModel:(PublicServiceModel *)model;


@end
