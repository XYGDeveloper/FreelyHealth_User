//
//  HeadView.h
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tologinAction)();


@interface HeadView : UIView

@property (nonatomic,strong)tologinAction loginAction;

@property (nonatomic,strong)UIImageView *backGroundImageView;

-(void)setHeadImage:(NSString*)url
    withAccountName:(NSString*)accountName;


@end
