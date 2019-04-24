//
//  TJSubMenuViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJSubMenuViewController.h"
#import "TJMenuCollectionViewCell.h"
#import "GetListNewRequest.h"
#import "GetSecondLiatApi.h"
#import "SecondModel.h"
#import "TJServiceDetailViewController.h"
@interface TJSubMenuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiRequestDelegate>
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)NSArray *sectionArray;
@property (nonatomic,strong)NSArray *rowArray;
@property (nonatomic,strong)GetSecondLiatApi *api;
@property (nonatomic,strong)SecondModel *model;

@end

@implementation TJSubMenuViewController

- (GetSecondLiatApi *)api{
    if (!_api) {
        _api = [[GetSecondLiatApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}
- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing= 1.5; //设置每一行的间距
        layout.minimumInteritemSpacing = 1.5;//item间距(最小值)
        layout.itemSize=CGSizeMake((kScreenWidth-4.5)/3, 96.5);  //设置每个单元格的大小
        //        layout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 46.5); //设置collectionView头视图的大小
        _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
        //注册cell单元格
        [_collection registerClass:[TJMenuCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TJMenuCollectionViewCell class])];
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
    self.title = @"影像单项";
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    //    [self setHeaderView];
    [self.view addSubview:self.collection];
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
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    self.model = responsObject;
    self.sectionArray = [serverModel mj_objectArrayWithKeyValuesArray:self.model.services];
    [self.collection reloadData];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.sectionArray.count;
}
#pragma markk 返回的单元格
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TJMenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJMenuCollectionViewCell class]) forIndexPath:indexPath];
    serverModel *model = [self.sectionArray objectAtIndex:indexPath.row];
    [cell refreshWithserverModel:model];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    serverModel *model = [self.sectionArray objectAtIndex:indexPath.row];
    TJServiceDetailViewController *detail = [TJServiceDetailViewController new];
    detail.title = model.name;
    detail.id = model.id;
    detail.zilist = self.model.zilist;
    [self.navigationController pushViewController:detail animated:YES];
    
}

@end
