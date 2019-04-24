//
//  PasswordView.m
//  AllDemos
//
//  Created by qhx on 2017/7/21.
//  Copyright © 2017年 quhengxing. All rights reserved.
//

#import "PasswordView.h"

@implementation PasswordView


- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.layer.cornerRadius = kAlertViewRadius;
        _alertView.layer.masksToBounds = YES;
        _alertView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
        
    }
    return _alertView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        _titleLabel.textColor = DefaultGrayTextClor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)unitLabel{
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        _unitLabel.textColor = kTitleColor;
        _unitLabel.text = self.unit;
    }
    return _unitLabel;
}

- (UITextField *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UITextField alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:kContentFontSize];
        _contentLabel.textColor = kContentColor;
        _contentLabel.layer.borderWidth = kBorderwidth;
        _contentLabel.layer.borderColor = kborderColor.CGColor;
        _contentLabel.layer.cornerRadius = kContentRadius;
        _contentLabel.layer.masksToBounds = YES;
        _contentLabel.keyboardType = UIKeyboardTypeDefault;
        _contentLabel.textAlignment  =NSTextAlignmentCenter;
        _contentLabel.keyboardType = UIKeyboardTypeDecimalPad;
        
    }
    return _contentLabel;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [self buttonWithTitle:self.cancelStr titleColor:kCancelTitleColor titleFont:[UIFont systemFontOfSize:kCancelTitleSize] titleBackground:kCancelBackgroundColor btnCornerRadius:0 borderColor:[UIColor whiteColor] borderWith:kCancelBorderWidth buttonSelector:@selector(BtnPressed:)];
        _cancelBtn.tag = 1990;
        
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [self buttonWithTitle:self.sureStr titleColor:AppStyleColor titleFont:[UIFont systemFontOfSize:kSureTitleSize] titleBackground:kSureBackgroundColor btnCornerRadius:0 borderColor:[UIColor whiteColor] borderWith:kSurelBorderWidth buttonSelector:@selector(BtnPressed:)];
        _sureBtn.tag = 1991;
        
    }
    return _sureBtn;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gogo:) name:@"keyboardAlertUp" object:nil];
    }
    return self;
}

- (void)gogo:(NSNotification *)sender{
    NSDictionary *dict = sender.userInfo;
    NSString *str = [dict objectForKey:@"keyboard"];
    if ([str isEqualToString:@"show"]) {
       self.alertView.frame = CGRectMake(kAlertViewEdgeLeft, (ScreenSizeHeight-150)/2-60, ScreenSizeWidth-kAlertViewEdgeLeft*2, kAlertViewHeight);
    }else if ([str isEqualToString:@"hidden"]){
       self.alertView.frame = CGRectMake(kAlertViewEdgeLeft, (ScreenSizeHeight-150)/2, ScreenSizeWidth-kAlertViewEdgeLeft*2, kAlertViewHeight); 
    }
}


- (id)initWithTitle:(NSString *)titleStr  cancelBtn:(NSString *)cancelBtn sureBtn:(NSString *)sureBtn unit:(NSString *)unit btnClickBlock:(btnClickBlock)btnClickIndex{
    
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        self.unitLabel.text = unit;
        self.titleLabel.text = titleStr;
        self.cancelStr = cancelBtn;
        self.sureStr = sureBtn;
        self.unit = unit;
        self.btnClickBlock = [btnClickIndex copy];
        
        [self addSubview:self.alertView];
        
        [self.alertView addSubview:self.titleLabel];
        
        [self.alertView addSubview:self.contentLabel];
        
        [self.contentLabel addSubview:self.unitLabel];
        
        if (self.sureStr != nil) {
            //双按钮
            [self.alertView addSubview:self.cancelBtn];
            
            [self.alertView addSubview:self.sureBtn];
        }else{
            //单按钮
            [self.alertView addSubview:self.cancelBtn];
        }
        
        if ([titleStr isEqualToString:@"请填写血压记录"]) {
            
            self.contentLabel.placeholder = @"例如mmhg/mmhg";
            self.unit = @"";
        }
        
        [self initUI];
        
    }
    
    
    return self;
}

