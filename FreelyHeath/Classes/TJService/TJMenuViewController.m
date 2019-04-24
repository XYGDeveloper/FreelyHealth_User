//
//  TJMenuViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TJMenuViewController.h"
#import "TJItemTableviewCell.h"
#import "TJServiceViewController.h"
#import "SubscribeListViewController.h"
#import "PDFWebViewViewController.h"
#import "NewModel.h"
#import "GetListNewRequest.h"
#import "GetSubNewApi.h"
#import "GenDetailViewController.h"
#import "PhyicalModel.h"
#import "PhysicalViewController.h"
#import "PhysicalTp1ViewController.h"
#import "PhysicalTp2ViewController.h"
#import "CityViewController.h"
#import "TJMenuCollectionViewCell.h"
#import "TJMenuHeaderCollectionReusableView.h"
#import "SectionCollectionReusableView.h"
#import "TJSubMenuViewController.h"
#import "TJServiceDetailViewController.h"
#import "PhysicalTp1ViewController.h"
#import "TJPackageViewController.h"
#import "TJFLViewController.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define LG_ButtonColor_Selected [UIColor redColor]
#define LG_ButtonColor_UnSelected [UIColor blackColor]
@interface TJMenuViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiRequestDelegate>
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *sectionTitle;
@property (nonatomic,strong)UICollectionView *collection;
@property (nonatomic,strong)NSArray *sectionArray;
@property (nonatomic,strong)NSArray *rowArray;
@property (nonatomic,strong)GetSubNewApi *api;
@property(assign,nonatomic) int index;
@property (nonatomic,strong)UIView *headView;


@end

@implementation TJMenuViewController

