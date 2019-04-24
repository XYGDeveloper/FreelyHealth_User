//
//  SectionCollectionReusableView.m
//  FreelyHeath
//
//  Created by L on 2018/1/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SectionCollectionReusableView.h"
@interface SectionCollectionReusableView()
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *bottomView;

@end

@implementation SectionCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView = [[UIView alloc]init];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.contentView];
        UIView *topview = [[UIView alloc]init];
        topview.backgroundColor = [UIColor whiteColor];
        [self addSubview:topview];
        [topview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topview.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(100.5);
        }];
        CGFloat width  = kScreenWidth/4;
        NSArray *titlearr = @[@"体检套餐",@"体检预约",@"报告查看",@"体检机构"];
        NSArray *imageArr = @[@"tj-1",@"tj-2",@"tj-3",@"tj-4"];
        for (int i = 0; i < 4; i++) {
            UIButton *bgview = [UIButton buttonWithType:UIButtonTypeSystem];
            bgview.frame =CGRectMake(width *i,0, kScreenWidth/4, 60);
            bgview.tag = i+1000;
            [bgview addTarget:self action:@selector(toJump:) forControlEvents:UIControlEventTouchUpInside];
            UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            imageButton.tag = i +1000;
            [imageButton setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [imageButton addTarget:self action:@selector(toJump:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.backgroundColor = [UIColor whiteColor];
            [bgview addSubview:imageButton];
            [imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(bgview.mas_centerY);
                make.centerX.mas_equalTo(bgview.mas_centerX);
                make.width.mas_equalTo(30);
                make.height.mas_equalTo(32);
            }];
            [self.contentView addSubview:bgview];
            UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            titleButton.tag = i + 1000;
            titleButton.frame = CGRectMake(width *i, CGRectGetMaxY(bgview.frame), kScreenWidth/4, 20);
            [titleButton setTitle:titlearr[i] forState:UIControlStateNormal];
            [titleButton setTitleColor:DefaultBlackLightTextClor forState:UIControlStateNormal];
            titleButton.titleLabel.font = FontNameAndSize(15);
            [self.contentView addSubview:titleButton];
            [titleButton addTarget:self action:@selector(toJump:) forControlEvents:UIControlEventTouchUpInside];
            
            self.bottomView = [[UIView alloc]init];
            self.bottomView.backgroundColor = RGB(88, 168, 238);
            [self addSubview:self.bottomView];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(self.contentView.mas_bottom);
                make.bottom.mas_equalTo(0);
            }];
            self.textLabel = [[UILabel alloc]init];
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.textLabel.textColor = [UIColor whiteColor];
            self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            [self.bottomView addSubview:self.textLabel];
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(20);
                make.centerX.mas_equalTo(self.bottomView.mas_centerX);
                make.centerY.mas_equalTo(self.bottomView.mas_centerY);
            }];
        }
    }
    return self;
}

- (void)toJump:(UIButton *)sender{
    if (self.jump) {
        self.jump(sender.tag);
    }
}

@end
