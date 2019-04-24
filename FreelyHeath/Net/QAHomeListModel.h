//
//  QAHomeListModel.h
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAHomeListModel : NSObject


//agreenum = 31;
//answer = "\U6ce8\U610f\U591a\U5403\U5bb9\U6613\U6d88\U5316\U7684\U98df\U7269\U4e0d\U5403\U751f\U51b7\Uff0c\U5bd2\U51c9\U8f9b\U8fa3\U98df\U7269";
//dname = "\U9648\U5df2";
//facepath = "http://img3.imgtn.bdimg.com/it/u=645440535,1214986732&fm=214&gp=0.jpg";
//hname = "\U4e0a\U6d77\U590d\U65e6\U533b\U9662";
//id = 1;
//job = "\U4e3b\U4efb\U533b\U5e08";
//title = "\U5c31\U662f\U4e0a\U5468\Uff0c\U5403\U996d\U6ca1\U4ec0\U4e48\U80c3\U53e3\Uff0c\U8fd8\U80c3\U75bc\Uff0c\U800c\U4e14\U8fd8\U611f\U5192";



@property (nonatomic,copy)NSString *agreenum;

@property (nonatomic,copy)NSString *answer;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *facepath;




@end
