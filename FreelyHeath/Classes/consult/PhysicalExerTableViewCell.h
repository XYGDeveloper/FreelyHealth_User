//
//  PhysicalExerTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^package1) ();
typedef void(^package2) ();
typedef void(^package3) ();
typedef void(^package4) ();

@interface PhysicalExerTableViewCell : UITableViewCell

@property (nonatomic,strong)package1 p1;
@property (nonatomic,strong)package2 p2;
@property (nonatomic,strong)package3 p3;
@property (nonatomic,strong)package4 p4;

@end
