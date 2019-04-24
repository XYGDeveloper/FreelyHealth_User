//
//  GetIndexBannerRequest.h
//  FreelyHeath
//
//  Created by L on 2017/9/12.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IndexBannerHeader : NSObject

@property (nonatomic,  copy)NSString *target;

@property (nonatomic,  copy)NSString *method;

@property (nonatomic , copy) NSString *versioncode;

@property (nonatomic , copy) NSString *devicenum;

@property (nonatomic , copy) NSString *fromtype;

@property (nonatomic , copy) NSString *token;

@end

@interface IndexBannerBody : NSObject


@end


@interface GetIndexBannerRequest : NSObject

@property (nonatomic,strong)IndexBannerHeader *head;

@property (nonatomic,strong)IndexBannerBody *body;


@end
