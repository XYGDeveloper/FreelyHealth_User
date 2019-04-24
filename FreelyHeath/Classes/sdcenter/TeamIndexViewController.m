//
//  TeamIndexViewController.m
//  MedicineClient
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TeamIndexViewController.h"
#import "ZspMenu.h"
#import "ExperTeamTableViewCell.h"
#import "TeamExpertViewController.h"
#import "ExpertConsultViewController.h"
#import "teamQuaryApi.h"
#import "TeamQueryRequest.h"
#import "AllTeamModel.h"
#import "TeamListModel.h"
#import "QuaryTeamRequest.h"
#import "AllQuaryApi.h"
#import "MemberTableViewCell.h"
#import "TeamDetailViewController.h"
@interface TeamIndexViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UITableView * teamTableView;

@property (nonatomic,strong)UICollectionView *collection;


@property (nonatomic,strong)NSMutableArray * listArray;

@property (nonatomic,assign)NSInteger * section;

//获取团队信息

@property (nonatomic,strong)teamQuaryApi *teamApi;

//全部城市

@property (nonatomic,strong)NSMutableArray *allCityies;

@property (nonatomic,strong)NSMutableArray *cities;

@property (nonatomic,strong)AllTeamModel *model;

@property (nonatomic,strong)allCityModel *citymodel;

@property (nonatomic,strong)NSMutableArray *city0;
@property (nonatomic,strong)NSMutableArray *city1;
@property (nonatomic,strong)NSMutableArray *city2;
@property (nonatomic,strong)NSMutableArray *city3;
@property (nonatomic,strong)NSMutableArray *city4;
@property (nonatomic,strong)NSMutableArray *city5;
@property (nonatomic,strong)NSMutableArray *city6;
@property (nonatomic,strong)NSMutableArray *city7;
@property (nonatomic,strong)NSMutableArray *city8;

@property (nonatomic,strong)NSMutableArray *departments;

//获取团队信息

@property (nonatomic,strong)AllQuaryApi *QueryListApi;

@property (nonatomic,strong)NSMutableArray * teamListArray;

@property (nonatomic,strong)NSMutableArray * memberListArray;

@property (nonatomic,strong)UIButton * tableViewHeaderView;

@property (nonatomic,strong)UIButton * tableViewFooterView;

@end

@implementation TeamIndexViewController

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
    

}

- (NSMutableArray *)allCityies
{
    
    if (!_allCityies) {
        
        _allCityies = [NSMutableArray array];
    }
    
    return _allCityies;
    
}

- (NSMutableArray *)cities
{
    
    if (!_cities) {
        
        _cities = [NSMutableArray array];
    }
    
    return _cities;
    
}

- (NSMutableArray *)city0
{
    
    if (!_city0) {
        
        _city0 = [NSMutableArray array];
    }
    
    return _city0;
    
}

- (NSMutableArray *)city1
{
    
    if (!_city1) {
        
        _city1 = [NSMutableArray array];
    }
    
    return _city1;
    
}

- (NSMutableArray *)city2
{
    
    if (!_city2) {
        
        _city2 = [NSMutableArray array];
    }
    
    return _city2;
    
}

- (NSMutableArray *)city3
{
    
    if (!_city3) {
        
        _city3 = [NSMutableArray array];
    }
    
    return _city3;
    
}

- (NSMutableArray *)city4
{
    
    if (!_city4) {
        
        _city4 = [NSMutableArray array];
    }
    
    return _city4;
    
}

- (NSMutableArray *)city5
{
    
    if (!_city5) {
        
        _city5 = [NSMutableArray array];
    }
    
    return _city5;
    
}

- (NSMutableArray *)city6
{
    
    if (!_city6) {
        
        _city6 = [NSMutableArray array];
    }
    
    return _city6;
    
}

- (NSMutableArray *)city7
{
    
    if (!_city7) {
        
        _city7 = [NSMutableArray array];
    }
    
    return _city7;
    
}

- (NSMutableArray *)city8
{
    
    if (!_city8) {
        
        _city8 = [NSMutableArray array];
    }
    
    return _city8;
    
}

