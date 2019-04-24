//
//  JQIndexBannerSubview.m
//  JQFlowView
//
//  Created by 韩俊强 on 2017/5/5.
//  Copyright © 2017年 HaRi. All rights reserved.
//

#import "JQIndexBannerSubview.h"

@implementation JQIndexBannerSubview
//
//
//
//
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.coverView];
    }
    
    return self;
}

- (UIImageView *)mainImageView {
    
    if (_mainImageView == nil) {
        _mainImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _mainImageView.userInteractionEnabled = YES;
        _mainImageView.image = [UIImage imageNamed:@"index_banner"];
        _mainImageView.layer.cornerRadius = 4;
        _mainImageView.layer.masksToBounds = YES;

    }
    return _mainImageView;
}

- (UIView *)coverView {
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.layer.cornerRadius = 4;
        _coverView.layer.masksToBounds = YES;
    }
    return _coverView;
}



@end
