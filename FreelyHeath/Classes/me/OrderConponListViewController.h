//
//  OrderConponListViewController.h
//  FreelyHeath
//
//  Created by L on 2018/5/7.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyconponListModel;
typedef void (^selectConpon)(MyconponListModel *model);
typedef void (^selectNoTouseConpon)();

@interface OrderConponListViewController : UIViewController
@property (nonatomic,strong)NSString *id;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *zilist;
@property (nonatomic,strong)NSString *cid;

@property (nonatomic,strong)selectConpon conpon;
@property (nonatomic,strong)selectNoTouseConpon noconpon;

@end
