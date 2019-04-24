//
//  PayModeTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/5/8.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayModeTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *payIMage;
@property (nonatomic,strong)UILabel *paylabel;
@property (nonatomic, assign) BOOL accessoryViewSelected;

@end
