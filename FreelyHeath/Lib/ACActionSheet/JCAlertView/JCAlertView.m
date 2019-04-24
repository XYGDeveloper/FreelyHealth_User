//
//  JCAlertView.m
//
//  Created by HJaycee on 15/10/26.
//  Copyright © 2015年 HJaycee. All rights reserved.

#import "JCAlertView.h"
#import <Accelerate/Accelerate.h>

#define JCColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define JCScreenWidth [UIScreen mainScreen].bounds.size.width
#define JCScreenHeight [UIScreen mainScreen].bounds.size.height
#define JCAlertViewWidth 280
#define JCAlertViewHeight 174
#define JCAlertViewMaxHeight 440
#define JCMargin 8
#define JCButtonHeight 44
#define JCAlertViewTitleLabelHeight 50
#define JCAlertViewTitleColor JCColor(65, 65, 65)
#define JCAlertViewTitleFont [UIFont boldSystemFontOfSize:20]
#define JCAlertViewContentColor JCColor(102, 102, 102)
#define JCAlertViewContentFont [UIFont systemFontOfSize:16]
#define JCAlertViewContentHeight (JCAlertViewHeight - JCAlertViewTitleLabelHeight - JCButtonHeight - JCMargin * 2)
#define JCiOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

@class JCViewController;

@interface JCAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) NSArray *clicks;
@property (nonatomic, copy) clickHandleWithIndex clickWithIndex;
@property (nonatomic, weak) JCViewController *vc;
@property (nonatomic, strong) UIImageView *screenShotView;

- (void)setup;

@end

@interface jCSingleTon : NSObject

@property (nonatomic, strong) UIWindow *backgroundWindow;
@property (nonatomic, weak) UIWindow *oldKeyWindow;
@property (nonatomic, strong) NSMutableArray *alertStack;
@property (nonatomic, strong) JCAlertView *previousAlert;

@end

@implementation jCSingleTon

+ (instancetype)shareSingleTon{
    static jCSingleTon *shareSingleTonInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareSingleTonInstance = [jCSingleTon new];
    });
    return shareSingleTonInstance;
}

- (UIWindow *)backgroundWindow{
    if (!_backgroundWindow) {
        _backgroundWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundWindow.windowLevel = UIWindowLevelStatusBar - 1;
    }
    return _backgroundWindow;
}

- (NSMutableArray *)alertStack{
    if (!_alertStack) {
        _alertStack = [NSMutableArray array];
    }
    return _alertStack;
}

@end

@interface JCViewController : UIViewController

@property (nonatomic, strong) UIImageView *screenShotView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, weak) JCAlertView *alertView;

@end

@implementation JCViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self addScreenShot];
    [self addCoverView];
    [self addAlertView];
}

- (void)addScreenShot{
    UIWindow *screenWindow = [UIApplication sharedApplication].windows.firstObject;
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *originalImage = nil;
    if (JCiOS7OrLater) {
        originalImage = viewImage;
    } else {
        originalImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(viewImage.CGImage, CGRectMake(0, 20, 320, 460))];
    }
    
    int boxSize = 40;
    boxSize = boxSize - (boxSize % 2) + 1;
    NSData *imageData = UIImageJPEGRepresentation(originalImage, 1);
    UIImage *tmpImage = [UIImage imageWithData:imageData];
    CGImageRef img = tmpImage.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *CGImageGetHeight(img));
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    NSInteger windowR = boxSize/2;
    CGFloat sig2 = windowR / 3.0;
    if(windowR>0){ sig2 = -1/(2*sig2*sig2); }
    int16_t *kernel = (int16_t*)malloc(boxSize*sizeof(int16_t));
    int32_t  sum = 0;
    for(NSInteger i=0; i<boxSize; ++i){
        kernel[i] = 255*exp(sig2*(i-windowR)*(i-windowR));
        sum += kernel[i];
    }
    free(kernel);
    error = vImageConvolve_ARGB8888(&inBuffer, &outBuffer,NULL, 0, 0, kernel, boxSize, 1, sum, NULL, kvImageEdgeExtend);
    error = vImageConvolve_ARGB8888(&outBuffer, &inBuffer,NULL, 0, 0, kernel, 1, boxSize, sum, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error blur %ld", error);
    }
    outBuffer = inBuffer;
    CGColorSpaceRef colorSpace =CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGBitmapAlphaInfoMask &kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef =CGBitmapContextCreateImage(ctx);
    UIImage *blurImage = [UIImage imageWithCGImage:imageRef];
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    self.screenShotView = [[UIImageView alloc] initWithImage:blurImage];

    [self.view addSubview:self.screenShotView];
}

