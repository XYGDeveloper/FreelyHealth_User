//
//  FileModel.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordModel : NSObject

@property (nonatomic,copy)NSString *content;

@property (nonatomic,copy)NSString *createtime;

@property (nonatomic,copy)NSString *imagepath;

@property (nonatomic,copy)NSString *type;


@end

@interface FileModel : NSObject


@property (nonatomic,copy)NSString *age;

@property (nonatomic,copy)NSString *city;

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *rname;

@property (nonatomic,copy)NSString *sex;

@property (nonatomic,copy)NSArray *records;


//age = 30;
//city = "\U5357\U4eac";
//id = a418e75e2d4c476999140b033dc4bb06;
//name = Zhangzhang;
//records =     (
//               {
//                   content = Dddddddd;
//                   createtime = "2017-08-05 14:17:45";
//                   imagepath = "zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/78E244B3-4E72-4111-BFA2-8EB59D930C41.jpg,zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/F6A78C77-9475-4823-986B-CE4BDAA53987.jpg,zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/3091508A-39BC-4915-B4A9-CCB405817387.jpg,zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/39D01DF0-7CEA-4454-8BB3-D595F4FE33F9.jpg,zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/A1CB5960-DFEB-42CF-A8B4-038D3C2955C9.jpg,";
//                   type = 1;
//               },
//               {
//                   content = Sssss;
//                   createtime = "2017-08-05 14:16:12";
//                   imagepath = "zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/A55C27E0-FBA4-424E-BF7D-8D485697981D.jpg,zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/4777046E-349C-4A12-BBB3-D5781885328A.jpg,zhiyi.oss-cn-shenzhen.aliyuncs.com/temp/9746316A-AB3A-4821-8152-916FFEFFAC62.jpg,";
//                   type = 1;
//               }
//               );
//rname = "\U8102\U80aa\U7624\U65e9\U671f";
//sex = "\U7537";
//}
@end
