//
//  CategoryModel.h
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *shuxing;

@end

@interface FoodModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@end

