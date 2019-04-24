//
//  consultHeadView.h
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^letAction)();

typedef void (^rightAction)();

typedef void (^evalute)();

@interface consultHeadView : UIView

@property (nonatomic,strong)UIImageView *backGroungImage;

@property (nonatomic,strong)letAction OneshotInterpretation;

@property (nonatomic,strong)rightAction FreeConsultation;

@property (nonatomic,strong)evalute eva;


@end
