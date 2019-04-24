//
//  HistoryViewController.m
//  FreelyHeath
//
//  Created by L on 2017/11/16.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//
#import "HistoryViewController.h"
#import "GetHistoryBgApi.h"
#import "GetHistoryBgRequest.h"
#import "PDFWebViewViewController.h"
#import "HistoryModel.h"
#import "HisBgTableViewCell.h"
@interface HistoryViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *historyTableBg;

@property (nonatomic,strong)NSMutableArray *listArr;

@property (nonatomic,strong)GetHistoryBgApi *api;

@end

@implementation HistoryViewController

- (GetHistoryBgApi *)api
{
    if (!_api) {
        _api = [[GetHistoryBgApi alloc]init];
        _api.delegate  = self;
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


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.historyTableBg.mj_header endRefreshing];
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.listArr.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.historyTableBg response:command.response operationBlock:^{
            strongify(self)
            [self.historyTableBg.mj_header beginRefreshing];
        }];
    }
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.historyTableBg.mj_header endRefreshing];
    
    NSLog(@"%@",self.listArr);
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.historyTableBg];
    NSArray *array = (NSArray *)responsObject;

    if (array.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.historyTableBg withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无历史报告" operationText:nil operationBlock:nil];
    } else {

        [self.listArr removeAllObjects];
        [self.listArr addObjectsFromArray:responsObject];

        [self.historyTableBg reloadData];

    }

    
}


- (UITableView *)historyTableBg
{
    if (!_historyTableBg) {
        
        _historyTableBg = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _historyTableBg.delegate  = self;
        
        _historyTableBg.dataSource = self;
        
        _historyTableBg.backgroundColor = DefaultBackgroundColor;

    }
    
    return _historyTableBg;
    
}

- (void)layoutSubview{
    
    [self.historyTableBg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.right.top.bottom.mas_equalTo(0);
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
      [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self.view addSubview:self.historyTableBg];
    
    [self layoutSubview];
    
    [self.historyTableBg registerClass:[HisBgTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HisBgTableViewCell class])];
    
    self.historyTableBg.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        GetHistoryHeader *head = [[GetHistoryHeader alloc]init];
        
        head.target = @"tjbgControl";
        
        head.method = @"getUserHistoryTjbg";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        GetHistoryBody *body = [[GetHistoryBody alloc]init];
        
        GetHistoryBgRequest *request = [[GetHistoryBgRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api getHistoryBgList:request.mj_keyValues.mutableCopy];
        
    }];
    
    [self.historyTableBg.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 73;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.listArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HisBgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HisBgTableViewCell class])];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    HistoryModel *model = [self.listArr objectAtIndex:indexPath.row];

    [cell refreshWithModel:model];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HistoryModel *model = [self.listArr objectAtIndex:indexPath.row];
    PDFWebViewViewController *webViewVC = [[PDFWebViewViewController alloc] init];
    webViewVC.urlStr = [model.imgurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    webViewVC.title = @"查看报告";
    [self.navigationController pushViewController:webViewVC animated:YES];
    
    
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
