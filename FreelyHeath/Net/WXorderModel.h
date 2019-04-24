//
//  WXorderModel.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXorderModel : NSObject

//appid	string	是
//timestamp	String	是
//noncestr	string	是
//partnerid	string	是
//prepayid	string	是
//packageStr	string	是
//sign	string	是
//orderid	string	是

@property (nonatomic,copy)NSString *appid;

@property (nonatomic,copy)NSString *timestamp;

@property (nonatomic,copy)NSString *noncestr;

@property (nonatomic,copy)NSString *partnerid;

@property (nonatomic,copy)NSString *prepayid;

@property (nonatomic,copy)NSString *packageStr;

@property (nonatomic,copy)NSString *sign;

@property (nonatomic,copy)NSString *orderid;


@end
