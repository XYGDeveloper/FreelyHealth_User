//
//  ButtonTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/8/31.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^picConsult)();

typedef void (^vioConsult)();

typedef void (^vedConsult)();

typedef void (^yuConsult)();

@interface ButtonTableViewCell : UITableViewCell

@property (nonatomic,strong)picConsult pic;

@property (nonatomic,strong)vioConsult vio;

@property (nonatomic,strong)vedConsult ved;

@property (nonatomic,strong)yuConsult yu;


@end
