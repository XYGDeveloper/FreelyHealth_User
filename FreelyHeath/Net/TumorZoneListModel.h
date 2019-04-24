//
//  TumorZoneListModel.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TeamModel : NSObject


@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *leaderfacepath;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *agreesnum;

@end

@interface infomationModel : NSObject


@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *content;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *imagepath;

@property (nonatomic,copy)NSString *url;

@end


@interface questionModel : NSObject


@property (nonatomic,copy)NSString *answer;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *agreenum;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *facepath;

@end


@interface TumorZoneListModel : NSObject

@property (nonatomic,strong)NSArray *teams;

@property (nonatomic,strong)NSArray *informations;

@property (nonatomic,strong)NSArray *questions;



@end
