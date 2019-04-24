//
//  IndexBannerModel.h
//  FreelyHeath
//
//  Created by L on 2017/9/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexBannerModel : NSObject

//id	string	是	bannerID
//imgpath	string	是	banner图片地址
//subtitle	string	是	banner名字

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *des;

@property (nonatomic,copy)NSString *imgpath;

@property (nonatomic,copy)NSString *subtitle;

@property (nonatomic,copy)NSString *skip;

@property (nonatomic,copy)NSString *url;

@end
