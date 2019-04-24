//
//  CaseListModel.h
//  FreelyHeath
//
//  Created by L on 2018/3/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CaseListModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *zhengzhuang;
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *age;
@property (nonatomic,assign)BOOL select;

@end
