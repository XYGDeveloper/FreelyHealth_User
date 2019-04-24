//
//  TumorConsultationViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TumorConsultationViewController.h"
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
@interface TumorConsultationViewController ()<ZspMenuDataSource, ZspMenuDelegate,UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic, strong) ZspMenu *menu;

@property (nonatomic, strong) NSArray *city;
@property (nonatomic, strong) NSMutableArray *sort;
@property (nonatomic, strong) NSArray *choose;
@property (nonatomic, strong) NSMutableArray *all;
@property (nonatomic, strong) NSMutableArray *yuexiu;
@property (nonatomic, strong) NSMutableArray *tianhe;
@property (nonatomic, strong) NSMutableArray *panyu;
@property (nonatomic, strong) NSMutableArray *hanzhu;
@property (nonatomic, strong) NSMutableArray *baiyun;
@property (nonatomic, strong) NSMutableArray *liwan;
@property (nonatomic, strong) NSMutableArray *huangpu;
@property (nonatomic, strong) NSMutableArray *haha;

@property (nonatomic,strong)UITableView *customTableview;

@property (nonatomic,strong)teamQuaryApi *teamApi;

@property (nonatomic,strong)NSMutableArray *citys;

@property (nonatomic,strong)NSMutableArray *hospitals;

@property (nonatomic,strong)NSMutableArray *departments;

@property (nonatomic,strong)AllQuaryApi *QueryListApi;

@property (nonatomic,strong)NSMutableArray *teamList;

@property (nonatomic,strong)AllTeamModel *model;

@property (nonatomic,strong)departModel *model1;

@property (nonatomic,strong)NSMutableArray *allCityies;

@property (nonatomic,strong)NSMutableArray *cities;

@property (nonatomic,strong)NSMutableArray *city0;
@property (nonatomic,strong)NSMutableArray *city1;
@property (nonatomic,strong)NSMutableArray *city2;
@property (nonatomic,strong)NSMutableArray *city3;
@property (nonatomic,strong)NSMutableArray *city4;
@property (nonatomic,strong)NSMutableArray *city5;
@property (nonatomic,strong)NSMutableArray *city6;
@property (nonatomic,strong)NSMutableArray *city7;
@property (nonatomic,strong)NSMutableArray *city8;

@end



@implementation TumorConsultationViewController


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

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    
  

}


- (NSMutableArray *)sort
{

    if (!_sort) {
        
        _sort = [NSMutableArray array];
    }

    return _sort;
    
    
}


- (NSMutableArray *)teamList
{

    if (!_teamList) {
        
        _teamList = [NSMutableArray array];
    }

    return _teamList;
    

}

- (AllQuaryApi *)QueryListApi
{

    if (!_QueryListApi) {
        
        _QueryListApi = [[AllQuaryApi alloc]init];
        
        _QueryListApi.delegate  = self;
        
    }

    return _QueryListApi;
    
}



- (NSMutableArray *)citys
{

    if (!_citys) {
        
        _citys = [NSMutableArray array];
    }

    return _citys;
    
}

- (NSMutableArray *)all
{
    
    if (!_all) {
        
        _all = [NSMutableArray array];
    }
    
    return _all;
    
}


- (NSMutableArray *)yuexiu
{

    if (!_yuexiu) {
        
        _yuexiu = [NSMutableArray array];
    }
    
    return _yuexiu;

}

- (NSMutableArray *)tianhe
{

    if (!_tianhe) {
        
        _tianhe = [NSMutableArray array];
    }
    
    return _tianhe;


}


- (NSMutableArray *)panyu
{

    if (!_panyu) {
        
        _panyu = [NSMutableArray array];
    }
    
    return _panyu;


}

- (NSMutableArray *)hanzhu
{

    if (!_hanzhu) {
        
        _hanzhu = [NSMutableArray array];
    }
    
    return _hanzhu;


}

- (NSMutableArray *)baiyun
{
    if (!_baiyun) {
        
        _baiyun = [NSMutableArray array];
    }
    
    return _baiyun;

}

- (NSMutableArray *)liwan
{

    if (!_liwan) {
        
        _liwan = [NSMutableArray array];
    }
    
    return _liwan;
    
    
}

- (NSMutableArray *)huangpu
{

    if (!_huangpu) {
        
        _huangpu = [NSMutableArray array];
    }
    
    return _huangpu;
    
}

- (NSMutableArray *)haha
{

    if (!_haha) {
        
        _haha = [NSMutableArray array];
    }
    
    return _haha;

}



- (NSMutableArray *)departments
{
    
    if (!_departments) {
        
        _departments = [NSMutableArray array];
    }
    
    return _departments;
    
}