- (void)addCoverView{
    self.coverView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.coverView.backgroundColor = JCColor(5, 0, 10);
    [self.view addSubview:self.coverView];
}

- (void)addAlertView{
    [self.alertView setup];
    [self.view addSubview:self.alertView];
}

- (void)showAlert{
    CGFloat duration = 0.3;
    
    for (UIButton *btn in self.alertView.subviews) {
        btn.userInteractionEnabled = NO;
    }
    
    self.screenShotView.alpha = 0;
    self.coverView.alpha = 0;
    self.alertView.alpha = 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.screenShotView.alpha = 1;
        self.coverView.alpha = 0.65;
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        for (UIButton *btn in self.alertView.subviews) {
            btn.userInteractionEnabled = YES;
        }
    }];
    
    if (JCiOS7OrLater) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@(0.8), @(1.05), @(1.1), @(1)];
        animation.keyTimes = @[@(0), @(0.3), @(0.5), @(1.0)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        animation.duration = duration;
        [self.alertView.layer addAnimation:animation forKey:@"bouce"];
    } else {
        self.alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:duration * 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alertView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration * 0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.alertView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:duration * 0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
            }];
        }];
    }
}

- (void)hideAlertWithCompletion:(void(^)(void))completion{
    CGFloat duration = 0.2;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.coverView.alpha = 0;
        self.screenShotView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.screenShotView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(0.4, 0.4);
    } completion:nil];
}

@end

@implementation JCAlertView

- (NSArray *)buttons{
    if (!_buttons) {
        _buttons = [NSArray array];
    }
    return _buttons;
}

- (NSArray *)clicks{
    if (!_clicks) {
        _clicks = [NSArray array];
    }
    return _clicks;
}

