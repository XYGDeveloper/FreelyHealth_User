//
//  GenTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^gemeral1)();

typedef void(^gemeral2)();

typedef void(^gemeral3)();

typedef void(^gemeral4)();

typedef void(^gemeral5)();

typedef void(^gemeral6)();

@interface GenTableViewCell : UITableViewCell

@property (nonatomic,strong)gemeral1 g1;

@property (nonatomic,strong)gemeral2 g2;

@property (nonatomic,strong)gemeral3 g3;

@property (nonatomic,strong)gemeral4 g4;

@property (nonatomic,strong)gemeral5 g5;

@property (nonatomic,strong)gemeral6 g6;


@end
