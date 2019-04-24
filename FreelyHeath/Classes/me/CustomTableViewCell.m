//
//  CustomTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "UIImage+GradientColor.h"
@implementation CustomTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.LoginOutbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        [self.LoginOutbutton setBackgroundImage:bgImg forState:UIControlStateNormal];
        
        [self.LoginOutbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.LoginOutbutton.titleLabel.font = Font(18);
        [self.LoginOutbutton setTitle:@"退出登录" forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.LoginOutbutton];
        
        self.LoginOutbutton.layer.cornerRadius = 6;
        
        self.LoginOutbutton.layer.masksToBounds = YES;
    
        [self.LoginOutbutton addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        
        
    }

    return self;
    
}


- (void)loginOut{

    
    if (self.loginout) {
        self.loginout();
        
    }

}


- (void)layoutSubviews
{

    [self.LoginOutbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        
        make.left.mas_equalTo(15);
        
        make.right.mas_equalTo(-15);
        
        make.height.mas_equalTo(49);

    }];
    
}

- (void)refreshWithisLogin:(BOOL)flag
{

    if (flag == YES) {
        
        self.LoginOutbutton.hidden = NO;
        
    }else{
        
        self.LoginOutbutton.hidden = YES;
    }

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
