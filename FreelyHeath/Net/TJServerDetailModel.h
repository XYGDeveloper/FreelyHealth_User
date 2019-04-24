//
//  TJServerDetailModel.h
//  FreelyHeath
//
//  Created by L on 2018/1/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface imgModel : NSObject
@property (nonatomic,copy)NSString *url;
@property (nonatomic,readwrite,assign)float H;
@property (nonatomic,readwrite,assign)float W;

@end

@interface TJServerDetailModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSArray *imageurls;
@property (nonatomic,copy)NSString *imagepath;
@property (nonatomic,copy)NSString *des;
@property (nonatomic,copy)NSString *pay;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *zilist;

@end
