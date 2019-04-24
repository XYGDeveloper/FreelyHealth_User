//
//  CityViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CityViewController.h"
#import "SelectAddressViewController.h"
#import "GetCityListApi.h"
#import "GetCityListRequest.h"
#import "CityListModel.h"
#import "JGTableViewController.h"
@interface CityViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *cityList;
@property (nonatomic,strong)GetCityListApi *api;
@end

@implementation CityViewController

- (GetCityListApi *)api{
    if (!_api) {
        _api = [[GetCityListApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    self.cityList = responsObject;
    [self.tableview reloadData];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [Utils postMessage:command.response.msg onView:self.view];
}
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = DefaultBackgroundColor;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    cHeader *cityhead = [[cHeader alloc]init];
    cityhead.target = @"tjjyServeControl";
    cityhead.method = @"getTaocanCityList";
    cityhead.versioncode = Versioncode;
    cityhead.devicenum = Devicenum;
    cityhead.fromtype = Fromtype;
    cityhead.token = [User LocalUser].token;
    cBody *citybody = [[cBody alloc]init];
    GetCityListRequest *cityrequest = [[GetCityListRequest alloc]init];
    cityrequest.head = cityhead;
    cityrequest.body = citybody;
    [self.api sublistDetail:cityrequest.mj_keyValues.mutableCopy];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.font = FontNameAndSize(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CityListModel *model = [self.cityList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CityListModel *model = [self.cityList objectAtIndex:indexPath.row];
    JGTableViewController *select = [[JGTableViewController alloc]initWithid:@"" cityid:model.id];
    [self.navigationController pushViewController:select animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