- (teamQuaryApi *)teamApi
{

    if (!_teamApi) {
        
        _teamApi = [[teamQuaryApi alloc]init];
        
        _teamApi.delegate  =self;
        
    }
    return _teamApi;
    

}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [LSProgressHUD hide];
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    NSLog(@"--------%@",responsObject);
    
    [LSProgressHUD hide];

    if (api == _QueryListApi) {
        
        self.teamList = responsObject;
        
        NSArray *cityList = [allCityModel mj_objectArrayWithKeyValuesArray:self.model.citys];
        
        for (allCityModel *city in cityList) {
            
            [self.citys addObject:city.name];
            NSLog(@"nimassss%@",self.citys);
        
        }
        

        NSArray *departList = [departModel mj_objectArrayWithKeyValuesArray:self.model.departments];
        
        NSLog(@"%@",departList);
        

        for (departModel *city in departList) {
            
            [self.sort addObject:city.name];
            NSLog(@"%@",self.citys);
            
            
        }
        
        
    }
    
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
    
    
    
    
}



- (UITableView *)customTableview
{

    if (!_customTableview) {
        
        _customTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _customTableview.delegate  =  self;
        
        _customTableview.dataSource = self;
        
        _customTableview.backgroundColor = [UIColor clearColor];
        
        _customTableview.separatorColor = [UIColor whiteColor];
        
        
    }

    return _customTableview;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    self.view.backgroundColor = DefaultBackgroundColor;

    
    [self.view addSubview:self.customTableview];
    
    [self.customTableview registerClass:[ExperTeamTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ExperTeamTableViewCell class])];
    
    [self layOutSubview];

    //获取查询条件
    [LSProgressHUD showWithMessage:nil];
    
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

- (void)layOutSubview{

    [self.customTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(59);
        
        make.left.right.bottom.mas_equalTo(0);
    }];
    

}

#pragma mark- tableviewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    //配置头部
    
    TeamListModel *model = [self.teamList objectAtIndex:section];
    
    UIButton *sectionHeadContent = [[UIButton alloc]initWithFrame:CGRectMake(22.5, 0, kScreenWidth- 22.5*2,96)];
    
    [sectionHeadContent setBackgroundImage:[UIImage imageNamed:@"sddetail_sectionhead_cell_bg_image"] forState:UIControlStateNormal];
    
    UIImageView *headImg = [[UIImageView alloc]init];
    
    headImg.userInteractionEnabled = YES;
    
    headImg.layer.cornerRadius = 68.5/2;
    
    headImg.layer.masksToBounds = YES;
    
    [sectionHeadContent addSubview:headImg];
    
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(40);
        make.width.height.mas_equalTo(68.5);
        
    }];
    
    [headImg sd_setImageWithURL:[NSURL URLWithString:model.lfacepath]];

    [headImg sd_setImageWithURL:[NSURL URLWithString:model.lfacepath] placeholderImage:[UIImage imageNamed:@"005x68CJgy6NHxegyOW5e&690.jpg"]];

    UILabel *header = [[UILabel alloc]init];
    
    header.userInteractionEnabled = YES;
    
    header.text = [NSString stringWithFormat:@"学科领头人:%@ %@",model.lname,model.ljob];
    
    header.textAlignment = NSTextAlignmentLeft;
    
    header.textColor = DefaultGrayLightTextClor;
    
    header.font = Font(14);
    
    [sectionHeadContent addSubview:header];
    
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headImg.mas_centerY);
        make.left.mas_equalTo(headImg.mas_right).mas_equalTo(18.5);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(12);
    }];
    
    UILabel *teamNmae = [UILabel new];
    
    teamNmae.userInteractionEnabled = YES;
    
    teamNmae.text = model.name;
    
    teamNmae.textAlignment = NSTextAlignmentLeft;
    
    teamNmae.textColor = DefaultBlackLightTextClor;
    
    teamNmae.font = Font(16);
    
    [sectionHeadContent addSubview:teamNmae];
    
    [teamNmae mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(headImg.mas_top);
        make.left.mas_equalTo(header.mas_left);
        make.right.mas_equalTo(header.mas_right);
        make.height.mas_equalTo(16);
    }];
    
    UILabel *jopNmae = [UILabel new];
    
    jopNmae.userInteractionEnabled = YES;
    
    jopNmae.text = model.lhname;
    
    jopNmae.textAlignment = NSTextAlignmentLeft;
    
    jopNmae.textColor = DefaultGrayLightTextClor;
    
    jopNmae.font = Font(14);
    
    [sectionHeadContent addSubview:jopNmae];
    
    [jopNmae mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(header.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(header.mas_left);
        make.right.mas_equalTo(header.mas_right);
        make.height.mas_equalTo(14);
    }];
    
