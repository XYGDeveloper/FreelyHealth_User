//
//  TJServiceDetailViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJServiceDetailViewController.h"
#import "TJDetailCollectionViewCell.h"
#import "GetListNewRequest.h"
#import "TJServerDetailModel.h"
#import "TJServerDetailApi.h"
#import "UIImage+GradientColor.h"
#import "UdeskSDKManager.h"
#import "UdeskTicketViewController.h"
#import "MedicalFillOrderViewController.h"
#import "IMGModel.h"
@interface TJServiceDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiRequestDelegate>
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)NSMutableArray *sectionArray;
@property (nonatomic,strong)TJServerDetailApi *api;
@property (nonatomic,strong)TJServerDetailModel *model;
@property (nonatomic,strong)UIButton *sendButton;
@property (nonatomic,strong)UIButton *payButton;

@end

@implementation TJServiceDetailViewController

- (TJServerDetailApi *)api{
    if (!_api) {
        _api = [[TJServerDetailApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (UIButton *)sendButton{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.backgroundColor = AppStyleColor;
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
        UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
        UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
        [_sendButton setBackgroundImage:bgImg forState:UIControlStateNormal];
        [_sendButton setTitle:@"提交订单" forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (UIButton *)payButton{
    if (!_payButton) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.backgroundColor = [UIColor whiteColor];
        [_payButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [_payButton setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
        [_payButton setTitle:@"    联系客服" forState:UIControlStateNormal];
    }
    return _payButton;
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    [self.collection.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.model = responsObject;
    [[EmptyManager sharedManager] removeEmptyFromView:self.collection];
    NSArray *imageArr = [imgModel mj_objectArrayWithKeyValuesArray:self.model.imageurls];
    
    if (imageArr.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.collection withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"页面暂时无内容" operationText:nil operationBlock:nil];
    } else {
        self.sectionArray = [NSMutableArray array];
        for (imgModel *model1 in imageArr) {
            IMGModel *model = [IMGModel new];
            model.url = model1.url;
            model.width = model1.W > kScreenWidth  ? kScreenWidth : model1.W;
            model.height = model1.W > kScreenWidth? kScreenWidth *model1.H / model1.W:model1.H;
            [self.sectionArray addObject:model];
        }
        [self.collection reloadData];
    }
    
    if ([self.model.pay isEqualToString:@"1"]) {
        [self.view addSubview:self.sendButton];
        [self.sendButton addTarget:self action:@selector(topay) forControlEvents:UIControlEventTouchUpInside];
        [self.payButton addTarget:self action:@selector(tochat) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.payButton];
        [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
        [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(self.payButton.mas_right);
            make.height.mas_equalTo(self.payButton.mas_height);
            make.bottom.mas_equalTo(0);
        }];
    }else{
        [self.payButton addTarget:self action:@selector(tochat) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.payButton];
        [self.payButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        [self.payButton setImage:[UIImage imageNamed:@"service"] forState:UIControlStateNormal];
        [self.payButton setTitle:@"    联系客服" forState:UIControlStateNormal];
        [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(kScreenWidth);
        }];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [self.collection.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [Utils postMessage:command.response.msg onView:self.view];
    
    if (self.sectionArray.count <= 0) {
        weakify(self)
        [[EmptyManager sharedManager] showNetErrorOnView:self.collection response:command.response operationBlock:^{
            strongify(self)
            [self.collection.mj_header beginRefreshing];
        }];
    }
    
}

- (void)tochat{
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
        //设置头像
        [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
        [manager pushUdeskInViewController:self completion:nil];
        //点击留言回调
        [manager leaveMessageButtonAction:^(UIViewController *viewController){
            [UdeskManager getCustomerFields:^(id responseObject, NSError *error) {
                NSLog(@"客服用户自定义字段：%@",responseObject);
            }];
            UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
            [viewController presentViewController:offLineTicket animated:YES completion:nil];
        }];
    }
   
}

- (void)topay{
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
        MedicalFillOrderViewController *fill = [MedicalFillOrderViewController new];
        fill.id = self.model.id;
        fill.name = self.model.name;
        fill.zilist = self.model.zilist;
        [self.navigationController pushViewController:fill animated:YES];
    }
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing= 0; //设置每一行的间距
        layout.minimumInteritemSpacing = 0;//item间距(最小值)
        _collection=[[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        //注册cell单元格
        [_collection registerClass:[TJDetailCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TJDetailCollectionViewCell class])];
        //注册头视图
        _collection.backgroundColor= DefaultBackgroundColor;
        _collection.delegate=self;
        _collection.dataSource=self;
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
    }
    return _collection;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    //    [self setHeaderView];
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];

    self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在加载中...";
        SubNewHeader *head = [[SubNewHeader alloc]init];
        
        head.target = @"tjjyServeControl";
        
        head.method = @"getTcsListThird";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        SubNewBody *body = [[SubNewBody alloc]init];
        body.id = self.id;
        body.zilist = self.zilist;
        GetListNewRequest *request = [[GetListNewRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api sublistDetail:request.mj_keyValues.mutableCopy];
        
    }];
    [self.collection.mj_header beginRefreshing];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    IMGModel *model = [self.sectionArray objectAtIndex:indexPath.row];
    return CGSizeMake(model.width, model.height);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sectionArray.count;
}
#pragma markk 返回的单元格
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJDetailCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJDetailCollectionViewCell class]) forIndexPath:indexPath];
    imgModel *model = [self.sectionArray objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

@end
