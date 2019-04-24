//
//  GuideExTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^guide1)();

typedef void(^guide2)();

typedef void(^guide3)();

typedef void(^guide4)();

@interface GuideExTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *guideButton1;

@property (weak, nonatomic) IBOutlet UIButton *guide2Button;

@property (weak, nonatomic) IBOutlet UIButton *roow;

@property (weak, nonatomic) IBOutlet UIButton *guide3Button;

@property (weak, nonatomic) IBOutlet UIButton *guid4Button;

@property (nonatomic,strong)guide1 guide1;

@property (nonatomic,strong)guide2 guide2;

@property (nonatomic,strong)guide3 guide3;

@property (nonatomic,strong)guide4 guide4;

@end