- (NSMutableArray *)departments
{
    
    if (!_departments) {
        
        _departments = [NSMutableArray array];
    }
    
    return _departments;
    
}

- (AllQuaryApi *)QueryListApi
{
    
    if (!_QueryListApi) {
        
        _QueryListApi = [[AllQuaryApi alloc]init];
        
        _QueryListApi.delegate  = self;
        
    }
    
    return _QueryListApi;
    
}


- (teamQuaryApi *)teamApi
{
    
    if (!_teamApi) {
        
        _teamApi = [[teamQuaryApi alloc]init];
        
        _teamApi.delegate  =self;
        
    }
    return _teamApi;
    
    
}


- (NSMutableArray *)teamListArray
{
    
    if (!_teamListArray) {
        
        _teamListArray = [NSMutableArray array];
    }
    
    return _teamListArray;
    
}

- (NSMutableArray *)memberListArray
{
    
    if (!_memberListArray) {
        
        _memberListArray = [NSMutableArray array];
    }
    
    return _memberListArray;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [LSProgressHUD hide];
    
    [self.collection.mj_header endRefreshing];
    
    if (api == _QueryListApi) {

        if (self.teamListArray.count <= 0) {
            
//            [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:^{
//
//                [self.teamTableView.mj_header beginRefreshing];
//
//            }];
            
        }
        
    }
    
    if (api == _teamApi) {
        
        [[EmptyManager sharedManager] showNetErrorOnView:self.view response:command.response operationBlock:^{
            
           [self.collection.mj_header beginRefreshing];

        }];
    }
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    [self.collection.mj_header endRefreshing];
    
    if (api == _teamApi) {

        self.model = responsObject;
        
        self.allCityies = [allCityModel mj_objectArrayWithKeyValuesArray:self.model.citys];
    
        //获得城市列表
        for (allCityModel *model in self.allCityies) {
            
            [self.cities safeAddObject:model.name];
            
            NSLog(@"%@",self.cities);
            
            if ([model.id isEqualToString:@"0"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city0 addObject:model.name];
                    
                }
                
            }
            
            if ([model.id isEqualToString:@"1"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city1 addObject:model.name];
                    
                }
                
                
            }
            
            if ([model.id isEqualToString:@"2"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city2 addObject:model.name];
                    
                }
                
            }
            
            if ([model.id isEqualToString:@"3"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city3 addObject:model.name];
                    
                }
                
            }
            
            
            if ([model.id isEqualToString:@"4"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city4 addObject:model.name];
                    
                }
                
            }
            
            if ([model.id isEqualToString:@"5"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city5 addObject:model.name];
                    
                }
                
                
            }
            
            if ([model.id isEqualToString:@"6"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city6 addObject:model.name];
                    
                }
                
                
            }
            
            if ([model.id isEqualToString:@"7"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city7 addObject:model.name];
                    
                }
                
            }
            
            if ([model.id isEqualToString:@"8"]) {
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
                
                for (memberModel *model in memeber) {
                    
                    [self.city8 addObject:model.name];
                    
                }
                
            }
            
        }
        
        
        NSArray *departList = [departModel mj_objectArrayWithKeyValuesArray:self.model.departments];
        
        NSLog(@"%@",departList);
        
        for (departModel *depart in departList) {
            
            [self.departments addObject:depart.name];
            
            NSLog(@"%@",self.departments);
            
        }
        
        self.choose = @[@"筛选", @"知名度", @"热度", @"医院等级"];
        
        _menu = [[ZspMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:50];
        _menu.delegate = self;
        _menu.dataSource = self;
        
        [self.view addSubview:_menu];
        
        [_menu selectDeafultIndexPath];
        
    }
    
    if (api == _QueryListApi) {
        
        [self.collection.mj_header endRefreshing];
        
        [[EmptyManager sharedManager] removeEmptyFromView:self.collection];
        
        self.teamListArray = responsObject;
        
        if (self.teamListArray.count <= 0) {
            
            [[EmptyManager sharedManager] showEmptyOnView:self.collection withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"没有检索到相关团队" operationText:nil operationBlock:^{
                
            }];
            
        }
        
        
        [self.collection reloadData];
        
    }
    
    
}

