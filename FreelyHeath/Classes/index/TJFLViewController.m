//
//  TJFLViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJFLViewController.h"
#import "CKBGTableViewCell.h"
#import "PDFWebViewViewController.h"
#import "NationInsureViewController.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
@interface TJFLViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)UIButton *customerButton;

@end

@implementation TJFLViewController

- (UIButton *)customerButton{
    if (!_customerButton) {
        _customerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _customerButton.backgroundColor = AppStyleColor;
        _customerButton.titleLabel.font = FontNameAndSize(18);
        [_customerButton setTitle:@"报告解读" forState:UIControlStateNormal];
        [_customerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _customerButton;
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableview;
}

- (void)layOutSubview{
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NationInsureViewController *nation = [NationInsureViewController new];
        [nation loadWebURLSring:AiKang_URL];
        nation.title = @"爱康国宾体检中心";
        nation.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:nation animated:YES];
        
    }else{
        PDFWebViewViewController *webViewVC = [[PDFWebViewViewController alloc] init];
        webViewVC.his = @"1";
        webViewVC.title = @"森茂国际体检中心";
        [self.navigationController pushViewController:webViewVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CKBGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CKBGTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *imgs = @[@"akgb",@"sm"];
    NSArray *titles = @[@"爱康国宾体检中心",@"森茂国际体检中心"];
    cell.img.image = [UIImage imageNamed:imgs[indexPath.row]];
    cell.titleLabel.text = titles[indexPath.row];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerClass:[CKBGTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CKBGTableViewCell class])];
    [self.view addSubview:self.tableview];
    [self layOutSubview];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.customerButton];
    [self.customerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.customerButton addTarget:self action:@selector(toCustomer) forControlEvents:UIControlEventTouchUpInside];

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

- (void)toCustomer{
    
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
