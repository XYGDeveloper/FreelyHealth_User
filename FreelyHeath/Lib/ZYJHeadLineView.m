//
//  ZYJHeadLineView.m
//  ZYJHeadLineView
//
//  Created by 张彦杰 on 16/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ZYJHeadLineView.h"

@interface ZYJHeadLineView(){
    NSTimer *_timer;     //定时器
    int count;
    int flag; //标识当前是哪个view显示(currentView/hidenView)
    NSMutableArray *_dataArr;
    NSMutableArray *_dataArr1;

}
@property (nonatomic,strong) UIView *currentView;   //当前显示的view
@property (nonatomic,strong) UIView *hidenView;     //底部藏起的view
@property (nonatomic,strong) UILabel *currentLabel;
@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic,strong) UIButton *hidenBtn;
@property (nonatomic,strong) UILabel *hidenLabel;
@property (nonatomic,strong) UILabel *currentTwoLabel;
@property (nonatomic,strong) UIButton *currentTwoBtn;
@property (nonatomic,strong) UIButton *hidenTwoBtn;
@property (nonatomic,strong) UILabel *hidenTwoLabel;
@end



@implementation ZYJHeadLineView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    count = 0;
    flag = 0;
    
    self.layer.masksToBounds = YES;
    
    //创建定时器
    [self createTimer];
    [self createCurrentView];
    [self createHidenView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap:)];
    [self addGestureRecognizer:tap];
    //改进
    UILongPressGestureRecognizer*longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
    [self addGestureRecognizer:longPress];
    
}
- (void)setVerticalShowDataArr:(NSMutableArray *)dataArr
{
    _dataArr = dataArr;
    NSLog(@"dataArr-->%@",dataArr);
//    ZYJHeadLineModel *model = _dataArr[count];
//    [self.currentBtn setTitle:@"热评" forState:UIControlStateNormal];
//    self.currentLabel.text = model.title;
//
//     _dataArr1 =(NSMutableArray *)[[_dataArr reverseObjectEnumerator] allObjects];
//    ZYJHeadLineModel *model1 = _dataArr1[count];
//    [self.currentTwoBtn setTitle:@"热议" forState:UIControlStateNormal];
//    self.currentTwoLabel.text = model1.title;
    
}


-(void)dealLongPress:(UILongPressGestureRecognizer*)longPress{
    
    if(longPress.state==UIGestureRecognizerStateEnded){
        
        _timer.fireDate=[NSDate distantPast];
        
        
    }
    if(longPress.state==UIGestureRecognizerStateBegan){
        
        _timer.fireDate=[NSDate distantFuture];
    }
    
    
    
    
}
- (void)dealTap:(UITapGestureRecognizer *)tap
{
    self.clickBlock(count);
}

- (void)createTimer
{
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dealTimer) userInfo:nil repeats:YES];
    
}

#pragma mark - 跑马灯操作
-(void)dealTimer
{
    count++;
    if (count == _dataArr.count) {
        count = 0;
    }
    
    if (flag == 1) {
        ZYJHeadLineModel *currentModel = _dataArr[count];
        [self.currentBtn setTitle:@"热评" forState:UIControlStateNormal];
        self.currentLabel.text = currentModel.title;
        _dataArr1 =(NSMutableArray *)[[_dataArr reverseObjectEnumerator] allObjects];
        ZYJHeadLineModel *model1 = _dataArr1[count];
        [self.currentTwoBtn setTitle:@"热议" forState:UIControlStateNormal];
        self.currentTwoLabel.text = model1.title;
    }
    
    if (flag == 0) {
        ZYJHeadLineModel *hienModel = _dataArr[count];
        [self.hidenBtn setTitle:@"热评" forState:UIControlStateNormal];
        self.hidenLabel.text = hienModel.title;
        _dataArr1 =(NSMutableArray *)[[_dataArr reverseObjectEnumerator] allObjects];
        ZYJHeadLineModel *model1 = _dataArr1[count];
        [self.hidenTwoBtn setTitle:@"热议" forState:UIControlStateNormal];
        self.hidenTwoLabel.text = model1.title;
    }
    
    
    if (flag == 0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.currentView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            flag = 1;
            self.currentView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.hidenView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.hidenView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            flag = 0;
            self.hidenView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.width);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.currentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)createCurrentView
{
    ZYJHeadLineModel *model = _dataArr[count];
    
    self.currentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.currentView];
    
    //此处是类型按钮(不需要点击)
    self.currentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentBtn.frame = CGRectMake(10, 3, 45, self.currentView.frame.size.height-30);
    self.currentBtn.layer.masksToBounds = YES;
    self.currentBtn.layer.cornerRadius = 4;
    self.currentBtn.layer.borderWidth = 1;
    self.currentBtn.layer.borderColor = AppStyleColor.CGColor;
    self.currentBtn.titleLabel.font = Font(16);
    [self.currentBtn setTitle:model.type forState:UIControlStateNormal];
    [self.currentBtn setTitleColor:AppStyleColor forState:UIControlStateNormal];
    self.currentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.currentView addSubview:self.currentBtn];
    
    //内容标题
    self.currentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.currentBtn.frame.origin.x+self.currentBtn.frame.size.width+10, 3, self.currentView.frame.size.width-(self.currentBtn.frame.origin.x+self.currentBtn.frame.size.width+10+10), self.currentView.frame.size.height-30)];
    self.currentLabel.text = model.title;
    self.currentLabel.textAlignment = NSTextAlignmentLeft;
    self.currentLabel.textColor = DefaultGrayTextClor;
    self.currentLabel.font = [UIFont systemFontOfSize:16];
    [self.currentView addSubview:self.currentLabel];
    
    
    //此处是类型按钮(不需要点击)
    self.currentTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentTwoBtn.frame = CGRectMake(10, 28, 45, self.currentView.frame.size.height-30);
    self.currentTwoBtn.layer.masksToBounds = YES;
    self.currentTwoBtn.layer.cornerRadius = 4;
    self.currentTwoBtn.layer.borderWidth = 1;
    self.currentTwoBtn.layer.borderColor = [UIColor redColor].CGColor;
    [self.currentTwoBtn setTitle:model.type forState:UIControlStateNormal];
    [self.currentTwoBtn setTitleColor:AppStyleColor forState:UIControlStateNormal];
    self.currentTwoBtn.layer.borderColor = AppStyleColor.CGColor;
    self.currentTwoBtn.titleLabel.font = Font(16);
    self.currentTwoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.currentView addSubview:self.currentTwoBtn];
    
    //内容标题
    self.currentTwoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.currentTwoBtn.frame.origin.x+self.currentTwoBtn.frame.size.width+10, 28, self.currentView.frame.size.width-(self.currentTwoBtn.frame.origin.x+self.currentTwoBtn.frame.size.width+10+10), self.currentView.frame.size.height-30)];
    self.currentTwoLabel.text = model.title;
    self.currentTwoLabel.textAlignment = NSTextAlignmentLeft;
    self.currentTwoLabel.textColor = [UIColor blackColor];
    self.currentTwoLabel.textColor = DefaultGrayTextClor;
    self.currentTwoLabel.font = [UIFont systemFontOfSize:16];
    [self.currentView addSubview:self.currentTwoLabel];
}

