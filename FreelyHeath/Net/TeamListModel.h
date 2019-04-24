//
//  TeamListModel.h
//  FreelyHeath
//
//  Created by L on 2017/7/28.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MemberModel : NSObject

//"facepath": "http:\/\/img3.imgtn.bdimg.com\/it\/u=3812448785,1198799034&fm=214&gp=0.jpg",
//"id": "6",
//"introduction": "曾赴友谊医院神经内科进修，参与多项科研课题及药物试验课题，发表文章10篇，参与教材编写2部。擅长精神病治疗工作",
//"hname": "上海复旦医院",
//"name": "金城无",
//"job": "主任医师"
@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *hname;

@property (nonatomic,copy) NSString *job;

@property (nonatomic,copy) NSString *introduction;

@property (nonatomic,copy) NSString *facepath;

@end

@interface TeamListModel : NSObject

//"introduction": "曾赴友谊医院神经内科进修，参与多项科研课题及药物试验课题，发表文章10篇，参与教材编写2部。擅长精神病治疗工作",
//"lname": "赵峰",
//"lhname": "上海复旦医院",
//"members": [],
//"id": "t2",
//"ljob": "主任医师",
//"lfacepath": "http://img3.imgtn.bdimg.com/it/u=3812448785,1198799034&fm=214&gp=0.jpg",
//"name": "胸腺外科专家团队"
//},

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *lname;

@property (nonatomic,copy) NSString *ljob;

@property (nonatomic,copy) NSString *lhname;

@property (nonatomic,copy) NSString *introduction;

@property (nonatomic,copy) NSString *lfacepath;

@property (nonatomic,strong) NSArray *members;

@end
