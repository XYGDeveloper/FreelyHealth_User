//
//  WeightViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WeightViewController.h"
#import "IndexStyleTableViewCell.h"
#import "FirstWaves.h"
#import "SecondWaves.h"
#import "HIstoryIndexModel.h"
#import "IndexHistoryRequest.h"
#import "GetHIstoryIndexApi.h"
@interface WeightViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)FirstWaves *firstWare;

@property (nonatomic,strong)SecondWaves *secondWare;

@property (nonatomic,strong)UITableView *weightTableview;

@property (nonatomic,strong)NSMutableArray *weightArray;

@property (nonatomic,strong)UIButton *updateDate;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UILabel *weightLabel;

@property (nonatomic,strong)UILabel *dateStringLabel;

@property (nonatomic,strong)GetHIstoryIndexApi *api;

@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)HIstoryIndexModel *model;

@end

@implementation WeightViewController


- (GetHIstoryIndexApi *)api
{

    if (!_api) {
        
        _api = [[GetHIstoryIndexApi alloc]init];
        
        _api.delegate  =self;
        
    }
    
    return _api;
    

}


- (NSMutableArray *)listArr
{

    if (!_listArr) {
        
        _listArr = [NSMutableArray array];
        
    }
    
    return _listArr;
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    
    [self.weightTableview.mj_header endRefreshing];
    
    [LSProgressHUD hide];

    
    self.listArr  = responsObject;
    
    self.model = [self.listArr firstObject];
    
    [self.weightTableview reloadData];
    
    [self refreshHead];
    
    

}


- (void)refreshHead{

    self.weightLabel.text = [NSString stringWithFormat:@"%@%@",self.model.num,self.model.unit];

    self.dateStringLabel.text = self.model.createtime;

}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [self.weightTableview.mj_header endRefreshing];

    [LSProgressHUD hide];
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}


- (UITableView *)weightTableview
{

    if (!_weightTableview) {
        
        _weightTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _weightTableview.delegate  =self;
        
        _weightTableview.dataSource = self;
        
    }

    return _weightTableview;
    
}



- (void)setHeadView{

  
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    self.headView.backgroundColor = [UIColor whiteColor];
    //第一个波浪
    self.firstWare = [[FirstWaves alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    
    self.firstWare.alpha= 0.6;
    
    //第二个波浪
    self.secondWare = [[SecondWaves alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 250)];
    
    self.secondWare.alpha=0.9;
    
    [self.headView addSubview:self.firstWare];
    
    [self.headView addSubview:self.secondWare];

    self.weightLabel = [[UILabel alloc]init];
    
    self.weightLabel.font = Font(32);
    
    self.weightLabel.textColor = [UIColor whiteColor];
    
    self.weightLabel.textAlignment = NSTextAlignmentCenter;

    [self.secondWare addSubview:self.weightLabel];
    
    self.dateStringLabel = [[UILabel alloc]init];
    
    self.dateStringLabel.font = Font(16);
    
    self.dateStringLabel.textColor = [UIColor whiteColor];
    
    self.dateStringLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.secondWare addSubview:self.dateStringLabel];
    
    UILabel *historyLabel= [[UILabel alloc]init];
    
    historyLabel.font = Font(16);
    historyLabel.textAlignment = NSTextAlignmentCenter;
    historyLabel.text  =@"历史记录";
    historyLabel.textColor = DefaultGrayLightTextClor;
    
    [self.headView addSubview:historyLabel];
    
    [historyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headView.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-15);
    }];
    
    
  

}




- (void)layOutSubView{

  [self.weightTableview mas_makeConstraints:^(MASConstraintMaker *make) {
      
      make.top.left.right.bottom.mas_equalTo(0);
  }];
    
    
   [self.weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
       make.top.mas_equalTo(30);
       
       make.centerX.mas_equalTo(self.secondWare.mas_centerX);
       
       make.width.mas_equalTo(kScreenWidth);
       
       make.height.mas_equalTo(40);
   }];
   
    [self.dateStringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.weightLabel.mas_bottom);
        
        make.centerX.mas_equalTo(self.secondWare.mas_centerX);
        
        make.width.mas_equalTo(kScreenWidth);
        
        make.height.mas_equalTo(40);
    }];
    
    
    
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.weightTableview.backgroundColor = DefaultBackgroundColor;
    
    self.title = @"体重记录";
    [self setHeadView];

     [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self.view addSubview:self.weightTableview];
    
    [self.weightTableview registerNib:[UINib nibWithNibName:@"IndexStyleTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndexStyleTableViewCell class])];
    
    [self.view addSubview:self.updateDate];
    
    self.weightTableview.tableHeaderView  = self.headView;
    
    [self layOutSubView];
    
    [LSProgressHUD showWithMessage:nil];
    
    self.weightTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        IndexhistoryHeader*head = [[IndexhistoryHeader alloc]init];
        
        head.target = @"indexsControl";
        
        head.method = @"getIndexsDetail";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        IndexhistoryBody *body = [[IndexhistoryBody alloc]init];
        
        body.indexsid = self.ID;
        
        IndexHistoryRequest *request = [[IndexHistoryRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api gethistoryIndexList:request.mj_keyValues.mutableCopy];
        
    }];
    
    
    [self.weightTableview.mj_header beginRefreshing];

}

- (void)updateAction{

//


}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    IndexStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexStyleTableViewCell class])];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    HIstoryIndexModel *model = [self.listArr objectAtIndex:indexPath.row];
    
    [cell refreshWithModel:model];
    
    return cell;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    
}



@end
