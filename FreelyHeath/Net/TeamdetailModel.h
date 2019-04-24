//
//  TeamdetailModel.h
//  FreelyHeath
//
//  Created by L on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface members : NSObject


@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *job;
@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,copy)NSString *facepath;




@end


@interface TeamdetailModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *chatid;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *lname;
@property (nonatomic,copy)NSString *ljob;

@property (nonatomic,copy)NSString *lhname;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,copy)NSString *lfacepath;

@property (nonatomic,strong)NSArray *members;

@property (nonatomic,strong)NSString *shareurl;


@end
