//
//  ServiceViewController.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ServiceViewController.h"
#import "SDCollectionViewCell.h"
#import "PublicMoreModel.h"
@interface ServiceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *sdCollectionview;

@property (nonatomic,strong)NSMutableArray *commonArray;

@end

@implementation ServiceViewController

- (NSMutableArray *)commonArray
{
    
    if (!_commonArray) {
        
        _commonArray = [NSMutableArray array];
    }
    
    return _commonArray;
    
    
}


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

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
[self handleDateWithfileName:@"sdcenterindex" type:@"plist"];
    
    [self.view addSubview:self.sdCollectionview];
    
    [self.sdCollectionview registerClass:[SDCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SDCollectionViewCell class])];
    
    [self layOutsubview];

    // Do any additional setup after loading the view.
}


- (void)handleDateWithfileName:(NSString *)filename type:(NSString *)fileType{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:filename ofType:fileType];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSLog(@"-------%@",data);
    
    self.commonArray = [PublicMoreModel mj_objectArrayWithKeyValuesArray:[data objectForKey:@"morepublic"]];
    
}


- (void)layOutsubview{
    
    [self.sdCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.commonArray.count;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SDCollectionViewCell class]) forIndexPath:indexPath];
    
    PublicMoreModel *model = [self.commonArray objectAtIndex:indexPath.row];
    
    [cell refreshWithMorePublicModel:model];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
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
