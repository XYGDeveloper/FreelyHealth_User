//
//  TunorDetail.h
//  FreelyHeath
//
//  Created by L on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TunorDetail : NSObject

//id	string	是	商品详情id
//name	string	是	商品名称
//imagepatho	string	是	商品图片1
//imagepatht	string	是	商品图片2
//datailo	string	是	商品详情1
//datailt	string	是	商品详情2
//url	string	是	商品分享url

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *imagepatho;

@property (nonatomic,copy)NSString *imagepatht;

@property (nonatomic,copy)NSString *url;

@property (nonatomic,copy)NSString *datailo;

@property (nonatomic,copy)NSString *datailt;

@property (nonatomic,copy)NSString *goodsid;


@end
