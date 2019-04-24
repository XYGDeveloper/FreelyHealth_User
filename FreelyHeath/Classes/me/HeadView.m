//
//  HeadView.m
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HeadView.h"

@interface HeadView ()


@property (nonatomic,strong)UIImageView *headimg;

@property (nonatomic,strong)UILabel *nikeName;

@end

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {
        
        self.backGroundImageView = [[UIImageView alloc]init];
        
        self.backGroundImageView.userInteractionEnabled = YES;

        self.backGroundImageView.image = [UIImage imageNamed:@"navi_background"];
        
        [self addSubview:self.backGroundImageView];
        
        self.headimg = [[UIImageView alloc]init];
        
        CALayer *layer = self.headimg.layer;
        
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 0.6;
        layer.masksToBounds = YES;
        layer.cornerRadius = 40;
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
        [self.backGroundImageView addSubview:self.headimg];
        
        self.nikeName = [[UILabel alloc]init];
        
        self.nikeName.textAlignment = NSTextAlignmentLeft;
        
        self.nikeName.font = [UIFont systemFontOfSize:20 weight:0.2];
        
        self.nikeName.textColor = [UIColor whiteColor];
        
        
        [self.backGroundImageView addSubview:self.nikeName];
        
        [self layOutSubView];
        
        UITapGestureRecognizer *nikeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLogin)];
        
        self.nikeName.userInteractionEnabled = YES;

        [self.nikeName addGestureRecognizer:nikeTap];

    }

    return self;
    
}


- (void)toLogin{

    if (self.loginAction) {
        
        self.loginAction();
        
        NSLog(@"ssssssss");
        
    }


}



- (void)layOutSubView{

   [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
       make.top.left.right.mas_equalTo(0);
       
       make.height.mas_equalTo(176.5);
       
   }];
    
   [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
       
       make.left.mas_equalTo(28);
       make.bottom.mas_equalTo(self.backGroundImageView.mas_bottom).mas_equalTo(-22);
       make.width.height.mas_equalTo(80);
       
   }];
    
   [self.nikeName mas_makeConstraints:^(MASConstraintMaker *make) {
       
       make.left.mas_equalTo(self.headimg.mas_right).mas_equalTo(28);
       make.centerY.mas_equalTo(self.headimg.mas_centerY);
       make.width.mas_equalTo(150);
       make.height.mas_equalTo(40);
       
   }];
    
}


-(void)setHeadImage:(NSString *)url
    withAccountName:(NSString *)accountName{
    
    if ([url containsString:@"http:"]) {
        
        [self.headimg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"nologin"]];

        
    }else{
     
        self.headimg.image = [UIImage imageNamed:@"nologin"];
    
    }
    

    self.nikeName.text = accountName;
  
}



@end
