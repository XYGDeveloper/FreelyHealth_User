//
//  SelectAddressViewController.h
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JGModel;
typedef void (^selectHospital)(JGModel *model);
@interface SelectAddressViewController : UITableViewController
@property (nonatomic,strong)selectHospital hospital;
@property (nonatomic,strong)NSString *packageid;
@property (nonatomic,strong)NSString *packageCityId;
- (id)initWithid:(NSString *)id cityid:(NSString *)cityid;

@end
