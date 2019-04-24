//
//  UdeskCustomNavigation.m
//  UdeskSDK
//
//  Created by Udesk on 2017/3/16.
//  Copyright © 2017年 Udesk. All rights reserved.
//

#import "UdeskCustomNavigation.h"
#import "UdeskUtils.h"
#import "UdeskFoundationMacro.h"
#import "UdeskViewExt.h"

@implementation UdeskCustomNavigation

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, UD_SCREEN_WIDTH, ud_is_iPhoneX ? 88 : 64)];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0.976f  green:0.976f  blue:0.976f alpha:1];
        [self initNavTitleLabel];
        [self initNavCloseButton];
        [self initNavRightButton];
    }
    return self;
}

- (void)initNavTitleLabel {

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20 + (ud_is_iPhoneX?24:0), [[UIScreen mainScreen] bounds].size.width-(75*2), 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
}

- (void)initNavCloseButton {

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(10, 20 + (ud_is_iPhoneX?24:0), 50, 44);
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_closeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_closeButton setTitle:getUDLocalizedString(@"udesk_close") forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(closeViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
}

- (void)initNavRightButton {

    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(self.ud_right-50-10, 20 + (ud_is_iPhoneX?24:0), 50, 44);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightButton.hidden = YES;
    [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_rightButton];
}

- (void)closeViewControllerAction {

    if (self.closeViewController) {
        self.closeViewController();
    }
}

- (void)rightButtonAction {

    if (self.rightButtonHandle) {
        self.rightButtonHandle();
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    
    CGContextMoveToPoint(ctx, 0, ud_is_iPhoneX ? 88 : 64);
    CGContextAddLineToPoint(ctx, rect.size.width, ud_is_iPhoneX ? 88 : 64);
    
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

@end
