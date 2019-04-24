//
//  IndexModel.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexListModel : NSObject

//name	string	是	指标名称
//id	string	是	指标id
//finallynum	string	是	最新指标

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *finallynum;

@property (nonatomic,copy)NSString *unit;


@end
