//
//  PriceModel.h
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceModel : NSObject
@property (nonatomic,copy)NSString *imagepath;
@property (nonatomic,copy)NSString *des;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *fuwufei;
@property (nonatomic,assign)int count;

@end
