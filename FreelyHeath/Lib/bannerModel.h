//
//  BannerModel.h
//  HZBannerViewDemo
//
//  Created by xxzx on 2018/1/2.
//  Copyright © 2018年 Null. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bannerModel : NSObject
@property(nonatomic, copy) NSString *imageURL;
/**  图片 */
@property (nonatomic, copy) NSURL *adImgURL;
/**  标题 */
@property (nonatomic, copy) NSString *title;
@end
