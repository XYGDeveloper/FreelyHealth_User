//
//  GroupInfoModel.h
//  FreelyHeath
//
//  Created by L on 2018/5/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface groupMemberModel : NSObject

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *facepath;

@end

@interface GroupInfoModel : NSObject
@property (nonatomic,copy)NSString *groupname;
@property (nonatomic,strong)NSArray *peoples;
@end
