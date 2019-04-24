//
//  ToQuestionViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/24.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ToQuestionViewController.h"
#import "ToAuswerApi.h"
#import "ToAuswerRequest.h"
#import "User.h"
#import "SZTextView.h"

@interface ToQuestionViewController ()<ApiRequestDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong)ToAuswerApi *api;

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UIView *MiddleView;

@property (nonatomic,strong)UITextField *titleLabel;

@property (nonatomic,strong)SZTextView *textView;

@end

@implementation ToQuestionViewController


- (ToAuswerApi *)api
{

    if (!_api) {
        
        _api = [[ToAuswerApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [LSProgressHUD hide];
    
    [Utils postMessage:command.response.msg onView:self.view];
    


}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    [LSProgressHUD hide];
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (IBAction)commitQuestionAction:(id)sender {
    
    //提交问题
    
    if (self.titleLabel.text.length <= 0) {
        
        [Utils postMessage:@"问题标题不能为空" onView:self.view];

        return;
        
    }
    
    if (self.textView.text.length <= 0) {
        
        [Utils postMessage:@"问题详情不能为空" onView:self.view];

        return;
        
    }
    
    
    [LSProgressHUD showWithMessage:nil];
    
    
    AuswerRequestHeader *head = [[AuswerRequestHeader alloc]init];
    
    head.target = @"forumControl";
    
    head.method = @"askQuestion";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    AuswerRequestBody *body = [[AuswerRequestBody alloc]init];
    
    body.title = self.titleLabel.text;
    
    body.detail = self.textView.text;
    
    
    ToAuswerRequest *request = [[ToAuswerRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api toAuswerWithRequest:request.mj_keyValues.mutableCopy];

    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    self.topView = [[UIView alloc]init];
    
    self.topView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(64);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
        
    }];
    
    UILabel *des = [[UILabel alloc]init];
    
    [self.topView addSubview:des];
    
    des.text = @"提问标题:";
    
    des.textAlignment = NSTextAlignmentLeft;
    
    des.textColor = DefaultGrayLightTextClor;
    
    des.font = Font(16);
    
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        
        make.width.mas_equalTo(80);
        
        make.left.mas_equalTo(16);
        
        make.height.mas_equalTo(44);
        
    }];
    
    self.titleLabel = [[UITextField alloc]init];
    
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    self.titleLabel.font = Font(16);
    
    self.titleLabel.placeholder = @"一句话说明你的问题";
    
    self.titleLabel.delegate  =self;
    
    [self.topView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(des.mas_right).mas_equalTo(0);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    self.MiddleView = [[UIView alloc]init];
    
    self.MiddleView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.MiddleView];
    
    [self.MiddleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.topView.mas_bottom).mas_equalTo(14);
        
        make.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(229);
    }];
    
    
    [self.MiddleView addSubview:self.textView];
    
    
    UILabel *des1 = [[UILabel alloc]init];
    
    [self.MiddleView addSubview:des1];
    
    des1.text = @"提问详情：";
    
    des1.textAlignment = NSTextAlignmentLeft;
    
    des1.textColor = DefaultGrayLightTextClor;
    
    des1.font = Font(16);
    
    [des1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        
        make.right.mas_equalTo(-16);
        
        make.left.mas_equalTo(16);
        
        make.height.mas_equalTo(30);
        
    }];

    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(des1.mas_bottom).mas_equalTo(0);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-16);
    }];
    
    
    // Do any additional setup after loading the view from its nib.
}


- (SZTextView *)textView {
    if (!_textView) {
        _textView = [[SZTextView alloc] initWithFrame:CGRectZero];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.font = Font(16);
        _textView.textColor = DefaultGrayTextClor;
        _textView.placeholder = @"请描述患者病情";
        _textView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        
    }
    return _textView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];
    

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    return YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