- (UITableView *)teamTableView
{
    
    if (!_teamTableView) {
        
        _teamTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _teamTableView.delegate  =self;
        
        _teamTableView.dataSource  =self;
        
    }
    
    return _teamTableView;
    
}
- (void)layOutSubview{
    
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(59);
        
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    
}

//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.teamListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TTCollectionViewCell *cell = (TTCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TTCollectionViewCell class]) forIndexPath:indexPath];
    
    TeamListModel *model = [self.teamListArray objectAtIndex:indexPath.row];

    [cell refreshwithModel:model];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((kScreenWidth - 3 *10)/2, kScreenHeight/2-20);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TeamDetailViewController *team = [TeamDetailViewController new];
    
    TeamListModel *model1 = [self.teamListArray objectAtIndex:indexPath.row];
    
    team.ID = model1.id;
    
    team.title = model1.name;
    
    [self.navigationController pushViewController:team animated:YES];
    
    
}


- (void)setTableview{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    layout.itemSize =CGSizeMake((kScreenWidth - 3 *10)/2, kScreenHeight/2-20);
    
    //2.初始化collectionView
    self.collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:self.collection];
    self.collection.backgroundColor = [UIColor whiteColor];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collection registerNib:[UINib nibWithNibName:@"TTCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([TTCollectionViewCell class])];
    
    self.collection.delegate = self;
    self.collection.dataSource = self;
    
    [self layOutSubview];
    
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    
    label.text = @"直医专家团队";
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = [UIColor whiteColor];
    
//    [self setNavigationtitleView:label];
    
    //    [self setMenuUI];
    
    [self setTableview];
    
//    [self layOutSubview];
    
    teamQuryHeader *head = [[teamQuryHeader alloc]init];
    
    head.target = @"noTokenPrefectureControl";
    
    head.method = @"findCondition";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    teamQuryBody *body = [[teamQuryBody alloc]init];
    
    TeamQueryRequest *request = [[TeamQueryRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.teamApi teamQuaryList:request.mj_keyValues.mutableCopy];
    
    
}


#pragma mark- tableview代理



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    CGFloat margin = 40;
    
    //headview
    UIButton *headerView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 100);
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    //headerContentView
    
    UIButton *headerContentView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    [headerView addSubview:headerContentView];
    
    UIImageView *topImage = [[UIImageView alloc]init];
    
    topImage.userInteractionEnabled  = YES;
    
    topImage.image = [UIImage imageNamed:@"team_topview"];
    
    [headerContentView addSubview:topImage];
    
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(10);
        
    }];
    
    UIImageView *middleView = [[UIImageView alloc]init];
    
    middleView.userInteractionEnabled = YES;
    
    middleView.image = [UIImage imageNamed:@"cell_img"];
    
    [headerContentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(topImage.mas_bottom);
        
        make.left.right.bottom.mas_equalTo(0);
        
    }];
    
    //团队头像
    
    UIImageView *headImage = [[UIImageView alloc]init];
    
    headImage.userInteractionEnabled  = YES;
    
    headImage.layer.cornerRadius = 30;
    
    headImage.layer.masksToBounds = YES;
    
    [headerContentView addSubview:headImage];
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(margin);
        
        make.top.mas_equalTo(20);
        
        make.width.height.mas_equalTo(60);
        
    }];
    
    //团队名称
    UILabel *headerName = [[UILabel alloc]init];
    
    headerName.textColor = DefaultBlackLightTextClor;
    
    headerName.font = Font(18);
    
    headerName.textAlignment = NSTextAlignmentLeft;
    
    [headerContentView addSubview:headerName];
    
    [headerName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headImage.mas_top).mas_equalTo(0);
        
        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        
        make.right.mas_equalTo(-40);
        
        make.height.mas_equalTo(20);
    }];
    
    //团队医院名称
    
    UILabel *hotelName = [[UILabel alloc]init];
    
    hotelName.userInteractionEnabled  = YES;
    
    hotelName.textColor = DefaultGrayTextClor;
    
    hotelName.font = Font(14);
    
    hotelName.textAlignment = NSTextAlignmentLeft;
    
    [headerContentView addSubview:hotelName];
    
    [hotelName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerName.mas_bottom).mas_equalTo(4);

        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        
        make.right.mas_equalTo(-20);
        
        make.height.mas_equalTo(20);
        
    }];
    
    //团队领头人姓名
    UILabel *headerNike = [[UILabel alloc]init];
    
    headerNike.userInteractionEnabled  = YES;
    
    headerNike.textColor = DefaultGrayTextClor;
    
    headerNike.font = Font(14);
    
    headerNike.textAlignment = NSTextAlignmentLeft;
    
    [headerContentView addSubview:headerNike];
    
    [headerNike mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(hotelName.mas_bottom).mas_equalTo(4);
        
        make.left.mas_equalTo(headImage.mas_right).mas_equalTo(10);
        
        make.right.mas_equalTo(-40);
        
        make.height.mas_equalTo(20);
    }];
    
    //团队介绍
