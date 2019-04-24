//
//  TJMenuHeaderCollectionReusableView.m
//  FreelyHeath
//
//  Created by L on 2018/1/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJMenuHeaderCollectionReusableView.h"

@implementation TJMenuHeaderCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}

@end
