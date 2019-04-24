//
//  NBBannerCell.h
//  页面分离
//
//  Created by xxzx on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBBannerModelProtocol.h"
@class NBBannerConfig;
@interface NBBannerCell : UICollectionViewCell
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) NBBannerConfig *config;
@property(nonatomic, strong) id<NBBannerModelProtocol> bannerModel;
@end