//    UILabel *introduce = [[UILabel alloc]init];
//
//    introduce.userInteractionEnabled  = YES;
//
//    introduce.numberOfLines = 0;
//
//    introduce.textColor = DefaultGrayTextClor;
//
//    introduce.font = Font(14);
//
//    introduce.textAlignment = NSTextAlignmentLeft;
//
//    [headerContentView addSubview:introduce];
//
//    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(headImage.mas_bottom).mas_equalTo(10);
//
//        make.left.mas_equalTo(margin);
//
//        make.right.mas_equalTo(-40);
//
//        make.height.mas_equalTo(40);
//
//    }];
    
    //分割线
    
    UIView *sepview = [[UIView alloc]init];
    
    sepview.userInteractionEnabled  = YES;
    
    sepview.backgroundColor = DividerGrayColor;
    
    [headerContentView addSubview:sepview];
    
    [sepview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headerNike.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);

    }];
    
    //底部说明文字
    
//    UILabel *introduceTRext = [[UILabel alloc]init];
//
//    introduceTRext.userInteractionEnabled  = YES;
//
//    introduceTRext.numberOfLines = 0;
//
//    introduceTRext.text = @"团队成员";
//
//    introduceTRext.textColor = DefaultGrayTextClor;
//
//    introduceTRext.font = Font(16);
//
//    introduceTRext.textAlignment = NSTextAlignmentCenter;
//
//    [headerContentView addSubview:introduceTRext];
//
//    [introduceTRext mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(sepview.mas_bottom).mas_equalTo(5);
//
//        make.left.mas_equalTo(margin);
//
//        make.right.mas_equalTo(-40);
//
//        make.bottom.mas_equalTo(0);
//
//    }];
    
    TeamListModel *model = [self.teamListArray objectAtIndex:section];
    
    [headImage sd_setImageWithURL:[NSURL URLWithString:model.lfacepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
    
    headerName.text = model.name;
    
    headerNike.text = model.lhname;
    
    hotelName.text = [NSString stringWithFormat:@"学科领头人: %@  %@",model.lname,model.ljob];
    
//    introduce.text = model.introduction;
    
    UIButton *buttonLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [headerView addSubview:buttonLayer];
    
    buttonLayer.backgroundColor = [UIColor clearColor];
    
    [buttonLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
    }];
    
    [buttonLayer addTarget:self action:@selector(jumpTeam:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonLayer.tag = section;
    
    return headerView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIButton *footerView = [UIButton buttonWithType:UIButtonTypeSystem];
    
    footerView.frame =CGRectMake(0, 0, kScreenWidth, 70);
    footerView.backgroundColor = [UIColor whiteColor];
    //headerContentView
    UIButton *footContentView = [UIButton buttonWithType:UIButtonTypeSystem];
    footContentView.frame = CGRectMake(0, 0, kScreenWidth, 40);
    [footContentView setTitle:@"团队成员" forState:UIControlStateNormal];
    footContentView.titleLabel.font = Font(16);
    [footContentView setTitleColor:DefaultBlueTextClor forState:UIControlStateNormal];
    footContentView.backgroundColor = [UIColor whiteColor];
    footContentView.layer.cornerRadius = 8;
    [footContentView setBackgroundImage:[UIImage imageNamed:@"bottom_bg"] forState:UIControlStateNormal];
    [footerView addSubview:footContentView];
    
    UIButton *buttonLayer = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [footerView addSubview:buttonLayer];
    
    buttonLayer.backgroundColor = [UIColor clearColor];
    
    [buttonLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(0);
        
    }];
    
    [buttonLayer addTarget:self action:@selector(jumpTeam:) forControlEvents:UIControlEventTouchUpInside];
    
    buttonLayer.tag = section;
    
    return footerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 70;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.teamListArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 35;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 0;
//    ConditionTeamModel *model = [self.teamListArray objectAtIndex:section];
//
//    NSArray *member = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
//
//    if (member.count >2) {
//
//        NSArray *subArray = [member subarrayWithRange:NSMakeRange(0, 3)];
//        return subArray.count;
//    }else{
//
//        return member.count;
//    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MemberTableViewCell class])];
    
    TeamListModel *model = [self.teamListArray objectAtIndex:indexPath.section];
    
    NSArray *member = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
    
    if (member.count >2) {
        
        NSArray *subArray = [member subarrayWithRange:NSMakeRange(0, 3)];
        
        MemberModel *memberModel = [subArray objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:memberModel];
        
    }else{
        
        MemberModel *memberModel = [member objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:memberModel];
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
    TeamListModel *model = [self.teamListArray objectAtIndex:indexPath.section];
    
    NSArray *mem = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
    
    MemberModel *model1 = [mem objectAtIndex:indexPath.row];
    
    TeamDetailViewController *expert = [TeamDetailViewController new];
    
    expert.ID = model1.id;
    
    expert.title = model.name;
    
    [self.navigationController pushViewController:expert animated:YES];
    
    
}



#pragma mark- 下拉菜单代理

- (NSInteger)numberOfColumnsInMenu:(ZspMenu *)menu {
    return 3;
}

- (NSInteger)menu:(ZspMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.cities.count;
    }else if(column == 1) {
        return self.departments.count;
    }else {
        return self.choose.count;
    }
}

- (NSString *)menu:(ZspMenu *)menu titleForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.cities[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.departments[indexPath.row];
    }else {
        return self.choose[indexPath.row];
    }
}

