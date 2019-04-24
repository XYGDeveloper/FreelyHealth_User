//
//  PhysicalExaminationViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhysicalExaminationViewController.h"
#import "SDCollectionViewCell.h"
#import "PublicServiceApi.h"
#import "PublicServiceListRequest.h"
#import "WKWebViewController.h"
#import "PublicServiceModel.h"
@interface PhysicalExaminationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiRequestDelegate>

@property (nonatomic,strong)UICollectionView *sdCollectionview;
@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,strong)PublicServiceApi *publicApi;

@end

@implementation PhysicalExaminationViewController

- (UICollectionView *)sdCollectionview
{
    
    if (!_sdCollectionview) {
        
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        
        layOut.itemSize = CGSizeMake((kScreenWidth- 60)/2, 125.0f);
        
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layOut.minimumLineSpacing = 20;
        
        layOut.sectionInset=UIEdgeInsetsMake(10,20,10, 20);
        
        layOut.minimumInteritemSpacing = 10;
        
        _sdCollectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
        
        _sdCollectionview.backgroundColor = DefaultBackgroundColor;
        
        _sdCollectionview.dataSource = self;
        
        _sdCollectionview.delegate = self;
        
    }
    
    return _sdCollectionview;
    
}


- (NSMutableArray *)listArray
{
    
    if (!_listArray) {
        
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
    
}

- (PublicServiceApi *)publicApi{
    
    if (!_publicApi) {
        
        _publicApi = [[PublicServiceApi alloc]init];
        
        _publicApi.delegate = self;
        
        
    }
    
    return _publicApi;
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    

    [LSProgressHUD hide];
    
    [Utils postMessage:command.response.msg onView:self.view];

    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    
    [LSProgressHUD hide];

    
//    [Utils postMessage:command.response.msg onView:self.view];

    self.listArray = responsObject;
    
    [self.sdCollectionview reloadData];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.sdCollectionview];
    
    [self.sdCollectionview registerClass:[SDCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SDCollectionViewCell class])];
    
    [self layOutsubview];
    
    [LSProgressHUD showWithMessage:nil];
    
    
    PublicServiceListRequestHeader *head = [[PublicServiceListRequestHeader alloc]init];
    
    head.target = @"noTokenPublicServeControl";
    
    head.method = @"getPublicServeList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    PublicServiceListRequestBody *body = [[PublicServiceListRequestBody alloc]init];
    
    body.type = @"1";
    
    PublicServiceListRequest *request = [[PublicServiceListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.publicApi getPublicUrl:request.mj_keyValues.mutableCopy];
    
    // Do any additional setup after loading the view.
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)layOutsubview{
    
    [self.sdCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    

   return CGSizeMake(0, 0);
   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        
  return CGSizeMake((kScreenWidth- 60)/2, 125.0f);
  
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.listArray.count;
    
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SDCollectionViewCell class]) forIndexPath:indexPath];
    
         PublicServiceModel *model = [self.listArray objectAtIndex:indexPath.row];
    
        [cell refreshWithMorePublicModel:model];

        return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PublicServiceModel *model = [self.listArray objectAtIndex:indexPath.row];

   
    WKWebViewController *ass = [WKWebViewController new];
    
    [ass loadWebURLSring:model.url];
    
    //        ass.hidesBottomBarWhenPushed = YES;
    
    ass.title = model.project;
    
    [self.navigationController pushViewController:ass animated:YES];
    
    
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
