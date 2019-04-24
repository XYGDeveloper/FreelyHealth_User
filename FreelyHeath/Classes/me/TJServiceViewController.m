//
//  TJServiceViewController.m
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJServiceViewController.h"
#import "TjServiceTableViewCell.h"
#import "TJListModel.h"
#import "GetTjListApi.h"
#import "GetTJListRequest.h"
#import "PhysicalViewController.h"
#import "PhysicalTp1ViewController.h"
#import "PhysicalTp2ViewController.h"
@interface TJServiceViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *tjTableview;

@property (nonatomic,strong)NSArray *tjArray;

@property (nonatomic,strong)GetTjListApi *api;

@end

@implementation TJServiceViewController

- (GetTjListApi *)api
{
    if (!_api) {
        
        _api = [[GetTjListApi alloc]init];
        _api.delegate = self;
    }
    
    return _api;
    
}

- (UITableView *)tjTableview
{
    
    if (!_tjTableview) {
        
        _tjTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tjTableview.delegate = self;
        _tjTableview.dataSource  =self;
        _tjTableview.backgroundColor = self.view.backgroundColor;
        _tjTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _tjTableview;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    [self.view addSubview:self.tjTableview];
    
    [self.tjTableview registerClass:[TjServiceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TjServiceTableViewCell class])];
    
    tjHeader *head = [[tjHeader alloc]init];
    
    head.target = @"tjjyServeControl";
    
    head.method = @"getTjsList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    tjBody *body = [[tjBody alloc]init];
    
    GetTJListRequest *request = [[GetTJListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api gettjList:request.mj_keyValues.mutableCopy];
    
    // Do any additional setup after loading the view.
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    NSLog(@"%@",responsObject);
    self.tjArray = responsObject;
    [self.tjTableview reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tjArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TjServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TjServiceTableViewCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    NSArray *icons = @[@"tj_01",@"tj_02",@"tj_03"];
//
//    cell.leftView.image = [UIImage imageNamed:icons[indexPath.row]];
    
    TJListModel *model = [self.tjArray objectAtIndex:indexPath.row];
    
    [cell refdreshWith:model];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        
        physical.hidesBottomBarWhenPushed = YES;
        
        physical.title  =@"国际VIP系列体检服务";
        
        [self.navigationController pushViewController:physical animated:YES];
        
    }else if (indexPath.row == 1){
        
        PhysicalTp2ViewController *physical = [PhysicalTp2ViewController new];
        
        physical.hidesBottomBarWhenPushed = YES;
        
        physical.title  =@"尊享体检系列服务";
        
        [self.navigationController pushViewController:physical animated:YES];
        
    }else{
        
        PhysicalViewController *physical = [PhysicalViewController new];
        
        physical.hidesBottomBarWhenPushed = YES;
        
        physical.title  =@"企业团检系列服务";
        
        [self.navigationController pushViewController:physical animated:YES];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 377/2;
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
        
    }else {
        return nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
