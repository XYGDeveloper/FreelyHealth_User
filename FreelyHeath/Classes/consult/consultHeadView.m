//
//  consultHeadView.m
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "consultHeadView.h"


@interface consultHeadView ()


@property (nonatomic,strong)UIImageView *bannerContentView;

@property (nonatomic,strong)UIButton *leftContentView;

@property (nonatomic,strong)UIButton *rightContentView;

@property (nonatomic,strong)UIView *sepline;

@property (nonatomic,strong)UIButton *evalute;


@end


@implementation consultHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backGroungImage = [[UIImageView alloc]init];
        
        self.backGroungImage.userInteractionEnabled = YES;
        
        self.backGroungImage.image = [UIImage imageNamed:@"navi_background"];
        
        [self addSubview:self.backGroungImage];
        
        self.bannerContentView = [[UIImageView alloc]init];
        
        self.bannerContentView.userInteractionEnabled = YES;

        self.bannerContentView.backgroundColor = [UIColor whiteColor];
        
        self.bannerContentView.layer.cornerRadius = 8;
        
        CALayer *layer = self.bannerContentView.layer;
        
        layer.shadowOffset = CGSizeMake(0, 0);
        
        layer.shadowOpacity = 0.6;
        
        layer.shadowColor = [UIColor lightGrayColor].CGColor;
        
        [self addSubview:self.bannerContentView];
        
        self.leftContentView  = [UIButton buttonWithType:UIButtonTypeCustom];
        
         UIImage * leftImg = [[UIImage imageNamed:@"consult_top_leftbutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self.leftContentView setBackgroundImage:leftImg forState:UIControlStateNormal];
        
        [self.bannerContentView addSubview:self.leftContentView];
        
        [self.leftContentView addTarget:self action:@selector(OneshotInterpretationAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightContentView  = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.bannerContentView addSubview:self.rightContentView];
        
        UIImage * rightImg = [[UIImage imageNamed:@"consult_top_rightbutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self.rightContentView setBackgroundImage:rightImg forState:UIControlStateNormal];
        
        [self.rightContentView addTarget:self action:@selector(FreeConsultationAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.sepline = [[UIView alloc]init];
        
        self.sepline.backgroundColor = DividerGrayColor;
        
        [self.bannerContentView addSubview:self.sepline];

        self.evalute = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:self.evalute];
        
//         [self.evalute setTitle:@"评估" forState:UIControlStateNormal];
//        
//        [self.evalute setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        
//        [self.evalute mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.top.mas_equalTo(20);
//            
//            make.right.mas_equalTo(-10);
//            make.width.mas_equalTo(50);
//            make.height.mas_equalTo(30);
//            
//        }];
//        
//        [self.evalute addTarget:self action:@selector(toevalute) forControlEvents:UIControlEventTouchUpInside];
        
        [self layOutSubview];
        
    }
    
    return self;
    
}

- (void)toevalute{

    if (self.eva) {
        
        self.eva();
    }

}

- (void)OneshotInterpretationAction{

    if (self.OneshotInterpretation) {
        
        self.OneshotInterpretation();
        
    }


}

- (void)FreeConsultationAction{
    
    if (self.FreeConsultation) {
        
        self.FreeConsultation();
        
    }
    
}


- (void)layOutSubview{

    
    CGFloat width = kScreenWidth - 14.5*2- 17*4;
    
    
    [self.backGroungImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(134);
    }];
    
    [self.bannerContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(14.5);
       
        make.right.mas_equalTo(-14.5);
        
        make.height.mas_equalTo(122.5);
        
        make.top.mas_equalTo(self.backGroungImage.mas_bottom).mas_equalTo(-61.5);
        
        
    }];
    
    [self.leftContentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(17);
        
        make.top.mas_equalTo(11.5);
        
        make.bottom.mas_equalTo(-11.5);

        make.width.mas_equalTo(width/2);
        
    }];
    
    [self.rightContentView  mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-17);
        
        make.top.mas_equalTo(11.5);
        
        make.bottom.mas_equalTo(-11.5);
        
        make.width.mas_equalTo(width/2);
        
    }];
  
    [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.bannerContentView.mas_centerX);
        
        make.centerY.mas_equalTo(self.bannerContentView.mas_centerY);

        make.width.mas_equalTo(1);
        
        make.height.mas_equalTo(self.leftContentView.mas_height);

        
    }];
    

}


@end