+ (void)showOneButtonWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(JCAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click{
    JCAlertView *alertView = [JCAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message Buttons:@[@{[NSString stringWithFormat:@"%zi", buttonType] : buttonTitle}] Clicks:@[click] ClickWithIndex:nil];
}

+ (void)showTwoButtonsWithTitle:(NSString *)title Message:(NSString *)message ButtonType:(JCAlertViewButtonType)buttonType ButtonTitle:(NSString *)buttonTitle Click:(clickHandle)click ButtonType:(JCAlertViewButtonType)buttonType1 ButtonTitle:(NSString *)buttonTitle1 Click:(clickHandle)click1{
    JCAlertView *alertView = [JCAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message Buttons:@[@{[NSString stringWithFormat:@"%zi", buttonType] : buttonTitle}, @{[NSString stringWithFormat:@"%zi", buttonType1] : buttonTitle1}] Clicks:@[click, click1] ClickWithIndex:nil];
}

+ (void)showMultipleButtonsWithTitle:(NSString *)title Message:(NSString *)message Click:(clickHandleWithIndex)click Buttons:(NSDictionary *)buttons, ...{
    NSMutableArray *btnArray = [NSMutableArray array];
    NSString* curStr;
    va_list list;
    if(buttons)
    {
        [btnArray addObject:buttons];
        
        va_start(list, buttons);
        while ((curStr = va_arg(list, NSString*))) {
            [btnArray addObject:curStr];
        }
        va_end(list);
    }
    NSMutableArray *btns = [NSMutableArray array];
    for (int i = 0; i<btnArray.count; i++) {
        NSDictionary *dic = btnArray[i];
        [btns addObject:@{dic.allKeys.firstObject : dic.allValues.firstObject}];
    }
    
    JCAlertView *alertView = [JCAlertView new];
    [alertView configAlertViewPropertyWithTitle:title Message:message Buttons:btns Clicks:nil ClickWithIndex:click];
}

- (void)configAlertViewPropertyWithTitle:(NSString *)title Message:(NSString *)message Buttons:(NSArray *)buttons Clicks:(NSArray *)clicks ClickWithIndex:(clickHandleWithIndex)clickWithIndex{
    self.title = title;
    self.message = message;
    self.buttons = buttons;
    self.clicks = clicks;
    self.clickWithIndex = clickWithIndex;

    [self show];
}

- (void)show{
    [jCSingleTon shareSingleTon].oldKeyWindow = [UIApplication sharedApplication].keyWindow;

    JCViewController *vc = [[JCViewController alloc] init];
    vc.alertView = self;
    self.vc = vc;
    
    [jCSingleTon shareSingleTon].backgroundWindow.frame = [UIScreen mainScreen].bounds;
    [[jCSingleTon shareSingleTon].backgroundWindow makeKeyAndVisible];
    [jCSingleTon shareSingleTon].backgroundWindow.rootViewController = self.vc;
    
    JCAlertView *previousAlert = [jCSingleTon shareSingleTon].previousAlert;
    if (previousAlert) {
        [[jCSingleTon shareSingleTon].alertStack addObject:previousAlert];
    }
    
    [self.vc showAlert];
    
    [jCSingleTon shareSingleTon].previousAlert = self;
}

- (void)setup{
    if (self.subviews.count > 0) {
        return;
    }
    
    self.frame = CGRectMake(0, 0, JCAlertViewWidth, JCAlertViewHeight);
    NSInteger count = self.buttons.count;
    
    if (count > 2) {
        self.frame = CGRectMake(0, 0, JCAlertViewWidth, JCAlertViewTitleLabelHeight + JCAlertViewContentHeight + JCMargin + (JCMargin + JCButtonHeight) * count);
    }
    self.center = CGPointMake(JCScreenWidth / 2, JCScreenHeight / 2);
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(JCMargin, 0, JCAlertViewWidth - JCMargin * 2, JCAlertViewTitleLabelHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = self.title;
    titleLabel.textColor = JCAlertViewTitleColor;
    titleLabel.font = JCAlertViewTitleFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(JCMargin, JCAlertViewTitleLabelHeight, JCAlertViewWidth - JCMargin * 2, JCAlertViewContentHeight)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = self.message;
    contentLabel.textColor = JCAlertViewContentColor;
    contentLabel.font = JCAlertViewContentFont;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    CGFloat contentHeight = [contentLabel sizeThatFits:CGSizeMake(JCAlertViewWidth, CGFLOAT_MAX)].height;

    if (contentHeight > JCAlertViewContentHeight) {
        [contentLabel removeFromSuperview];

        UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake(JCMargin, JCAlertViewTitleLabelHeight, JCAlertViewWidth - JCMargin * 2, JCAlertViewContentHeight)];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.text = self.message;
        contentView.textColor = JCAlertViewContentColor;
        contentView.font = JCAlertViewContentFont;
        contentView.editable = NO;
        if (JCiOS7OrLater) {
            contentView.selectable = NO;
        }
        [self addSubview:contentView];
        
        CGFloat realContentHeight = 0;
        if (JCiOS7OrLater) {
            [contentView.layoutManager ensureLayoutForTextContainer:contentView.textContainer];
            CGRect textBounds = [contentView.layoutManager usedRectForTextContainer:contentView.textContainer];
            CGFloat height = (CGFloat)ceil(textBounds.size.height + contentView.textContainerInset.top + contentView.textContainerInset.bottom);
            realContentHeight = height;
        }else {
            realContentHeight = contentView.contentSize.height;
        }

        if (realContentHeight > JCAlertViewContentHeight) {
            CGFloat remainderHeight = JCAlertViewMaxHeight - JCAlertViewTitleLabelHeight - JCMargin - (JCMargin + JCButtonHeight) * count;
            contentHeight = realContentHeight;
            if (realContentHeight > remainderHeight) {
                contentHeight = remainderHeight;
            }
            
            CGRect frame = contentView.frame;
            frame.size.height = contentHeight;
            contentView.frame = frame;
            
            CGRect selfFrame = self.frame;
            selfFrame.size.height = selfFrame.size.height + contentHeight - JCAlertViewContentHeight;
            self.frame = selfFrame;
            self.center = CGPointMake(JCScreenWidth / 2, JCScreenHeight / 2);
        }
    }
    
    if (!JCiOS7OrLater) {
        CGRect frame = self.frame;
        frame.origin.y -= 10;
        self.frame = frame;
    }
    
    if (count == 1) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JCMargin, self.frame.size.height - JCButtonHeight - JCMargin, JCAlertViewWidth - JCMargin * 2, JCButtonHeight)];
        NSDictionary *btnDict = [self.buttons firstObject];
        [btn setTitle:[btnDict.allValues firstObject] forState:UIControlStateNormal];
        [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
        [self addSubview:btn];
        btn.tag = 0;
        [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    } else if (count == 2) {
        for (int i = 0; i < 2; i++) {
            CGFloat btnWidth = JCAlertViewWidth / 2 - JCMargin * 1.5;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JCMargin + (JCMargin + btnWidth) * i, self.frame.size.height - JCButtonHeight - JCMargin, btnWidth, JCButtonHeight)];
            NSDictionary *btnDict = self.buttons[i];
            [btn setTitle:[btnDict.allValues firstObject] forState:UIControlStateNormal];
            [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else if (count > 2) {
        if (contentHeight < JCAlertViewContentHeight) {
            contentHeight = JCAlertViewContentHeight;
        }
        for (int i = 0; i < count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(JCMargin, JCAlertViewTitleLabelHeight + contentHeight + JCMargin + (JCMargin + JCButtonHeight) * i, JCAlertViewWidth - JCMargin * 2, JCButtonHeight)];
            NSDictionary *btnDict = self.buttons[i];
            [btn setTitle:[btnDict.allValues firstObject] forState:UIControlStateNormal];
            [self setButton:btn BackgroundWithButonType:[[btnDict.allKeys firstObject] integerValue]];
            [self addSubview:btn];
            btn.tag = i;
            [btn addTarget:self action:@selector(alertBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)setButton:(UIButton *)btn BackgroundWithButonType:(JCAlertViewButtonType)buttonType{
    UIColor *textColor = nil;
    UIImage *normalImage = nil;
    UIImage *highImage = nil;
    switch (buttonType) {
        case JCAlertViewButtonTypeDefault:
            normalImage = [UIImage imageNamed:@"JCAlertView.bundle/default_nor"];
            highImage = [UIImage imageNamed:@"JCAlertView.bundle/default_high"];
            textColor = JCColor(255, 255, 255);
            break;
        case JCAlertViewButtonTypeCancel:
            normalImage = [UIImage imageNamed:@"JCAlertView.bundle/cancel_nor"];
            highImage = [UIImage imageNamed:@"JCAlertView.bundle/cancel_high"];
            textColor = JCColor(255, 255, 255);
            break;
        case JCAlertViewButtonTypeWarn:
            normalImage = [UIImage imageNamed:@"JCAlertView.bundle/warn_nor"];
            highImage = [UIImage imageNamed:@"JCAlertView.bundle/warn_high"];
            textColor = JCColor(255, 255, 255);
            break;
    }
    [btn setBackgroundImage:[self resizeImage:normalImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self resizeImage:highImage] forState:UIControlStateHighlighted];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
}

- (UIImage *)resizeImage:(UIImage *)image{
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

- (void)alertBtnClick:(UIButton *)btn{
    [self dismissAlert];
    
    if (self.clicks.count > 0) {
        clickHandle handle = self.clicks[btn.tag];
        if (handle) {
            handle();
        }
    } else {
        if (self.clickWithIndex) {
            self.clickWithIndex(btn.tag);
        }
    }
}

- (void)dismissAlert{
    [self.vc hideAlertWithCompletion:^{
        [self stackHandle];
    }];
}

- (void)stackHandle{
    [[jCSingleTon shareSingleTon].alertStack removeObject:self];
    JCAlertView *lastAlert = [jCSingleTon shareSingleTon].alertStack.lastObject;
    [jCSingleTon shareSingleTon].previousAlert = nil;
    if (lastAlert) {
        [lastAlert show];
    } else {
        [self toggleKeyWindow];
    }
}

- (void)toggleKeyWindow{
    [[jCSingleTon shareSingleTon].oldKeyWindow makeKeyAndVisible];
    [jCSingleTon shareSingleTon].backgroundWindow.rootViewController = nil;
    [jCSingleTon shareSingleTon].backgroundWindow.frame = CGRectZero;
}

@end
