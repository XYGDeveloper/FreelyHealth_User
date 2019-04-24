//
//  AuswerDetailModel.h
//  FreelyHeath
//
//  Created by L on 2017/8/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuswerDetailModel : NSObject

//dname	string	是	医生名字
//job	string	是	医生职务
//hname	string	是	医生医院
//answer	string	是	医生回答
//agreenum	int	是	该回答点赞数
//answerid	string	是	该回答id
@property (nonatomic,copy)NSString *facepath;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *answer;

@property (nonatomic,copy)NSString *agreenum;

@property (nonatomic,copy)NSString *answerid;

@end