- (GetSubNewApi *)api{
    if (!_api) {
        _api = [[GetSubNewApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (UICollectionView *)collection{
    if (!_collection) {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing= 0.5; //设置每一行的间距
        layout.minimumInteritemSpacing = 0.5;//item间距(最小值)
        layout.itemSize=CGSizeMake((kScreenWidth-1.5)/3, 96.5);  //设置每个单元格的大小
//        layout.headerReferenceSize=CGSizeMake(self.view.frame.size.width, 46.5); //设置collectionView头视图的大小
        _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
        //注册cell单元格
        [_collection registerClass:[TJMenuCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TJMenuCollectionViewCell class])];
        //注册头视图
        [_collection registerClass:[TJMenuHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([TJMenuHeaderCollectionReusableView class])];
        [_collection registerClass:[SectionCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([SectionCollectionReusableView class])];
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
    self.title = @"体检服务";
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
//    [self setHeaderView];
    [self.view addSubview:self.collection];
//
    SubNewHeader *head = [[SubNewHeader alloc]init];
    
    head.target = @"tjjyServeControl";
    
    head.method = @"getTcsListFirst";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    SubNewBody *body = [[SubNewBody alloc]init];
    
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
    self.sectionArray = responsObject;
    [self.collection reloadData];
}

#pragma mark  返回多少行

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size;
    if (section == 0) {
        size = CGSizeMake(kScreenWidth, 120.5 + 46.5);
    }else{
        size = CGSizeMake(kScreenWidth, 46.5);
    }
    return size;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NewModel *model = [self.sectionArray objectAtIndex:section];
    self.rowArray = [ServiceModel mj_objectArrayWithKeyValuesArray:model.services];
    return self.rowArray.count;
}
#pragma markk 返回的单元格
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   TJMenuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TJMenuCollectionViewCell class]) forIndexPath:indexPath];
    NewModel *model0 = [self.sectionArray objectAtIndex:indexPath.section];
    self.rowArray = [ServiceModel mj_objectArrayWithKeyValuesArray:model0.services];
    ServiceModel *model = [self.rowArray objectAtIndex:indexPath.row];
    [cell refreshWithModel:model];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
     if (indexPath.section == 0) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            SectionCollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([SectionCollectionReusableView class]) forIndexPath:indexPath];
            NewModel *model0 = [self.sectionArray objectAtIndex:indexPath.section];
            header.textLabel.text = model0.name;
            header.jump = ^(NSInteger tagindex) {
                if (tagindex == 1000) {
                    TJPackageViewController *tjservice = [[TJPackageViewController alloc]init];
//                    tjservice.title = @"体检服务";
                    [self.navigationController pushViewController:tjservice animated:YES];
                }else if (tagindex == 1001){
                    if ([Utils showLoginPageIfNeeded]) {
                        
                    } else {
                        SubscribeListViewController *tosubs = [[SubscribeListViewController alloc]init];
                        [self.navigationController pushViewController:tosubs animated:YES];
                    }
                }else if (tagindex == 1002){
                    if ([Utils showLoginPageIfNeeded]) {
                        
                    } else {
                        TJFLViewController *webViewVC = [[TJFLViewController alloc] init];
                        webViewVC.title = @"查看报告";
                        [self.navigationController pushViewController:webViewVC animated:YES];
                    }
                   
                }else{
                  
                        CityViewController *city = [CityViewController new];
                        city.title = @"选择城市";
                        [self.navigationController pushViewController:city animated:YES];
                   
                }
            };
            return header;
        }
    }else{
        //如果是头视图
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            TJMenuHeaderCollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([TJMenuHeaderCollectionReusableView class]) forIndexPath:indexPath];
            NewModel *model0 = [self.sectionArray objectAtIndex:indexPath.section];
            header.textLabel.text = model0.name;
            header.backgroundColor = [UIColor blueColor];
            if (indexPath.section == 0) {
                header.backgroundColor = RGB(88, 168, 238);
            }else if (indexPath.section == 1){
                header.backgroundColor = RGB(29, 229, 188);
            }else{
                header.backgroundColor = RGB(43, 204, 226);
            }
            return header;
        }
    }
  
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewModel *model0 = [self.sectionArray objectAtIndex:indexPath.section];
    self.rowArray = [ServiceModel mj_objectArrayWithKeyValuesArray:model0.services];
    ServiceModel *model = [self.rowArray objectAtIndex:indexPath.row];
    
    if (indexPath.section == 3) {
        TJSubMenuViewController *subMenu = [TJSubMenuViewController new];
        subMenu.id = model.id;
        [self.navigationController pushViewController:subMenu animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 3){
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        physical.id = model.id;
        physical.hidesBottomBarWhenPushed = YES;
        physical.title  = model.name;
        [self.navigationController pushViewController:physical animated:YES];
        
    }else if (indexPath.section == 2 && indexPath.row == 4){
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        physical.id = model.id;
        physical.hidesBottomBarWhenPushed = YES;
        physical.title  = model.name;
        [self.navigationController pushViewController:physical animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 5){
        PhysicalTp1ViewController *physical = [PhysicalTp1ViewController new];
        physical.id = model.id;
        physical.hidesBottomBarWhenPushed = YES;
        physical.title  = model.name;
        [self.navigationController pushViewController:physical animated:YES];
    }else{
        TJServiceDetailViewController *detail = [TJServiceDetailViewController new];
        detail.title = model.name;
        detail.id = model.id;
        detail.zilist = model.zilist;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

-(void)btnClick:(UIButton *)Btn{
    Btn.selected = !Btn.selected;
    if (Btn.tag == 1000) {
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            TJPackageViewController *tjservice = [[TJPackageViewController alloc]init];
            [self.navigationController pushViewController:tjservice animated:YES];
        }
    }else if (Btn.tag == 1001){
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            SubscribeListViewController *tosubs = [[SubscribeListViewController alloc]init];
            [self.navigationController pushViewController:tosubs animated:YES];
        }
    }else if (Btn.tag == 1002){
        if ([Udesk_WHC_HttpManager shared].networkStatus == NotReachable) {
            [Utils postMessage:@"网络连接已断开" onView:self.view];
        }else{
            TJFLViewController *webViewVC = [[TJFLViewController alloc] init];
            webViewVC.title = @"查看报告";
            [self.navigationController pushViewController:webViewVC animated:YES];
        }
    }else{
        CityViewController *city = [CityViewController new];
        city.title = @"选择城市";
        [self.navigationController pushViewController:city animated:YES];
    }
    
}

- (UIView *)headView{
    if (!_headView) {
        _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _headView.backgroundColor= DefaultBackgroundColor;
        NSArray * btnArray=@[@"体检套餐",@"体检预约",@"报告查看",@"体检机构"];
        for (int i=0; i<btnArray.count; i++) {
            UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(ScreenWidth/4*i, 0, ScreenWidth/4, 40);
            btn.titleLabel.font= FontNameAndSize(16);
            [btn setTitle:btnArray[i] forState:UIControlStateNormal];
            //没有选中的颜色
            [btn setTitleColor: DefaultBlackLightTextClor forState:UIControlStateNormal];
            //点击事件
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=1000+i;
            [_headView addSubview:btn];
        }
    }
    return _headView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint translation = scrollView.contentOffset;
    NSLog(@"%f",translation.y);
    
    if (translation.y< 120) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.headView removeFromSuperview];
        }];
    }else if(translation.y> 120){
        [self.view addSubview:self.headView];
    }
   
}

@end
