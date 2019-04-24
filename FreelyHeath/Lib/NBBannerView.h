//
//  NBBannerView.h
//  页面分离
//
//  Created by xxzx on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBBannerModelProtocol.h"
#import "NBBannerConfig.h"

typedef void(^NBBannerConfigBlock)(NBBannerConfig *config);
typedef void(^NBLoadImageBlock)(UIImageView *imageView, NSURL *url);
typedef void(^NBBannarClickBlock)(NSInteger index);

@interface NBBannerView : UIView
@property(nonatomic, strong) NSArray<id<NBBannerModelProtocol>> *bannerModels;


+ (instancetype)bannerViewWithConfig:(NBBannerConfigBlock)bannarConfigBlock loadImageBlock:(NBLoadImageBlock)loadImgBlock loadBlurEffectBlock:(NBLoadImageBlock)loadBlurEffectBlock;

@property(nonatomic, copy) NBBannarClickBlock bannarClickBlock;

@end
