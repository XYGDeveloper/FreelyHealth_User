//
//  MyFilesViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyFilesViewController.h"
#import "MyfileApi.h"
#import "MyfileRequest.h"
#import "MyfileTableViewCell.h"
#import "FileModel.h"
#import "DiseaseHistoryTableViewCell.h"
#import "ResultTableViewCell.h"
#import "FriendCircleCell.h"
#import "RelatedMedicalRecordsTableViewCell.h"
#import "QQWRefreshFooter.h"
#import "QQWRefreshNoMoreView.h"
@interface MyFilesViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *filesTableview;

@property (nonatomic,strong)MyfileApi *api;

@property (nonatomic,strong)NSMutableArray *fileArray;

@property (nonatomic,strong)NSMutableArray *reArray;

@property (nonatomic,strong)NSMutableArray *reArray1;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UILabel *infoView;

@property (nonatomic,strong)UILabel *nameView;

@property (nonatomic,strong)FileModel *model;

@property (nonatomic,strong)DiseaseHistoryTableViewCell *cell;

@property (nonatomic,strong)MyfileTableViewCell *cell1;
@property (nonatomic,strong)ResultTableViewCell *cell2;


@end

@implementation MyFilesViewController


- (NSMutableArray *)fileArray
{

    if (!_fileArray) {
        
        _fileArray = [NSMutableArray array];
    }
    
    return _fileArray;
    

}

- (NSMutableArray *)reArray
{
    
    if (!_reArray) {
        
        _reArray = [NSMutableArray array];
    }
    
    return _reArray;
    
    
}

- (NSMutableArray *)reArray1
{
    
    if (!_reArray1) {
        
        _reArray1 = [NSMutableArray array];
    }
    
    return _reArray1;
    
    
}

- (MyfileApi *)api
{

    if (!_api) {
        
        _api = [[MyfileApi alloc]init];
        
        _api.delegate  =self;
        
    }

    return _api;
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [Utils postMessage:command.response.msg onView:self.view];
    [self.filesTableview.mj_header endRefreshing];
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    NSLog(@"订单列表%@",responsObject);
    [self.filesTableview.mj_footer resetNoMoreData];
    [self.filesTableview.mj_header endRefreshing];
    [LSProgressHUD hide];
    
    [[EmptyManager sharedManager] removeEmptyFromView:self.filesTableview];
    
    self.model = responsObject;
    
    self.fileArray =  [recordModel mj_objectArrayWithKeyValuesArray:self.model.records];
    
    if (self.fileArray.count <= 0) {
        [[EmptyManager sharedManager] showEmptyOnView:self.filesTableview withImage:[UIImage imageNamed:@"bingli_empty"] explain:@"暂无档案记录" operationText:nil operationBlock:nil];
    } else {
        
        [self.fileArray removeAllObjects];
        
        self.fileArray =  [recordModel mj_objectArrayWithKeyValuesArray:self.model.records];

        for (recordModel *model in self.fileArray) {
            
            if ([model.type isEqualToString:@"1"]) {
                
                [self.reArray addObject:model];
                
            }
        }
        
        for (recordModel *model in self.fileArray) {
            
            if ([model.type isEqualToString:@"2"]) {
                
                [self.reArray1 addObject:model];
                
            }
        }
        
        self.infoView.text = [NSString stringWithFormat:@"个人信息：%@，%@，%@，%@",self.model.name,self.model.sex,self.model.age,self.model.city];
        
        self.nameView.text = [NSString stringWithFormat:@"疾病情况：%@",self.model.rname];
        [self.filesTableview reloadData];
    }

}

- (void)api:(BaseApi *)api loadMoreSuccessWithCommand:(ApiCommand *)command responseObject:(id)responsObject {
    [self.filesTableview.mj_footer endRefreshing];
}

- (void)api:(BaseApi *)api loadMoreFailedWithCommand:(ApiCommand *)command error:(NSError *)error {
    [self.filesTableview.mj_footer endRefreshing];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api loadMoreEndWithCommand:(ApiCommand *)command {
    [self.filesTableview.mj_footer endRefreshingWithNoMoreData];
}


- (UITableView *)filesTableview
{

    if (!_filesTableview) {
        
        _filesTableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _filesTableview.delegate = self;
        
        _filesTableview.dataSource = self;
        
        _filesTableview.backgroundColor = DefaultBackgroundColor;
                
    }

    return _filesTableview;
    
    
}


- (void)layOutsubview{

    [self.filesTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

//    [self setRightNavigationItemWithTitle:@"更新档案" action:@selector(updateFile)];
    
    
  
    
    
    [self.view addSubview:self.filesTableview];
    
    self.filesTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        myfileHeader *head = [[myfileHeader alloc]init];
        
        head.target = @"consultControl";
        
        head.method = @"myRecord";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        myfileBody *body = [[myfileBody alloc]init];
        
        
        MyfileRequest *request = [[MyfileRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.api getmyfile:request.mj_keyValues.mutableCopy];
        
        
    }];
    
    self.filesTableview.mj_footer = [QQWRefreshFooter footerWithRefreshingBlock:^{
      
    }];
    
    [self.filesTableview.mj_header beginRefreshing];
    
    
    [self layOutsubview];
    
     [self.filesTableview registerClass:[FriendCircleCell class] forCellReuseIdentifier:NSStringFromClass([FriendCircleCell class])];
     [self.filesTableview registerClass:[ResultTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ResultTableViewCell class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 0) {
        
        UIView *sectionOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        return sectionOne;
        
    }else if (section == 1){
    
        UIView *sectionOne = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        
        return sectionOne;
        
    }else{
    
        UIView *sectionthe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        
        sectionthe.backgroundColor = DefaultBackgroundColor;

        return sectionthe;
    
    }

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.reArray.count;
    }else{
        return self.reArray1.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        FriendCircleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCircleCell"];
        [cell cellDataWithModel:self.reArray[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;        
    }else{
    
        ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ResultTableViewCell class])];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        recordModel *model = [self.reArray1 objectAtIndex:indexPath.row];
        
        cell.model = model;
        
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:@"FriendCircleCell" cacheByIndexPath:indexPath configuration: ^(FriendCircleCell *cell) {
            if (indexPath.row < self.reArray.count) {
                [cell cellDataWithModel:self.reArray[indexPath.row]];
            }
        }];
        
    }else{
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([ResultTableViewCell class]) cacheByIndexPath:indexPath configuration:^(ResultTableViewCell *cell) {
            
            recordModel *model = [self.reArray1 objectAtIndex:indexPath.row];
            
            cell.model = model;
            
        }];
    
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return 10.0f;
        
    }else{
        
        return 0.00000001f;
        
    }

}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)updateFile{
    UpdateViewController *update = [UpdateViewController new];
    update.title = @"更新档案";
    update.model = self.model;
    [self.navigationController pushViewController:update animated:YES];

}



@end
