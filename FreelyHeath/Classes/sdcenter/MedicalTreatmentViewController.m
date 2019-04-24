//
//  MedicalTreatmentViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MedicalTreatmentViewController.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"
#import "PhysicalTableViewCell.h"
#import "GuideExTableViewCell.h"
#import "MedicalDetailController.h"
#import "TumorTreamentModel.h"
#import "TumTremantRequest.h"
#import "TumorApi.h"
#import "ApplyHZViewController.h"
@interface MedicalTreatmentViewController ()<UITableViewDataSource,UITableViewDelegate,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *medcaltTableview;

@property (nonatomic,strong)NSMutableArray *list;

@property (nonatomic,strong)TumorApi *api;

@end

@implementation MedicalTreatmentViewController


- (NSMutableArray *)list{

    if (!_list) {
        
        _list = [NSMutableArray array];
    }

    return _list;
    
}

- (TumorApi *)api
{

    if (!_api) {
        
        _api = [[TumorApi alloc]init];
        
        _api.delegate  =self;
        
    }

    return _api;
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.medcaltTableview.mj_header endRefreshing];

    


}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    [self.medcaltTableview.mj_header endRefreshing];

    self.list = responsObject;
    
    [self.medcaltTableview reloadData];
    
}




- (UITableView *)medcaltTableview
{

    if (!_medcaltTableview) {
        
        _medcaltTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _medcaltTableview.delegate  = self;
        
        _medcaltTableview.dataSource = self;
        
        _medcaltTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _medcaltTableview;
    
}

- (void)layoutsubview{
    [self.medcaltTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.medcaltTableview];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.title = @"绿色通道";
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    [self.medcaltTableview registerClass:[PhysicalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
    
     [self.medcaltTableview registerNib:[UINib nibWithNibName:@"GuideExTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([GuideExTableViewCell class])];
    
    [self layoutsubview];
    
    self.medcaltTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        TumTremantHeader *head = [[TumTremantHeader alloc]init];
        
        head.target = @"noTokenOrderControl";
        
        head.method = @"getGoodsFirst";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        TumTremantBody *body = [[TumTremantBody alloc]init];

        TumTremantRequest *request = [[TumTremantRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api tumInfo:request.mj_keyValues.mutableCopy];
        
    }];
    
    [self.medcaltTableview.mj_header beginRefreshing];
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//    if (section == 0) {
    
        return self.list.count;
//
//    }else{
//
//        return 1;
//
//    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
//    if (indexPath.section == 0) {
    
        PhysicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TumorTreamentModel *model = [self.list objectAtIndex:indexPath.row];
        
        [cell refreshWithTurModel:model];
        
        return cell;
//
//    }else{
//
//        GuideExTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GuideExTableViewCell class])];
//        TumorTreamentModel *model0 = [self.list objectAtIndex:0];
//        TumorTreamentModel *model1 = [self.list objectAtIndex:1];
//        TumorTreamentModel *model2 = [self.list objectAtIndex:2];
//        TumorTreamentModel *model3 = [self.list objectAtIndex:3];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        [cell.guideButton1 setTitle:model0.name forState:UIControlStateNormal];
//        [cell.guide2Button setTitle:model1.name forState:UIControlStateNormal];
//        [cell.guide3Button setTitle:model2.name forState:UIControlStateNormal];
//        [cell.guid4Button setTitle:model3.name forState:UIControlStateNormal];
//
//        cell.guide1 = ^{
//
//            MedicalDetailController *madicalDetail = [MedicalDetailController new];
//
//            madicalDetail.title  =@"专家特诊";
//
//            madicalDetail.gooid = @"1";
//
//            [self.navigationController pushViewController:madicalDetail animated:YES];
//
//        };
//
//        cell.guide2 = ^{
//
//            MedicalDetailController *madicalDetail = [MedicalDetailController new];
//
//            madicalDetail.title  =@"陪诊服务";
//
//            madicalDetail.gooid = @"2";
//
//            [self.navigationController pushViewController:madicalDetail animated:YES];
//
//        };
//
//        cell.guide3 = ^{
//
//            MedicalDetailController *madicalDetail = [MedicalDetailController new];
//
//            madicalDetail.title  =@"全程管理服务";
//
//            madicalDetail.gooid = @"3";
//
//            [self.navigationController pushViewController:madicalDetail animated:YES];
//
//        };
//
//        cell.guide4 = ^{
//
//            if ([Utils showLoginPageIfNeeded]) {
//
//            } else {
//
//                ApplyHZViewController *nation = [ApplyHZViewController new];
//                nation.isLSTD = YES;
//                [nation loadWebURLSring:video_hz_URL5];
////                NSMutableArray *tempArr = [NSMutableArray array];
////                for (members *model in self.listArr) {
////                    [tempArr addObject:model.name];
////                }
////                nation.teamMember = tempArr;
////                nation.teamId = self.model.id;
//                nation.title = @"专家视频会诊";
//                nation.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:nation animated:YES];
//            }
//
//        };
//
//        return cell;
//
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
//    if (indexPath.section == 0) {
    
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([PhysicalTableViewCell class]) cacheByIndexPath:indexPath configuration:^(PhysicalTableViewCell *cell) {
            
            TumorTreamentModel *model = [self.list objectAtIndex:indexPath.row];
            
            [cell refreshWithTurModel:model];
            
        }];
        
        
//    }else{
//
//        return 240;
//
//    }
//
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            ApplyHZViewController *nation = [ApplyHZViewController new];
            nation.isLSTD = YES;
            [nation loadWebURLSring:video_hz_URL5];
            //                NSMutableArray *tempArr = [NSMutableArray array];
            //                for (members *model in self.listArr) {
            //                    [tempArr addObject:model.name];
            //                }
            //                nation.teamMember = tempArr;
            //                nation.teamId = self.model.id;
            nation.title = @"专家视频会诊";
            nation.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:nation animated:YES];

        }else{
            
            TumorTreamentModel *model = [self.list objectAtIndex:indexPath.row];
            
            MedicalDetailController *madicalDetail = [MedicalDetailController new];
            
            madicalDetail.title  =@"服务详情";
            
            madicalDetail.gooid = model.ID;
            
            madicalDetail.holpid = self.ID;
            
            [self.navigationController pushViewController:madicalDetail animated:YES];
        }
     
        
    }

}



@end
