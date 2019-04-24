//
//  PackageModel.h
//  FreelyHeath
//
//  Created by L on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageModel : NSObject

//plans	JSONArray	是	套餐列表
//
//plans参数：
//字段	类型	必填	说明
//name	string	是	套餐名称
//id	string	是	套餐id
//pays	string	是	价格
@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,assign)double pays;




@end
