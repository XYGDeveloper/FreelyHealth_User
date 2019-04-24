//
//  PopularDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PopularDetailViewController.h"
#import "PolularScienceTableViewCell.h"
#import "TumorZoneListModel.h"
#import "ScienDetailViewController.h"
#import "ConsultIndexModel.h"
#import "TumorZoneListApi.h"
#import "TumorZoneRequest.h"
#import "TumorZoneListModel.h"
@interface PopularDetailViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *ConsulttableView;

@property (nonatomic,strong)NSMutableArray *arrayList;

@property (nonatomic,strong)TumorZoneListModel *model;

@property (nonatomic,strong)TumorZoneListApi *TumorZoneApi;

@end

@implementation PopularDetailViewController


-(NSMutableArray *)arrayList
{

    if (!_arrayList) {
        
        _arrayList = [NSMutableArray array];
    }
    
    return _arrayList;

}


- (TumorZoneListApi *)TumorZoneApi{
    
    if (!_TumorZoneApi) {
        
        _TumorZoneApi = [[TumorZoneListApi alloc]init];
        
        _TumorZoneApi.delegate = self;
        
    }
    
    return _TumorZoneApi;
    
    
}


- (UITableView *)ConsulttableView
{
    
    if (!_ConsulttableView) {
        
        _ConsulttableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _ConsulttableView.delegate = self;
        
        _ConsulttableView.dataSource = self;
        
        _ConsulttableView.backgroundColor = DefaultBackgroundColor;
        
    }
    
    return _ConsulttableView;
    
}


- (void)layoutsubview{
    
    [self.ConsulttableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.ConsulttableView.mj_header endRefreshing];
    
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.ConsulttableView.mj_header endRefreshing];

    if (api == _TumorZoneApi) {
        
        self.model = [TumorZoneListModel mj_objectWithKeyValues:responsObject];
        
        self.arrayList = [infomationModel mj_objectArrayWithKeyValuesArray:self.model.informations];
        
        [self.ConsulttableView reloadData];
        
    }
    
    
}





- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.ConsulttableView];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
   [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    
    [self.ConsulttableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.ConsulttableView registerClass:[PolularScienceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PolularScienceTableViewCell class])];

    [self layoutsubview];
    
    self.ConsulttableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        TumorZoneHeader *head = [[TumorZoneHeader alloc]init];
        
        head.target = @"noTokenPrefectureControl";
        
        head.method = @"prefectureFirst";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        TumorZoneBody *body = [[TumorZoneBody alloc]init];
        
        body.id = @"1";
        
        TumorZoneRequest *request = [[TumorZoneRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.TumorZoneApi TumorZoneList:request.mj_keyValues.mutableCopy];
        
    }];
    
    [self.ConsulttableView.mj_header beginRefreshing];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            
            return 0.000001;
            
        }else{
            
            return 0;
            
        }
        
    } else {
        
        if (section == 0) {
            
            return CGFLOAT_MIN;
            
        }else{
            
            return 0;
            
        }
        
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (@available(iOS 11.0, *)) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
    } else {
        
        return nil;
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    return 112;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
  return  self.arrayList.count;
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PolularScienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PolularScienceTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.sep.hidden = YES;
    
    infomationModel *model = [self.arrayList objectAtIndex:indexPath.row];
    
    [cell refreshWithModel:model];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    infomationModel *model = [self.arrayList objectAtIndex:indexPath.row];

    ScienDetailViewController *ass = [ScienDetailViewController new];
    
    ass.model = model;
    
    [ass loadWebURLSring:model.url];
    
    ass.hidesBottomBarWhenPushed = YES;
    
    ass.title = @"科普详情";
    
    [self.navigationController pushViewController:ass animated:YES];
    
}




@end