//    UILabel *introduce = [[UILabel alloc]init];
//    
//    introduce.userInteractionEnabled = YES;
//    
//    introduce.numberOfLines = 0;
//    
//    introduce.textAlignment = NSTextAlignmentLeft;
//    
//    introduce.textColor = DefaultGrayLightTextClor;
//    
//    introduce.font = Font(14);
//
//    [sectionHeadContent addSubview:introduce];
//    
//    [introduce mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(headImg.mas_left);
//        make.right.mas_equalTo(-20);
//        make.top.mas_equalTo(headImg.mas_bottom).mas_equalTo(5);
//        
//    }];
    
//    introduce.text = model.introduction;
    
    UIView *sep =[UIView new];
    
    sep.backgroundColor = DividerGrayColor;
    
    sep.alpha = 0.5;
    
    [sectionHeadContent addSubview:sep];
    
    [sep mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(18.5);
        make.right.mas_equalTo(-18.5);
        make.height.mas_equalTo(1);
        make.bottom.mas_equalTo(0);
    }];
    
//    UILabel *label = [UILabel new];
//    
//    [sectionHeadContent addSubview:label];
//    
//    label.text = @"团队成员";
//    label.font = Font(14);
//    label.textAlignment = NSTextAlignmentCenter;
//    
//    label.textColor = DefaultGrayLightTextClor;
//    
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(sep.mas_bottom);
//        make.left.bottom.right.mas_equalTo(0);
//        make.height.mas_equalTo(29);
//    }];
    

//    UITapGestureRecognizer *sectionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpTeamPage:)];
//    
//    [sectionHeadContent addGestureRecognizer:sectionTap];
    
//    sectionHeadContent.tag = section;
    
    [sectionHeadContent addTarget:self action:@selector(jumpTeamPage:) forControlEvents:UIControlEventTouchUpInside];
    sectionHeadContent.tag = section;
    
    return sectionHeadContent;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIImageView *footContewnt = [UIImageView new];
    
    footContewnt.image = [UIImage imageNamed:@"sddetail_bottom_cell_bg_image"];

    footContewnt.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"团队成员" forState:UIControlStateNormal];
    
    [button setTitleColor:DefaultBlueTextClor forState:UIControlStateNormal];
    
    button.titleLabel.font = Font(16);
    
    [footContewnt addSubview:button];
    
    button.tag = section;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(footContewnt.mas_centerY);
        make.centerX.mas_equalTo(footContewnt.mas_centerX);
    }];
    
    
    [button addTarget:self action:@selector(jumpTeamPage:) forControlEvents:UIControlEventTouchUpInside];
    
    return footContewnt;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 96;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 60;

}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.teamList.count;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
//    TeamListModel *model = [self.teamList objectAtIndex:section];
//    
//    NSArray *mem = [memberModel mj_objectArrayWithKeyValuesArray:model.members];
//    
//    if (mem.count > 2) {
//        NSArray *subArray = [mem subarrayWithRange:NSMakeRange(0, 3)];
//        
//        return subArray.count;
//    }else{
//    
//        return mem.count;
//    
//    }
    
    return 0;
    
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 40;

}

//child cell

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    TeamListModel *model = [self.teamList objectAtIndex:indexPath.section];
    
    NSArray *mem = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
    
    MemberModel *model1 = [mem objectAtIndex:indexPath.row];
    
    ExpertConsultViewController *expert = [ExpertConsultViewController new];
    
    expert.ID = model1.id;
    
    expert.title = model.name;

    [self.navigationController pushViewController:expert animated:YES];
    
}

//section Cell
- (void)jumpTeamPage:(UIButton *)sender{

    TeamExpertViewController *team = [TeamExpertViewController new];
    
    TeamListModel *model1 = [self.teamList objectAtIndex:sender.tag];

    team.ID = model1.id;
    
    [self.navigationController pushViewController:team animated:YES];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ExperTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ExperTeamTableViewCell class])];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TeamListModel *model = [self.teamList objectAtIndex:indexPath.section];

    NSArray *mem = [MemberModel mj_objectArrayWithKeyValuesArray:model.members];
    
    if (mem.count >2) {
        
        NSArray *subArray = [mem subarrayWithRange:NSMakeRange(0, 3)];
        
        MemberModel *memberModel = [subArray objectAtIndex:indexPath.row];
        
        [cell refreshWith:memberModel];
        
    }else{
    
        MemberModel *memberModel = [mem objectAtIndex:indexPath.row];
        
        [cell refreshWith:memberModel];
    
    }

    return cell;
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (NSInteger)numberOfColumnsInMenu:(ZspMenu *)menu {
    return 3;
}

