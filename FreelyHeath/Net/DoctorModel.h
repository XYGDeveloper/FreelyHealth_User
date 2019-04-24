//
//  DoctorModel.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoctorModel : NSObject


//{"msg":"请求成功","data":{"introduction":"曾赴友谊医院神经内科进修，参与多项科研课题及药物试验课题，发表文章10篇，参与教材编写2部。擅长精神病治疗工作","dname":"肝胆外科","backnum":0,"agreenum":5,"id":"14","hname":"上海交大医院","job":"副主任医师","name":"陈美容","facepath":"http:\/\/img3.imgtn.bdimg.com\/it\/u=645440535,1214986732&fm=214&gp=0.jpg"},"returncode":"10000"}
@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *dname;

@property (nonatomic,copy)NSString *job;

@property (nonatomic,copy)NSString *hname;

@property (nonatomic,copy)NSString *facepath;

@property (nonatomic,copy)NSString *introduction;

@property (nonatomic,assign)int agreenum;

@property (nonatomic,assign)int backnum;

@property (nonatomic,assign)NSString *shareurl;

@property (nonatomic,assign)NSString *menzhen;

@end
