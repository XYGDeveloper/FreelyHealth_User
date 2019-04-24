//
//  PhysicalTp1ViewController.m
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhysicalTp1ViewController.h"
#import "PhysicalTableViewCell.h"
#import "PhysicalExerTableViewCell.h"
#import "WKWebViewController.h"
#import "GenDetailViewController.h"
#import "ScanBgViewController.h"
#import "PDFWebViewViewController.h"
#define PDF_URL @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf"
#import "PDFWebViewViewController.h"
#import "Masonry.h"
#import "GetListNewRequest.h"
#import "GetSecondLiatApi.h"
#import "SecondModel.h"
#import "WKWebViewController.h"
#import "GuideExTableViewCell.h"
#import "TJServiceDetailViewController.h"
@interface PhysicalTp1ViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong) UITableView *tableview;

@property (nonatomic,strong)NSArray *arr;
@property (nonatomic,strong)GetSecondLiatApi *api;
@property (nonatomic,strong)SecondModel *model;
@property (nonatomic,strong) MBProgressHUD  *HUD;

@end

@implementation PhysicalTp1ViewController


- (UITableView *)tableview
{
    if (!_tableview) {
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40) style:UITableViewStyleGrouped];
        _tableview.dataSource =self;
        _tableview.delegate  =self;
        _tableview.backgroundColor = [UIColor whiteColor];
    }
    return _tableview;
    
}

- (GetSecondLiatApi *)api{
    if (!_api) {
        _api = [[GetSecondLiatApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
//    if (section == 0) {
    
        return self.arr.count;
//    }else{
//
//        return 1;
//
//    }
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    if (indexPath.section == 0) {
        
        PhysicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        serverModel *model = [self.arr objectAtIndex:indexPath.row];
        [cell refreshWithModel:model];
        
        return cell;
        
//    }else{
//
//        GuideExTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GuideExTableViewCell class])];
//
//        cell.guide3Button.hidden = YES;
//
//        cell.roow.hidden = YES;
//
//        serverModel *model0 = [self.arr safeObjectAtIndex:0];
//
//        [cell.guideButton1 setTitle:model0.name forState:UIControlStateNormal];
//
//        serverModel *model1 = [self.arr safeObjectAtIndex:1];
//
//        [cell.guide2Button setTitle:model1.name forState:UIControlStateNormal];
//
//        //套餐1
//        cell.guide1 = ^{
//
//            serverModel *model = [self.arr safeObjectAtIndex:0];
//
//            TJServiceDetailViewController *detail = [TJServiceDetailViewController new];
//            detail.title = model.name;
//            detail.id = model.id;
//            detail.zilist = self.model.zilist;
//            [self.navigationController pushViewController:detail animated:YES];
//
//        };
//
//        //套餐2
//        cell.guide2 = ^{
//
//            serverModel *model = [self.arr safeObjectAtIndex:1];
//            TJServiceDetailViewController *detail = [TJServiceDetailViewController new];
//            detail.title = model.name;
//            detail.id = model.id;
//            detail.zilist = self.model.zilist;
//            [self.navigationController pushViewController:detail animated:YES];
//
//        };
//        return cell;
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    if (indexPath.section == 0){
    
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class]) cacheByIndexPath:indexPath configuration:^(PhysicalTableViewCell *cell) {
            
            serverModel *model = [self.arr objectAtIndex:indexPath.row];
            
            [cell refreshWithModel:model];
            
        }];
//
//    }else{
//
//        return 190;
//
//
//    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        serverModel *model = [self.arr objectAtIndex:indexPath.row];
        TJServiceDetailViewController *detail = [TJServiceDetailViewController new];
        detail.title = model.name;
        detail.id = model.id;
        detail.zilist = self.model.zilist;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];
    
    self.view.backgroundColor =  [UIColor whiteColor];

    [self.tableview registerClass:[PhysicalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GuideExTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GuideExTableViewCell class])];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    SubNewHeader *head = [[SubNewHeader alloc]init];
    
    head.target = @"tjjyServeControl";
    
    head.method = @"getTcsListSecond";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    SubNewBody *body = [[SubNewBody alloc]init];
    body.id = self.id;
    GetListNewRequest *request = [[GetListNewRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api sublistDetail:request.mj_keyValues.mutableCopy];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.HUD hideAnimated:YES];
    
    if (api == _api) {
        self.model = responsObject;
        self.arr = [serverModel mj_objectArrayWithKeyValuesArray:self.model.services];
        [self.tableview reloadData];
    }
  
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.HUD hideAnimated:YES];
    [Utils postMessage:command.response.msg onView:self.view];
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
