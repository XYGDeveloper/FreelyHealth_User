//
//  CustomTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^loginOutAction)();


@interface CustomTableViewCell : UITableViewCell

@property (nonatomic,strong)UIButton *LoginOutbutton;

@property (nonatomic,strong)loginOutAction loginout;

- (void)refreshWithisLogin:(BOOL )flag;



@end