- (void)initUI{
    
    self.alertView.frame = CGRectMake(kAlertViewEdgeLeft, (ScreenSizeHeight-150)/2-30, ScreenSizeWidth-kAlertViewEdgeLeft*2, kAlertViewHeight);
    
    //添加一条横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kLineViewHeight, self.alertView.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.alertView addSubview:lineView];
    
    self.titleLabel.frame = CGRectMake(0, 0, self.alertView.frame.size.width, KTitleheight);
    
    self.contentLabel.frame = CGRectMake(kContentEdgeLeft, CGRectGetMaxY(self.titleLabel.frame)+5, self.alertView.frame.size.width-kContentEdgeLeft*2, kContentHeight);
    
    self.unitLabel = [[UILabel alloc]init];
    
    self.unitLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentLabel addSubview:self.unitLabel];
    
    self.unitLabel.text  = self.unit;
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentLabel.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(40);
        make.right.mas_equalTo(-1);
        
    }];
    
    //添加一条横线
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame)+5, self.alertView.frame.size.width, 0.5)];
    lineView1.backgroundColor = DividerDarkGrayColor;
    [self.alertView addSubview:lineView1];
    
    if (self.sureStr != nil) {
        //双按钮
        self.cancelBtn.frame = CGRectMake(kBtnEdgeLeft, CGRectGetMaxY(lineView1.frame)+5, self.alertView.frame.size.width/2-kBtnEdgeLeft*2, kBtnHeight);
        
        self.sureBtn.frame = CGRectMake(self.alertView.frame.size.width/2+kBtnEdgeLeft, CGRectGetMaxY(lineView1.frame)+5, self.alertView.frame.size.width/2-kBtnEdgeLeft*2, kBtnHeight);
    }else{
        
        //单按钮
        self.cancelBtn.frame = CGRectMake(kBtnEdgeLeft, CGRectGetMaxY(lineView1.frame)+5, self.alertView.frame.size.width-kBtnEdgeLeft*2, kBtnHeight);
    }
    
    
    
}

- (void)show{
    self.frame = CGRectMake(0, 0, ScreenSizeWidth, ScreenSizeHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)cancelBtnPressed{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(BOOL)IsChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)//判断输入的是否是中文
        {
            return YES;
        }
    }
    return NO;
}


- (void)BtnPressed:(UIButton *)sender{
    
  
    NSInteger index = sender.tag-1990;
    if (index == 0) {
        
        if (self.btnClickBlock) {
            self.btnClickBlock(0,nil);
        }
    }else if (index == 1){
        
        if (self.contentLabel.text.length <=0) {
            
            [Utils postMessage:@"请输入有效值" onView:self];
            
            return;
            
            
        }
        
        if ([self IsChinese:self.contentLabel.text]) {
            
            [Utils postMessage:@"输入不正确" onView:self];
            
            return;
            
            
        }
        
        
        if (self.btnClickBlock) {
            self.btnClickBlock(1,self.contentLabel.text);
        }
    }
    
      [self cancelBtnPressed];
    
    [self hiddenKeyboard];
    
}

- (void)hiddenKeyboard{
    if ([self.contentLabel becomeFirstResponder]) {
        [self.contentLabel resignFirstResponder];
    }else{
        
    }
}

- (UIButton *)buttonWithTitle:(NSString *)btnTitle titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont titleBackground:(UIColor *)titleBackground btnCornerRadius:(CGFloat)radius borderColor:(UIColor *)borderColor borderWith:(CGFloat)borderWidth buttonSelector:(SEL)buttonSelector{
    UIButton *btn = [[UIButton alloc] init];
    //btn.frame = frame;
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont;
    btn.backgroundColor = titleBackground;
    btn.layer.cornerRadius = radius;
    btn.layer.borderColor = borderColor.CGColor;
    btn.layer.borderWidth = borderWidth;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:buttonSelector forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