- (void)createHidenView
{
    self.hidenView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [self addSubview:self.hidenView];
    
    //此处是类型按钮(不需要点击)
    self.hidenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hidenBtn.frame = CGRectMake(10, 3, 45, self.hidenView.frame.size.height-30);
    self.hidenBtn.layer.masksToBounds = YES;
    self.hidenBtn.layer.cornerRadius = 4;
    self.hidenBtn.layer.borderWidth = 1;
    self.hidenBtn.layer.borderColor = AppStyleColor.CGColor;
    [self.hidenBtn setTitle:@"" forState:UIControlStateNormal];
    [self.hidenBtn setTitleColor:AppStyleColor forState:UIControlStateNormal];
    self.hidenBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.hidenView addSubview:self.hidenBtn];
    
    //内容标题
    self.hidenLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hidenBtn.frame.origin.x+self.hidenBtn.frame.size.width+10, 3, self.hidenView.frame.size.width-(self.hidenBtn.frame.origin.x+self.hidenBtn.frame.size.width+10+10), self.hidenView.frame.size.height-30)];
    self.hidenLabel.text = @"";
    self.hidenLabel.textAlignment = NSTextAlignmentLeft;
    self.hidenLabel.textColor = DefaultGrayTextClor;
    self.hidenLabel.font = [UIFont systemFontOfSize:16];
    [self.hidenView addSubview:self.hidenLabel];
    
    
    //此处是类型按钮(不需要点击)
    self.hidenTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hidenTwoBtn.frame = CGRectMake(10, 28, 45, self.hidenView.frame.size.height-30);
    self.hidenTwoBtn.layer.masksToBounds = YES;
    self.hidenTwoBtn.layer.cornerRadius = 4;
    self.hidenTwoBtn.layer.borderWidth = 1;
    self.hidenTwoBtn.layer.borderColor = AppStyleColor.CGColor;
    [self.hidenTwoBtn setTitle:@"" forState:UIControlStateNormal];
    [self.hidenTwoBtn setTitleColor:AppStyleColor forState:UIControlStateNormal];
    self.hidenTwoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.hidenView addSubview:self.hidenTwoBtn];
    
    //内容标题
    self.hidenTwoLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.hidenTwoBtn.frame.origin.x+self.hidenTwoBtn.frame.size.width+10, 28, self.hidenView.frame.size.width-(self.hidenTwoBtn.frame.origin.x+self.hidenTwoBtn.frame.size.width+10+10), self.hidenView.frame.size.height-30)];
    self.hidenTwoLabel.text = @"";
    self.hidenTwoLabel.textAlignment = NSTextAlignmentLeft;
    self.hidenTwoLabel.textColor = DefaultGrayTextClor;
    self.hidenTwoLabel.font = [UIFont systemFontOfSize:16];
    [self.hidenView addSubview:self.hidenTwoLabel];
}

#pragma mark - 停止定时器
- (void)stopTimer
{
    //停止定时器
    //在invalidate之前最好先用isValid先判断是否还在线程中：
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
