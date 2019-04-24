//
//  NBBannerConfig.m
//  页面分离
//
//  Created by xxzx on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NBBannerConfig.h"

@implementation NBBannerConfig
- (instancetype)init
{
    if (self = [super init]) {
        _cornerRadius = 5;
        _textAlignment = NSTextAlignmentCenter;
        _textRightAndLeftSpace = 20;
        _textBottomSpace = 10;
        _textFontSize = 16;
        _textColor = [UIColor blackColor];
        _showText = YES;
        _kCardHorizontalSpace = 20;
        _midCardEdgeInsets = UIEdgeInsetsMake(10, 30, 20, 30);//UIEdgeInsetsZero;
        _bgColor = [UIColor clearColor];
        _blurEffectViewColor = [UIColor whiteColor];
        _showBlurEffectView = YES;
        _timeInterval = 2;
        _pageIndicatorTintColor = [UIColor whiteColor];
        _currentPageIndicatorTintColor = [UIColor orangeColor];
    }
    return self;
}
@end
