//
//  CustomShareView.m
//  CustomShareStyle
//
//  Created by ljw on 16/6/2.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "CustomShareView.h"

#define UIBounds [[UIScreen mainScreen] bounds] //window外框大小
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


@implementation CustomShareView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        _huiseControl=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, UIBounds.size.width, UIBounds.size.height)];
        _huiseControl.backgroundColor=RGBACOLOR(0, 0, 0, 0.4);
        [_huiseControl addTarget:self action:@selector(huiseControlClick) forControlEvents:UIControlEventTouchUpInside];
        _huiseControl.alpha=0;
        self.backgroundColor = [UIColor whiteColor];
        
        
        _shareListView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UIBounds.size.width, 191)];
        _shareListView.backgroundColor = RGBACOLOR(255, 255, 255, 1);
        [self addSubview:_shareListView];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, (kScreenWidth- 40)/2, 20)];
        title.textColor = RGBACOLOR(0, 0, 0,1);
        title.font = [UIFont boldSystemFontOfSize:20];
        title.textAlignment = NSTextAlignmentLeft;
        title.textColor  =DefaultGrayTextClor;
        title.text = @"选择支付方式";
        [_shareListView addSubview:title];
        
        UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title.frame), 20, (kScreenWidth- 40)/2, 20)];
        title1.textColor = RGBACOLOR(0, 0, 0,1);
        title1.font = [UIFont boldSystemFontOfSize:20];
        title1.textAlignment = NSTextAlignmentRight;
        title1.textColor  =DefaultGrayTextClor;
        
        [_shareListView addSubview:title1];
        
        UILabel *remind = [[UILabel alloc]initWithFrame:CGRectMake(16, title.frame.origin.y+title.frame.size.height+32, 1, 17)];
        remind.textColor = RGBACOLOR(0, 0, 0,0.8);
        remind.font = [UIFont systemFontOfSize:14];
        remind.textAlignment = NSTextAlignmentLeft;
        remind.textColor  = DividerDarkGrayColor;
        [_shareListView addSubview:remind];
        
        CGFloat width = 30;

        CGFloat buttonWidth = (kScreenWidth - 90)/2;
        
        NSArray *titleArray = @[@"微信支付",@"支付宝支付"];
        NSArray *imageArray = @[@"weixin",@"alipay-1"];

        for (NSInteger i = 0; i< 2; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.frame = CGRectMake(width+(width+buttonWidth)*i,CGRectGetMaxY(remind.frame), (kScreenWidth - 90)/2, 60);
            
            [_shareListView addSubview:button];
                        
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font =[UIFont systemFontOfSize:20];
            button.titleLabel.textColor  = DefaultGrayLightTextClor;
            //图片
            [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
            
             CGFloat imageWidth = button.imageView.bounds.size.width;
            
             button.imageEdgeInsets = UIEdgeInsetsMake(0, -imageWidth, 0, imageWidth-20);
            
             button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
            
            button.tag = i+1;
           
            [button addTarget:self action:@selector(shareControl:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        
        
//        CGFloat leftPading = 24;
//        CGFloat space = (UIBounds.size.width-24*2-48*4)/3;
//        CGFloat width = 48;
        
//        for (int i=0; i<4; i++) {
//            
//            UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            shareButton.frame = CGRectMake(leftPading+(width+space)*i, remind.frame.origin.y+remind.frame.size.height+24, width, width);
//            NSString *imageName = [NSString stringWithFormat:@"shareList%d",i+1];
//            [shareButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//            [_shareListView addSubview:shareButton];
//            
//            UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftPading+(width+space)*i, shareButton.frame.origin.y+shareButton.frame.size.height+8, width, 14)];
//            shareLabel.textColor = RGBACOLOR(0, 0, 0, 1);
//            shareLabel.font = [UIFont systemFontOfSize:12];
//            shareLabel.text = [titleArray objectAtIndex:i];
//            shareLabel.textAlignment = NSTextAlignmentCenter;
//            [_shareListView addSubview:shareLabel];
//            
//            
//            CGFloat shareControlWidth = 90;
//            if (i==0 || i==3) {
//                
//                shareControlWidth = leftPading+width+space/2;
//                
//            }else
//            {
//                shareControlWidth = width+space;
//            }
//            
//            UIControl *shareControl = [[UIControl alloc]initWithFrame:CGRectMake(0+(leftPading+width+space/2)*i, shareButton.frame.origin.y-12, shareControlWidth, 12+48+8+14+12)];
//            shareControl.tag = i+1;
//            [_shareListView addSubview:shareControl];
//            [shareControl addTarget:self action:@selector(shareControl:) forControlEvents:UIControlEventTouchUpInside];
//            
//        }
        
        
    }
    return self;
}


- (void)showInView:(UIView *) view {
    if (self.isHidden) {
        self.hidden = NO;
        if (_huiseControl.superview==nil) {
            [view addSubview:_huiseControl];
        }
        [UIView animateWithDuration:0.2 animations:^{
            _huiseControl.alpha=1;
        }];
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [self.layer addAnimation:animation forKey:@"animation1"];
        self.frame = CGRectMake(0,view.frame.size.height - 191, UIBounds.size.width, 191);
        [view addSubview:self];
    }
}


- (void)hideInView {
    if (!self.isHidden) {
        self.hidden = YES;
        CATransition *animation = [CATransition  animation];
        animation.delegate = self;
        animation.duration = 0.2f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
        [self.layer addAnimation:animation forKey:@"animtion2"];
        [UIView animateWithDuration:0.2 animations:^{
            _huiseControl.alpha=0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)shareControl:(UIControl *)sender
{

    [self hideInView];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectPayModel:)]) {
        [self.delegate selectPayModel:(long)sender.tag];
    }
    

    NSLog(@"点击的第%ld个",(long)sender.tag);
    
}

-(void)huiseControlClick{
    [self hideInView];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

