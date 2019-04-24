//
//  ConsultTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ConsultTableViewCell.h"
#import "CustomCollectionTableViewCell.h"
#import "TumorZoneListApi.h"
#import "TumorZoneRequest.h"
#import "TumorZoneListModel.h"
@interface ConsultTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ApiRequestDelegate>

@property (nonatomic,strong)NSMutableArray *listArray;

@property (nonatomic,strong)NSMutableArray *preArrayList;

@property (nonatomic,strong)TumorZoneListModel *model;

@property (nonatomic,strong)TumorZoneListApi *TumorZoneApi;

@end

@implementation ConsultTableViewCell



- (NSMutableArray *)listArray
{
    
    if (!_listArray) {
        
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
    
}

- (NSMutableArray *)preArrayList
{
    
    if (!_preArrayList) {
        
        _preArrayList = [NSMutableArray array];
    }
    
    return _preArrayList;
    
    
}

- (TumorZoneListApi *)TumorZoneApi{
    
    if (!_TumorZoneApi) {
        
        _TumorZoneApi = [[TumorZoneListApi alloc]init];
        
        _TumorZoneApi.delegate = self;
        
        
    }
    
    return _TumorZoneApi;
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    NSLog(@"9090909090-----------%@",responsObject);
    
    self.model = [TumorZoneListModel mj_objectWithKeyValues:responsObject];
    
    self.listArray = self.model.teams.mutableCopy;
    
    [self.collect reloadData];
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
}



- (UICollectionView *)collect
{
    
    if (!_collect) {
        
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layOut.minimumLineSpacing = 20;
        
        layOut.sectionInset=UIEdgeInsetsMake(5,20,5,20);
        
        layOut.minimumInteritemSpacing = 10;
        
        layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collect = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
        
        _collect.backgroundColor = [UIColor whiteColor];
        
        _collect.dataSource = self;
        
        _collect.delegate = self;
        
        _collect.showsHorizontalScrollIndicator = NO;
        
    }
    
    return _collect;
    
}


- (void)layOutsubview{
    
    [self.collect mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.collect];
        
        [self.collect registerClass:[CustomCollectionTableViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CustomCollectionTableViewCell class])];
        
        [self layOutsubview];
        
        TumorZoneHeader *head = [[TumorZoneHeader alloc]init];
        
        head.target = @"noTokenPrefectureControl";
        
        head.method = @"prefectureFirst";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        TumorZoneBody *body = [[TumorZoneBody alloc]init];
        
        body.id = @"1";
        
        TumorZoneRequest *request = [[TumorZoneRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.TumorZoneApi TumorZoneList:request.mj_keyValues.mutableCopy];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"re" object:nil];
    }
    return self;
}

- (void)refresh{
    
    TumorZoneHeader *head = [[TumorZoneHeader alloc]init];
    
    head.target = @"noTokenPrefectureControl";
    
    head.method = @"prefectureFirst";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    TumorZoneBody *body = [[TumorZoneBody alloc]init];
    
    body.id = @"1";
    
    TumorZoneRequest *request = [[TumorZoneRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.TumorZoneApi TumorZoneList:request.mj_keyValues.mutableCopy];

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(140,self.contentView.height);
    
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.listArray.count;
  
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustomCollectionTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CustomCollectionTableViewCell class]) forIndexPath:indexPath];
    
    TeamModel *model = [self.listArray objectAtIndex:indexPath.row];
    
    cell.machineImage.contentMode = UIViewContentModeScaleToFill;
    
    [cell.machineImage sd_setImageWithURL:[NSURL URLWithString:model.leaderfacepath] placeholderImage:[UIImage imageNamed:@"bingli_empty"]];
    
    cell.titleLabel.text = model.name;
    
//    cell.thumbsupCount.text = [NSString stringWithFormat:@"%@个赞",model.agreesnum];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeamModel *model = [self.listArray objectAtIndex:indexPath.row];

    [self.delegateColl ClickCooRow:indexPath.row teamModel:model];

}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}



@end
