//
//  LYZAdView.m
//  LeYiZhu-iOS
//
//  Created by mac on 2017/8/3.
//  Copyright © 2017年 乐易住智能科技. All rights reserved.
//

#import "LYZAdView.h"
#import "UIView+SetRect.h"
#import "UIView+UserInteraction.h"
#import "POP.h"
#import "UIImageView+WebCache.h"
@interface LYZAdView  ()

@property (nonatomic, strong)  UIView  *blackView;
@property (nonatomic, strong)  UIView  *messageView;
@property (nonatomic, strong)  UIButton *closeBtn;

@end

@implementation LYZAdView
- (void)show {
    
    if (self.contentView) {
        
        [self.contentView addSubview:self];
        
        self.contentViewUserInteractionEnabled == NO ? [self.contentView enabledUserInteraction] : 0;
        [self createBlackView];
        [self createUpdateView];
        
        if (self.autoHiden) {
            [self performSelector:@selector(hide) withObject:nil afterDelay:self.delayAutoHidenDuration];
        }
    }
}

- (void)hide {
    
    if (self.contentView) {
        
        [self removeViews];
    }
}

- (void)createBlackView {
    
    self.blackView                 = [[UIView alloc] initWithFrame:self.contentView.bounds];
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.alpha           = 0;
    
    AdViewMessageObject *message = self.messageObject;
    if (!message.auisforce) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.numberOfTapsRequired = 1;
        [tap addTarget:self action:@selector(hide)];
        [self.blackView addGestureRecognizer:tap];
    }
    [self addSubview:self.blackView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseMessageViewWillAppear:)]) {
        
        [self.delegate baseMessageViewWillAppear:self];
    }
    
    [UIView animateWithDuration:0.4f animations:^{
        
        self.blackView.alpha = 0.6f;
        
    } completion:^(BOOL finished) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(baseMessageViewDidAppear:)]) {
            
            [self.delegate baseMessageViewDidAppear:self];
        }
    }];
}

- (void)createUpdateView {
    
    AdViewMessageObject *message = self.messageObject;
    
    {
        UIImage *img = [UIImage imageNamed:@"myconpon_bg"];
        // 创建信息窗体view
        self.messageView                   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, 0)];
//        self.messageView.backgroundColor   = [[UIColor whiteColor] colorWithAlphaComponent:0.985f];
        self.messageView.center            = self.contentView.middlePoint;
        self.messageView.alpha             = 0.f;
        self.messageView.layer.cornerRadius = 6.0f;
        
        UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.messageView.width, img.size.height)];
        headImgView.image = img;
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 6;// 字体的行间距
//
//        NSDictionary *attributes = @{
//                                     NSFontAttributeName:FontNameAndSize(16),
//                                     NSParagraphStyleAttributeName:paragraphStyle
//                                     };
//        UITextView *textView = [[UITextView alloc]  initWithFrame:CGRectMake(15, headImgView.bottom , self.messageView.width - 30 , 0)];
//        textView.font = FontNameAndSize(16);
//        textView.textColor = DefaultGrayTextClor;
//        textView.editable = NO;
//
//        textView.attributedText =  [[NSAttributedString alloc] initWithString:message.auaucontent attributes:attributes];
//        CGSize constraintSize = CGSizeMake(textView.width, MAXFLOAT);
//        CGSize size = [textView sizeThatFits:constraintSize];
//        //TODO:
//        CGFloat textViewheight;
//        if (size.height > 124) {
//            textViewheight = 124;
//            textView.showsVerticalScrollIndicator = YES;
//            textView.scrollEnabled = YES;
//        }else{
//            textViewheight = size.height;
//            textView.showsVerticalScrollIndicator = NO;
//            textView.scrollEnabled = NO;
//        }
//        textView.frame = CGRectMake(textView.x, textView.y, textView.width, textViewheight);
//
//
       [self.messageView addSubview:headImgView];
//        [self.messageView addSubview:textView];
        
        UIButton *updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        updateBtn.frame = CGRectMake(30, CGRectGetMaxY(headImgView.frame)- 65, self.messageView.width - 60, 65);
        [updateBtn setImage:[UIImage imageNamed:@"conpon_get"] forState:UIControlStateNormal];
        [updateBtn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.messageView addSubview:updateBtn];
        
        self.messageView.height =headImgView.height;
        [self addSubview:self.messageView];
        self.messageView.center  = self.contentView.middlePoint;
        self.messageView.y -= 30;
        
        if (!message.auisforce) {
            self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.closeBtn.frame = CGRectMake(0, 0, 30, 30);
            [self.closeBtn setImage:[UIImage imageNamed:@"myconpon_close"] forState:UIControlStateNormal];
            [self.closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            self.closeBtn.center = self.contentView.middlePoint;
            self.closeBtn.y =  self.messageView.bottom + 40;
            [self addSubview:self.closeBtn];
        }
    }
    // 执行动画
    POPBasicAnimation  *alpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alpha.toValue             = @(1.f);
    alpha.duration            = 0.3f;
    [self.messageView pop_addAnimation:alpha forKey:nil];
    
    POPSpringAnimation *scale = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scale.fromValue           = [NSValue valueWithCGSize:CGSizeMake(1.75f, 1.75f)];
    scale.toValue             = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scale.dynamicsTension     = 1000;
    scale.dynamicsMass        = 1.3;
    scale.dynamicsFriction    = 10.3;
    scale.springSpeed         = 20;
    scale.springBounciness    = 15.64;
    [self.messageView.layer pop_addAnimation:scale forKey:nil];
    
    scale.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        
        [self.messageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[UIButton class]]) {
                
                UIButton *button              = obj;
                button.userInteractionEnabled = YES;
            }
        }];
    };
}

- (void)buttonEvent:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseMessageView:event:)]) {
        [self.delegate baseMessageView:self event:[button titleForState:UIControlStateNormal]];
    }
    [self hide];
    
}



- (void)removeViews {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseMessageViewWillDisappear:)]) {
        
        [self.delegate baseMessageViewWillDisappear:self];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        self.blackView.alpha       = 0.f;
        self.messageView.alpha     = 0.f;
        self.messageView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
        
    } completion:^(BOOL finished) {
        
        self.contentViewUserInteractionEnabled == NO ? [self.contentView disableUserInteraction] : 0;
        [self removeFromSuperview];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(baseMessageViewDidDisappear:)]) {
            [self.delegate baseMessageViewDidDisappear:self];
        }
    }];
}


-(void)closeBtnClick:(UIButton *)sender{
    AdViewMessageObject *message = self.messageObject;
    if (message.auisforce) {
        
    }else{
        [self hide];
    }
}

@end

#pragma mark - AdViewMessageObject

@implementation AdViewMessageObject

@end


