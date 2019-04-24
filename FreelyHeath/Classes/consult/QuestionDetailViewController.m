//
//  QuestionDetailViewController.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QuestionDetailViewController.h"
#import "QuestionDetailTableViewCell.h"
#import "AuswerDetailApi.h"
#import "AuswerDetailRequest.h"
#import "User.h"
#import "QAHomeListModel.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "ThumpApi.h"
#import "ThumpRequest.h"
#import "AuswerDetailModel.h"
@interface QuestionDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *searchTableView;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)AuswerDetailApi *detailApi;

@property (nonatomic,strong)NSMutableArray *detailArray;

@property (nonatomic,strong)ThumpApi *thumpApi;


@end

@implementation QuestionDetailViewController


- (ThumpApi *)thumpApi
{
    
    if (!_thumpApi) {
        _thumpApi = [[ThumpApi alloc]init];
        
        _thumpApi.delegate  =self;
        
    }
    
    return _thumpApi;
    
    
}

- (AuswerDetailApi *)detailApi
{

    if (!_detailApi) {
        
        _detailApi = [[AuswerDetailApi alloc]init];
        
        _detailApi.delegate = self;
        
    }
    
    return _detailApi;
    

}


- (NSMutableArray *)detailArray
{

    if (!_detailArray) {
        
        _detailArray = [NSMutableArray array];
    }

    return _detailArray;
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    
    [self.searchTableView.mj_header endRefreshing];

    if (api == _detailApi) {
        
        self.detailArray = [AuswerDetailModel mj_objectArrayWithKeyValuesArray:responsObject[@"answers"]];
        
        [self.searchTableView reloadData];
        
    }
    
    if (api == _thumpApi) {
        
        [Utils postMessage:@"点赞成功" onView:self.view];
        
        DetailRequestHeader *head = [[DetailRequestHeader alloc]init];
        
        head.target = @"noTokenForumControl";
        
        head.method = @"detailPage";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        DetailRequestBody *body = [[DetailRequestBody alloc]init];
        
        body.id = self.aid;
        
        AuswerDetailRequest *request = [[AuswerDetailRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"aid:-------%@",self.aid);
        
        NSLog(@"ppp%@",request.mj_keyValues.mutableCopy);
        
        [self.detailApi auswerDetail:request.mj_keyValues.mutableCopy];
    
        
    }

    
       
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    
    [self.searchTableView.mj_header endRefreshing];
    
    
    if (api == _thumpApi) {
        
        if ([command.response.code isEqualToString:@"30005"]) {
            
            [Utils postMessage:command.response.msg onView:self.view];
            
            
        }
        
        
    }

    
}


- (UITableView *)searchTableView
{
    
    if (!_searchTableView) {
        
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _searchTableView.delegate = self;
        
        _searchTableView.dataSource = self;
        
        _searchTableView.backgroundColor = DefaultBackgroundColor;
        
    }
    
    return _searchTableView;
    
}

- (void)layOutsubview{
    
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
[self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,60)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    
    UITextView *headLabel = [[UITextView alloc]init];
    
    headLabel.editable = NO;
    
    headLabel.scrollEnabled = NO;
    
    headLabel.userInteractionEnabled = NO;
    
    headLabel.textAlignment = NSTextAlignmentLeft;
    
    headLabel.textColor = DefaultGrayTextClor;
    
    headLabel.font = Font(16);
    
    headLabel.text = self.question;
    
    [self.headView addSubview:headLabel];
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(5);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    
    lineView.backgroundColor = DefaultBackgroundColor;
    [self.headView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(headLabel.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];

    [self.view addSubview:self.searchTableView];
    
    self.searchTableView.tableHeaderView = self.headView;
    
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self layOutsubview];
    
    [self.searchTableView registerClass:[QuestionDetailTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QuestionDetailTableViewCell class])];
  
    
    self.searchTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        DetailRequestHeader *head = [[DetailRequestHeader alloc]init];
        
        head.target = @"noTokenForumControl";
        
        head.method = @"detailPage";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        DetailRequestBody *body = [[DetailRequestBody alloc]init];
        
        body.id = self.aid;
        
        AuswerDetailRequest *request = [[AuswerDetailRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"aid:-------%@",self.aid);
        
        NSLog(@"ppp%@",request.mj_keyValues.mutableCopy);
        
        [self.detailApi auswerDetail:request.mj_keyValues.mutableCopy];
        
        
    }];
    
    
    [self.searchTableView.mj_header beginRefreshing];


    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.detailArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [QuestionDetailTableViewCell whc_CellHeightForIndexPath:indexPath tableView:tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        QuestionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionDetailTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        AuswerDetailModel *model = [self.detailArray objectAtIndex:indexPath.row];

    cell.thump = ^(){
        
        thumpHeader *head = [[thumpHeader alloc]init];
        
        head.target = @"forumControl";
        
        head.method = @"userAgree";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        thumpBody *body = [[thumpBody alloc]init];
        
        body.id = model.answerid;
        
        ThumpRequest *request = [[ThumpRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"ppp%@",request.mj_keyValues.mutableCopy);
        
        [self.thumpApi toThump:request.mj_keyValues.mutableCopy];
        
        
    };

    
        [cell refreshWiothModel:model];
    
        return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
