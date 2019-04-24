//
//  PhysicalTp2ViewController.m
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhysicalTp2ViewController.h"
#import "PhysicalTableViewCell.h"
#import "PhysicalExerTableViewCell.h"
#import "PhyicalModel.h"
#import "WKWebViewController.h"
#import "GenDetailViewController.h"
#import "ScanBgViewController.h"
#import "PDFWebViewViewController.h"
#define PDF_URL @"https://www.tutorialspoint.com/ios/ios_tutorial.pdf"
#import "PDFWebViewViewController.h"
#import "Masonry.h"
#import "GetBgApi.h"
#import "GetBgRequest.h"
#import "WKWebViewController.h"
#import "GuideExTableViewCell.h"
@interface PhysicalTp2ViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,strong)GetBgApi *api;

@property (nonatomic,strong)MBProgressHUD *HUD;

@end

@implementation PhysicalTp2ViewController

- (UITableView *)tableview
{
    if (!_tableview) {
        
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-40) style:UITableViewStyleGrouped];
        _tableview.dataSource = self;
        _tableview.delegate  = self;
        _tableview.backgroundColor = [UIColor whiteColor];
        
    }
    return _tableview;
    
}

- (GetBgApi *)api
{
    if (!_api) {
        
        _api = [[GetBgApi alloc]init];
        _api.delegate = self;
    }
    
    return _api;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return self.arr.count;
    }else{
        
        return 1;
        
    }
    
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
    
    if (indexPath.section == 0) {
        
        PhysicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PhyicalModel *model = [self.arr objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:model];
        
        return cell;
        
    }else{
        
        GuideExTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GuideExTableViewCell class])];
        
        PhyicalModel *model = [self.arr safeObjectAtIndex:0];
        
        [cell.guideButton1 setTitle:model.name forState:UIControlStateNormal];
        
        PhyicalModel *model1 = [self.arr safeObjectAtIndex:1];
        
        [cell.guide2Button setTitle:model1.name forState:UIControlStateNormal];
        
        PhyicalModel *model2 = [self.arr safeObjectAtIndex:2];
        
        [cell.guide3Button setTitle:model2.name forState:UIControlStateNormal];
        
        //套餐1
        cell.guide1 = ^{
            
            PhyicalModel *model = [self.arr safeObjectAtIndex:0];
            
            GenDetailViewController *tijian = [GenDetailViewController new];
            
            tijian.isShare = YES;
            
            tijian.model = model;
            
            tijian.hidesBottomBarWhenPushed = YES;
            
            [tijian loadWebURLSring:model.url];
            
            tijian.title = model.name;
            
            [self.navigationController pushViewController:tijian animated:YES];
            
        };
        
        //套餐2
        cell.guide2 = ^{
            
            PhyicalModel *model = [self.arr safeObjectAtIndex:1];
            
            GenDetailViewController *tijian = [GenDetailViewController new];
            
            tijian.isShare = YES;
            
            tijian.model = model;
            
            tijian.hidesBottomBarWhenPushed = YES;
            
            [tijian loadWebURLSring:model.url];
            
            tijian.title = model.name;
            
            [self.navigationController pushViewController:tijian animated:YES];
            
        };
        
        //套餐3
        cell.guide3 = ^{
            
            PhyicalModel *model = [self.arr safeObjectAtIndex:2];
            
            GenDetailViewController *tijian = [GenDetailViewController new];
            
            tijian.isShare = YES;
            
            tijian.model = model;
            
            tijian.hidesBottomBarWhenPushed = YES;
            
            [tijian loadWebURLSring:model.url];
            
            tijian.title = model.name;
            
            [self.navigationController pushViewController:tijian animated:YES];
            
        };
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0){
        
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class]) cacheByIndexPath:indexPath configuration:^(PhysicalTableViewCell *cell) {
            
            PhyicalModel *model = [self.arr objectAtIndex:indexPath.row];
            
            [cell refreshWithModel:model];
            
        }];
        
    }else{
        
        return 190;
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        PhyicalModel *model = [self.arr objectAtIndex:indexPath.row];
        
        GenDetailViewController *tijian = [GenDetailViewController new];
        
        if (indexPath.row >0) {
            tijian.isOrder = YES;
        }

        tijian.isShare = YES;
        
        tijian.model = model;
        
        tijian.hidesBottomBarWhenPushed = YES;
        
        [tijian loadWebURLSring:model.url];
        
        tijian.title = model.name;
        
        [self.navigationController pushViewController:tijian animated:YES];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableview];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.tableview registerClass:[PhysicalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"GuideExTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GuideExTableViewCell class])];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GetBgHeader *head = [[GetBgHeader alloc]init];
    
    head.target = @"tjjyServeControl";
    
    head.method = @"getTijiansList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    GetBgBody *body = [[GetBgBody alloc]init];
    
    body.type = @"2";
    
    GetBgRequest *request = [[GetBgRequest alloc]init];
    request.head = head;
    request.body = body;
    [self.api getBgList:request.mj_keyValues.mutableCopy];
    
    //    NSBundle *bundle = [NSBundle mainBundle];
    //
    //    NSString *path = [bundle pathForResource:@"physicalList" ofType:@"plist"];
    //
    //    // 如果plist文件的根数据为字典
    //    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:path];
    //
    //    self.arr = [PhyicalModel mj_objectArrayWithKeyValuesArray:dict[@"physicals"]];
    
    [self.tableview reloadData];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    //    [self setRightNavigationItemWithTitle:@"查看报告" action:@selector(scanBg)];
    
    // Do any additional setup after loading the view from its nib.
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.HUD hideAnimated:YES];
    
    if (api == _api) {
        
        self.arr = [PhyicalModel mj_objectArrayWithKeyValuesArray:responsObject[@"services"]];
        
        [self.tableview reloadData];
        
    }
    
    //    PDFWebViewViewController *webViewVC = [[PDFWebViewViewController alloc] init];
    //
    //    webViewVC.his = @"1";
    //
    //    webViewVC.urlStr = [responsObject[@"imgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"%@",[responsObject[@"imgurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    //
    //    webViewVC.title = @"查看报告";
    //    [self.navigationController pushViewController:webViewVC animated:YES];
    
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
