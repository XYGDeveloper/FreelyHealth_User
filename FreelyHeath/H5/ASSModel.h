//
//  ASSModel.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASSModel : NSObject

//{"result":"健康状况评估结果中医体质评估结果进食后胃不舒服，特别会胃胀气加轻度胃痛，随着肿瘤的侵犯症状会越来越明显","id":"1","suggest":"健康状况评估建议采用科学的联合治疗的方法以提高免疫抗癌力为最，辅以中医调养，我国中医源源流长，博大精深，可治本；另外心态很重要，不要害怕和着急，否则只会加重病情。如能做到，可以显著的延长患者的寿命，\n\t早期的治疗明显有效，可以恢复正常人的生活；中晚期转移患者能够提高5-20年等不同的时间，甚至更长。关键不用手术，不用放化疗，费用不高。希望患者经过一段时间的治疗，早日康复，健康生活。"}


//{"body":"1","presult":"健康状况评估结果中医体质评估结果进食后胃不舒服，特别会胃胀气加轻度胃痛，随着肿瘤的侵犯症状会越来越明显","psuggest":"健康状况评估建议采用科学的联合治疗的方法以提高免疫抗癌力为最，辅以中医调养，我国中医源源流长，博大精深，可治本；另外心态很重要，不要害怕和着急，否则只会加重病情。如能做到，可以显著的延长患者的寿命，\n\t早期的治疗明显有效，可以恢复正常人的生活；中晚期转移患者能够提高5-20年等不同的时间，甚至更长。关键不用手术，不用放化疗，费用不高。希望患者经过一段时间的治疗，早日康复，健康生活。"}


@property (nonatomic,copy)NSString *presult;

@property (nonatomic,copy)NSString *body;

@property (nonatomic,copy)NSString *psuggest;

@property (nonatomic,copy)NSString *token;



@end
