//
//  BCViewController.h
//  FreelyHeath
//
//  Created by L on 2018/3/14.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCViewController : UIViewController<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSString *id;
@property (nonatomic,assign)BOOL isEditEnter;

@end
