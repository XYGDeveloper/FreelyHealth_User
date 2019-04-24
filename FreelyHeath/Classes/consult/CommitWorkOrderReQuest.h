//
//  CommitWorkOrderReQuest.h
//  FreelyHeath
//
//  Created by L on 2017/10/31.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ticket : NSObject

@property (nonatomic,  copy)NSString *subject;

@property (nonatomic,  copy)NSString *content;

@property (nonatomic , copy) NSString *follower_ids;

@property (nonatomic , copy) NSString *template_id;

@property (nonatomic , copy) NSString *tags;

@property (nonatomic , copy) NSString *type;

@property (nonatomic , copy) NSString *type_content;

@property (nonatomic , copy) NSString *priority;

@property (nonatomic , copy) NSString *status;

@property (nonatomic , copy) NSString *agent_group_name;

@property (nonatomic , copy) NSString *assignee_email;

@property (nonatomic , copy) NSString *ticket_field;



@end

@interface CommitWorkOrderReQuest : NSObject

@property (nonatomic,strong)ticket *ticket;

@end
