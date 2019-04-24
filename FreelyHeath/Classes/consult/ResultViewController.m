//
//  ResultViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ResultViewController.h"
#import "SaveApi.h"
#import "SaveToFiles.h"
#import "ASSModel.h"
#import "CustomerViewController.h"
#import "ResultModel.h"
#import "ResultApi.h"
#import "ResultRequest.h"
#import "EvaluteResultTableViewCell.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"

@interface ResultViewController ()<ApiRequestDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)UIButton *button;

@property (nonatomic,strong)SaveApi *saveAp;

@property (nonatomic,strong)ResultApi *resultApi;

@property (nonatomic,strong)ResultModel *resultModel;


@property (nonatomic,strong)NSString *IDs;

@end

@implementation ResultViewController



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    EvaluteResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EvaluteResultTableViewCell class])];
    
    cell.backgroundColor = [UIColor redColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.model.presult) {
        
        [cell refreshWithModel:self.model];

    }else{
    
        [cell refreshWithResult:self.resultModel];
    
    }
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([EvaluteResultTableViewCell class]) cacheByIndexPath:indexPath configuration:^(EvaluteResultTableViewCell *cell) {
        
        if (self.model.presult) {
            
            [cell refreshWithModel:self.model];
            
            
        }else{
            
            [cell refreshWithResult:self.resultModel];
            
        }

    }];

    
}


- (SaveApi *)saveAp
{

    if (!_saveAp) {
        
        _saveAp = [[SaveApi alloc]init];
        
        _saveAp.delegate  =self;
        
    }

    return _saveAp;
    
}


- (ResultApi *)resultApi
{

    if (!_resultApi) {
        
        _resultApi = [[ResultApi alloc]init];
        
        _resultApi.delegate  =self;
        
    }

    return _resultApi;
    

}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _resultApi) {
        
        [LSProgressHUD hide];

        self.resultModel = responsObject;
        
        [self.tableview reloadData];
        
        [Utils postMessage:command.response.msg onView:self.view];

    }
  
    if (api == _saveAp) {
        
        [LSProgressHUD hide];

        [Utils postMessage:@"存入成功" onView:self.view];

    }
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [LSProgressHUD hide];
    
    if (api == _saveAp) {
        
        [Utils postMessage:@"存入失败" onView:self.view];


    }

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.title = @"评估结果";
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.tableview.backgroundColor = DefaultBackgroundColor;
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self setRightNavigationItemWithTitle:@"存入档案" action:@selector(toValuteAction)];

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    
        [self.view addSubview:self.button];
    
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            
        }];
    
    
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        self.button.backgroundColor = AppStyleColor;
    
        [self.button setTitle:@"深度咨询" forState:UIControlStateNormal];
    
        [self.button addTarget:self action:@selector(consultAction) forControlEvents:UIControlEventTouchUpInside];
    
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
        [self.tableview registerClass:[EvaluteResultTableViewCell class] forCellReuseIdentifier:NSStringFromClass([EvaluteResultTableViewCell class])];
    
        [LSProgressHUD showWithMessage:nil];
    
        resultHeader *head = [[resultHeader alloc]init];
    
        head.target = @"assessmentControl";
    
        head.method = @"goResult";
    
        head.versioncode = Versioncode;
    
        head.devicenum = Devicenum;
    
        head.fromtype = Fromtype;
    
        head.token = [User LocalUser].token;
    
        resultBody *body = [[resultBody alloc]init];
    
        ResultRequest *request = [[ResultRequest alloc]init];
    
        request.head = head;
    
        request.body = body;
    
        NSLog(@"%@",request);
        
        [self.resultApi getmyfile:request.mj_keyValues.mutableCopy];
    
    
}

- (void)toValuteAction{

    
    //雕存入入档案接口
    [LSProgressHUD showWithMessage:nil];
    
    saveToFileHeader *head = [[saveToFileHeader alloc]init];
    
    head.target = @"assessmentControl";
    
    head.method = @"saveRecord";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    saveToFileBody *body = [[saveToFileBody alloc]init];
    
    if (self.model.body) {
        
        body.id  = self.model.body;

    }else{
    
        body.id = self.resultModel.id;
        
    }
    
 
    SaveToFiles *request = [[SaveToFiles alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.saveAp saveToFile:request.mj_keyValues.mutableCopy];
    
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)consultAction{

    UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
    
    [UdeskManager setupCustomerOnline];
    
    //设置头像
    [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
    
    [manager pushUdeskInViewController:self completion:nil];
    //点击留言回调
    [manager leaveMessageButtonAction:^(UIViewController *viewController){
        
        UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
        [viewController presentViewController:offLineTicket animated:YES completion:nil];
        
    }];

    
}



@end