- (NSString *)menu:(ZspMenu *)menu imageNameForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu imageForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu detailTextForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column < 2) {
        return @"";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu detailTextForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    return @"";
}

- (NSInteger)menu:(ZspMenu *)menu numberOfItemsInRow:(NSInteger)row inColumn:(NSInteger)column {
    if (column == 0) {
        
        if (row == 0) {
            return self.city0.count;
            
        }else if (row == 1) {
            return self.city1.count;
            
        }else if (row == 2) {
            return self.city2.count;
            
        }else if (row == 3) {
            return self.city3.count;
            
        }else if (row == 4) {
            return self.city4.count;
            
        }else if (row == 5) {
            return self.city5.count;
            
        }else if (row == 6) {
            return self.city6.count;
            
        }else if (row == 7) {
            return self.city7.count;
            
        }else if (row == 8) {
            
            return self.city8.count;
        }
    }
    return 0;
}

- (NSString *)menu:(ZspMenu *)menu titleForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (indexPath.column == 0) {
        if (row == 0) {
            return self.city0[indexPath.item];
            
        }else if (row == 1) {
            return self.city1[indexPath.item];
        }else if (row == 2) {
            return self.city2[indexPath.item];
        }else if (row == 3) {
            return self.city3[indexPath.item];
        }else if (row == 4) {
            return self.city4[indexPath.item];
        }else if (row == 5) {
            return self.city5[indexPath.item];
        }else if (row == 6) {
            return self.city6[indexPath.item];
        }else if (row == 7) {
            return self.city7[indexPath.item];
        }else if (row == 8) {
            return self.city8[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(ZspMenu *)menu didSelectRowAtIndexPath:(ZspIndexPath *)indexPath {
    
    if (indexPath.item >= 0 && indexPath.column == 0) {
        
        NSLog(@"点击了 %ld - %ld - %ld",indexPath.column,indexPath.row,indexPath.item);
        
        self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            
            AllteamQuryHeader *teamhead = [[AllteamQuryHeader alloc]init];
            
            teamhead.target = @"noTokenPrefectureControl";
            
            teamhead.method = @"teamsChoice";
            
            teamhead.versioncode = Versioncode;
            
            teamhead.devicenum = Devicenum;
            
            teamhead.fromtype = Fromtype;
            
            teamhead.token = [User LocalUser].token;
            
            AllteamQuryBody *teambody = [[AllteamQuryBody alloc]init];
            
            //    teambody.departmentid  =@"fudan";
            
            
            NSArray *cityList = [allCityModel mj_objectArrayWithKeyValuesArray:self.model.citys];
            
            
            for (allCityModel *city in cityList) {
                
                if ([city.id isEqualToString:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
                    
                    NSArray *memeber = [MemberModel mj_objectArrayWithKeyValuesArray:city.members];
                    
                    NSLog(@"kkkk%@",memeber);
                    
                    for (memberModel *model in memeber) {
                        
                        NSLog(@"hos.id:%@   %@",model.name,model.id);
                        
                    }
                    
                    memberModel *model = [memeber objectAtIndex:indexPath.item];
                    
                    teambody.hospitalid = model.id;
                    
                    NSLog(@"asd%@",model.id);
                    
                }
                
            }
            
            //        body.hospitalid = [NSString stringWithFormat:@"%ld",indexPath.column];
            
            //        body.departmentid = [NSString stringWithFormat:@"%ld",indexPath.row];
            
            QuaryTeamRequest *Teamrequest = [[QuaryTeamRequest alloc]init];
            
            Teamrequest.head = teamhead;
            
            Teamrequest.body = teambody;
            
            [self.QueryListApi AllteamQuaryList:Teamrequest.mj_keyValues.mutableCopy];
            
            
        }];
        
        [self.collection.mj_header beginRefreshing];
        
        
        
    }else if(indexPath.column == 1) {
        
        //操作默认，默认显示所有（全部医院，全部科室）
        NSLog(@"------点击了 %ld - %ld",indexPath.column,indexPath.row);
        
        
        self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            AllteamQuryHeader *teamhead = [[AllteamQuryHeader alloc]init];
            
            teamhead.target = @"noTokenPrefectureControl";
            
            teamhead.method = @"teamsChoice";
            
            teamhead.versioncode = Versioncode;
            
            teamhead.devicenum = Devicenum;
            
            teamhead.fromtype = Fromtype;
            
            teamhead.token = [User LocalUser].token;
            
            AllteamQuryBody *teambody = [[AllteamQuryBody alloc]init];
            
            QuaryTeamRequest *Teamrequest = [[QuaryTeamRequest alloc]init];
            
            Teamrequest.head = teamhead;
            
            Teamrequest.body = teambody;
            
            [self.QueryListApi AllteamQuaryList:Teamrequest.mj_keyValues.mutableCopy];

            
        }];
        
        [self.collection.mj_header beginRefreshing];
        
    }else{
        
        self.collection.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            AllteamQuryHeader *teamhead = [[AllteamQuryHeader alloc]init];
            
            teamhead.target = @"noTokenPrefectureControl";
            
            teamhead.method = @"teamsChoice";
            
            teamhead.versioncode = Versioncode;
            
            teamhead.devicenum = Devicenum;
            
            teamhead.fromtype = Fromtype;
            
            teamhead.token = [User LocalUser].token;
            
            AllteamQuryBody *teambody = [[AllteamQuryBody alloc]init];
            
            QuaryTeamRequest *Teamrequest = [[QuaryTeamRequest alloc]init];
            
            Teamrequest.head = teamhead;
            
            Teamrequest.body = teambody;
            
            [self.QueryListApi AllteamQuaryList:Teamrequest.mj_keyValues.mutableCopy];
      
        }];
        
        [self.collection.mj_header beginRefreshing];
        
    }
    
}


- (void)jumpTeam:(UIButton *)button{
    
    TeamDetailViewController *team = [TeamDetailViewController new];
    
    TeamListModel *model1 = [self.teamListArray objectAtIndex:button.tag];
    
    team.ID = model1.id;
    
    team.title = model1.name;
    
    [self.navigationController pushViewController:team animated:YES];
    

}



@end
