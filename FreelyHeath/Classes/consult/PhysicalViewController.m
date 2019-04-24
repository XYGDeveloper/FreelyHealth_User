//
//  PhysicalViewController.m
//  FreelyHeath
//
//  Created by L on 2017/9/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhysicalViewController.h"
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
@interface PhysicalViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong)NSArray *arr;

@property (nonatomic,strong)GetBgApi *api;

@property (nonatomic,strong) MBProgressHUD  *HUD;

@end

@implementation PhysicalViewController

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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        PhysicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PhyicalModel *model = [self.arr objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:model];
        
        return cell;
        
    }else{
    
        PhysicalExerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhysicalExerTableViewCell class])];
        
        //套餐1
        cell.p1 = ^{
            
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
        cell.p2 = ^{
            
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
        cell.p3 = ^{
           
            PhyicalModel *model = [self.arr safeObjectAtIndex:2];
            
            GenDetailViewController *tijian = [GenDetailViewController new];
            
            tijian.isShare = YES;
            
            tijian.model = model;
            
            tijian.hidesBottomBarWhenPushed = YES;
            
            [tijian loadWebURLSring:model.url];
            
            tijian.title = model.name;
            
            [self.navigationController pushViewController:tijian animated:YES];
        };
        
        //套餐4
        cell.p4 = ^{
            
            PhyicalModel *model = [self.arr safeObjectAtIndex:3];
            
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
    
        return 236;
    
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        PhyicalModel *model = [self.arr objectAtIndex:indexPath.row];
        
        GenDetailViewController *tijian = [GenDetailViewController new];
        
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
    
    [self.tableview registerClass:[PhysicalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
    
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview registerNib:[UINib nibWithNibName:@"PhysicalExerTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PhysicalExerTableViewCell class])];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    GetBgHeader *head = [[GetBgHeader alloc]init];
    
    head.target = @"tjjyServeControl";
    
    head.method = @"getTijiansList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    GetBgBody *body = [[GetBgBody alloc]init];
    
    body.type = @"3";
    
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