- (NSInteger)menu:(ZspMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    if (column == 0) {
        return self.citys.count;
    }else if(column == 1) {
        return self.sort.count;
    }else {
        return self.choose.count;
    }
}


- (NSString *)menu:(ZspMenu *)menu titleForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0) {
        return self.citys[indexPath.row];
    }else if(indexPath.column == 1) {
        return self.sort[indexPath.row];
    }else {
        return self.choose[indexPath.row];
    }
}

- (NSString *)menu:(ZspMenu *)menu imageNameForRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0 || indexPath.column == 1) {
        return @"baidu";
    }
    return nil;
}

- (NSString *)menu:(ZspMenu *)menu imageForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    if (indexPath.column == 0 && indexPath.item >= 0) {
        return @"baidu";
    }
    return nil;
}

//- (NSString *)menu:(ZspMenu *)menu detailTextForRowAtIndexPath:(ZspIndexPath *)indexPath {
//    if (indexPath.column < 2) {
//        return [@(arc4random()%1000) stringValue];
//    }
//    return nil;
//}

- (NSString *)menu:(ZspMenu *)menu detailTextForItemsInRowAtIndexPath:(ZspIndexPath *)indexPath {
    
    return nil;
    
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
      
        //团队列表
        [LSProgressHUD showWithMessage:nil];
        
        AllteamQuryHeader *teamhead = [[AllteamQuryHeader alloc]init];
        
        teamhead.target = @"noTokenPrefectureControl";
        
        teamhead.method = @"teamsChoice";
        
        teamhead.versioncode = Versioncode;
        
        teamhead.devicenum = Devicenum;
        
        teamhead.fromtype = Fromtype;
        
        teamhead.token = [User LocalUser].token;
        
        AllteamQuryBody *teambody = [[AllteamQuryBody alloc]init];
            
        //    teambody.departmentid  =@"fudan";
        
        QuaryTeamRequest *Teamrequest = [[QuaryTeamRequest alloc]init];
        
        Teamrequest.head = teamhead;
        
        Teamrequest.body = teambody;
        
        NSArray *cityList = [allCityModel mj_objectArrayWithKeyValuesArray:self.model.citys];
        
        for (allCityModel *city in cityList) {
            
            [self.citys addObject:city.name];
            NSLog(@"%@",self.citys);
            
            if ([city.id isEqualToString:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
                
                NSLog(@"city.id:%@",city.id);
                
                NSArray *memeber = [memberModel mj_objectArrayWithKeyValuesArray:city.members];
                
                NSLog(@"kkkk%@",memeber);
              
                for (memberModel *model in memeber) {
                    
                    
                        NSLog(@"hos.id:%@   %@",model.name,model.id);
                    
                                        
                 }
                
                memberModel *model = [memeber objectAtIndex:indexPath.item];
                
                teambody.hospitalid = model.id;

                NSLog(@"asd%@",model.id);
                
            }
            
        }
        
        NSLog(@"%@",Teamrequest);
        
        [self.QueryListApi AllteamQuaryList:Teamrequest.mj_keyValues.mutableCopy];

          NSLog(@"点击了 %ld - %ld - %ld",indexPath.column,indexPath.row,indexPath.item);
        
    }else if (indexPath.column == 1) {
        
        [LSProgressHUD showWithMessage:nil];

 NSArray *departList = [departModel mj_objectArrayWithKeyValuesArray:self.model.departments];
        departModel *model = [departList objectAtIndex:indexPath.row];
        NSLog(@"%@",model.name);
        
        AllteamQuryHeader *teamhead = [[AllteamQuryHeader alloc]init];
        
        teamhead.target = @"noTokenPrefectureControl";
        
        teamhead.method = @"teamsChoice";
        
        teamhead.versioncode = Versioncode;
        
        teamhead.devicenum = Devicenum;
        
        teamhead.fromtype = Fromtype;
        
        teamhead.token = [User LocalUser].token;
        
        AllteamQuryBody *teambody = [[AllteamQuryBody alloc]init];
        
        teambody.departmentid = model.id;
        
        QuaryTeamRequest *Teamrequest = [[QuaryTeamRequest alloc]init];
        
        Teamrequest.head = teamhead;
        
        Teamrequest.body = teambody;
        
        NSLog(@"000//%@",Teamrequest);
        
        [self.QueryListApi AllteamQuaryList:Teamrequest.mj_keyValues.mutableCopy];
        
        NSLog(@"点击了ddddd %ld - %ld",indexPath.column,indexPath.row);
        
    }
}


@end
