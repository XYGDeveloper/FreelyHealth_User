//
//  IndexManagerFillDataViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IndexManagerFillDataViewController.h"
#import "IndexOriFillTableViewCell.h"
#import "IndexStyleFillDataTableViewCell.h"
#import "IndexManagementViewController.h"
#import "WeightViewController.h"
#import "BloodSugarViewController.h"
#import "BloodPressureViewController.h"
#import "TumorMarkerViewController.h"
#import "PasswordView.h"
#import "AddIndexListRequest.h"
#import "AddIndexApi.h"
@interface IndexManagerFillDataViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
{
    PasswordView *passView;
}
@property (nonatomic,strong)UITableView *managerTableView;

@property (nonatomic,strong)GetIndexList *indexListApi;

@property (nonatomic,strong)AddIndexApi *addApi;


@property (nonatomic,strong)NSArray *list;

@property (nonatomic,strong)NSMutableArray *list1;

@property (nonatomic,strong)NSMutableArray *list2;


@end

@implementation IndexManagerFillDataViewController


- (GetIndexList *)indexListApi
{
    
    if (!_indexListApi) {
        
        _indexListApi = [[GetIndexList alloc]init];
        
        _indexListApi.delegate  = self;
        
    }
    
    return _indexListApi;
    
}

- (AddIndexApi *)addApi
{

    if (!_addApi) {
        
        _addApi = [[AddIndexApi alloc]init];
        
        _addApi.delegate  =self;
        
    }
    
    return _addApi;
    

}



- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [self.managerTableView.mj_header endRefreshing];

    [LSProgressHUD hide];
    
    if (api == _addApi) {
        
        [Utils postMessage:command.response.msg onView:self.view];
        
        
    }
    
   

}



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    
       [self.managerTableView.mj_header endRefreshing];
    [LSProgressHUD hide];

    
    
    if (api == _addApi) {
        
        
        self.list1 = [NSMutableArray array];
        
        self.list2 = [NSMutableArray array];
        
        [LSProgressHUD showWithMessage:@"添加中"];
        
        IndexHeader *head = [[IndexHeader alloc]init];
        
        head.target = @"indexsControl";
        
        head.method = @"getIndexsList";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        IndexBody *body = [[IndexBody alloc]init];
        
        GetIndexListRequest *request = [[GetIndexListRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.indexListApi getIndexList:request.mj_keyValues.mutableCopy];

        
    }
    
    if (api == _indexListApi) {
        
        
        self.list1 = [NSMutableArray array];
        
        self.list2 = [NSMutableArray array];
        
        self.list = [IndexListModel mj_objectArrayWithKeyValuesArray:responsObject[@"indexs"]];
        
        NSLog(@"%@",responsObject);
        
        [self.list1 addObject:self.list[0]];
        
        [self.list1 addObject:self.list[1]];
        
        [self.list1 addObject:self.list[2]];
        
        [self.list2 addObject:self.list[3]];
        [self.list2 addObject:self.list[4]];
        [self.list2 addObject:self.list[5]];
        [self.list2 addObject:self.list[6]];
        [self.list2 addObject:self.list[7]];
        [self.list2 addObject:self.list[8]];
        [self.list2 addObject:self.list[9]];
        [self.list2 addObject:self.list[10]];
        [self.list2 addObject:self.list[11]];
        [self.list2 addObject:self.list[12]];
        [self.list2 addObject:self.list[13]];
        [self.list2 addObject:self.list[14]];
        
    }

    [self.managerTableView reloadData];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self.view addSubview:self.managerTableView];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.managerTableView.backgroundColor = DefaultBackgroundColor;
    
    [self.managerTableView registerNib:[UINib nibWithNibName:@"IndexOriFillTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndexOriFillTableViewCell class])];
    
    [self.managerTableView registerNib:[UINib nibWithNibName:@"IndexStyleFillDataTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndexStyleFillDataTableViewCell class])];
    
    [self layOutSubview];

    [LSProgressHUD showWithMessage:nil];
    
    self.managerTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        IndexHeader *head = [[IndexHeader alloc]init];
        
        head.target = @"indexsControl";
        
        head.method = @"getIndexsList";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        IndexBody *body = [[IndexBody alloc]init];
        
        GetIndexListRequest *request = [[GetIndexListRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.indexListApi getIndexList:request.mj_keyValues.mutableCopy];
        
    }];
    
    
    [self.managerTableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}

- (UITableView *)managerTableView
{
    
    if (!_managerTableView) {
        
        _managerTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _managerTableView.delegate  = self;
        
        _managerTableView.dataSource  = self;
        
    }
    
    return _managerTableView;
    
}

- (void)layOutSubview{
    
    
    [self.managerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return CGFLOAT_MIN;
        
    }else{
        return 68;
    }
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1) {
        
        
        IndexOriFillTableViewCell *contentView = [[IndexOriFillTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        
        iconView.image = [UIImage imageNamed:@"z4"];
                
        [contentView addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.left.mas_equalTo(16);
            make.width.height.mas_equalTo(27);
        }];
        
        UILabel *flageLabel = [[UILabel alloc]init];
        
        flageLabel.textColor  =DefaultBlackLightTextClor;
        
        flageLabel.font  = Font(16);
        
        flageLabel.textAlignment = NSTextAlignmentLeft;
        
        flageLabel.text  =@"肿瘤标志物";
        
        [contentView addSubview:flageLabel];
        
        [flageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.left.mas_equalTo(iconView.mas_right).mas_equalTo(15);
            make.height.mas_equalTo(27);
            make.width.mas_equalTo(140);
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        
        [contentView addGestureRecognizer:tap];
        
        return contentView;
        
    }
    
    return nil;
    
}

//
//- (void)tapAction{
//    
// 
//    
//    
//}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        return 68;
        
    }else{
        
        return 50;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
        return self.list1.count;
        
    }else{
        
        return self.list2.count;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        IndexOriFillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexOriFillTableViewCell class])];
        
        NSArray *imgArr = @[@"z1",@"z2",@"z3"];
        
        cell.iconImage.image = [UIImage imageNamed:[imgArr objectAtIndex:indexPath.row]];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        IndexListModel *model = [self.list1 objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:model];
        
        weakify(cell);
        
         cell.addIndex = ^{
             
             strongify(cell);
             
             passView = [[PasswordView alloc] initWithTitle:[NSString stringWithFormat:@"请填写%@",model.name] cancelBtn:@"取消" sureBtn:@"确定更新" unit:model.unit  btnClickBlock:^(NSInteger index,NSString *str) {
                 if (index == 0) {
                     NSLog(@"0000000");
                 }else if (index == 1){
                     NSLog(@"111111");
                     NSLog(@"%@",str);
                     
                     if (str.length == 0) {
                         
                         [Utils postMessage:@"输入有效值" onView:self.view];
                         
                         return;
                
                     }
                     
                     addIndexHeader *head = [[addIndexHeader alloc]init];
                     
                     head.target = @"indexsControl";
                     
                     head.method = @"updateIndexs";
                     
                     head.versioncode = Versioncode;
                     
                     head.devicenum = Devicenum;
                     
                     head.fromtype = Fromtype;
                     
                     head.token = [User LocalUser].token;
                     
                     addIndexbody *body = [[addIndexbody alloc]init];
                     
                     body.id = model.id;
                     
                     body.num = str;
                     
                     AddIndexListRequest *request = [[AddIndexListRequest alloc]init];
                     
                     request.head = head;
                     
                     request.body = body;
                     
                     NSLog(@"%@",request);
                     
                     [self.addApi addIndexList:request.mj_keyValues.mutableCopy];
               
                 }
             }];
             [passView show];

             
             [cell refreshWithModel:model];
             
             
         };
    
        
        return cell;
        
    }else{
        
        
        IndexStyleFillDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexStyleFillDataTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        IndexListModel *model = [self.list2 objectAtIndex:indexPath.row];
        
        [cell refreshWithModel:model];
        
        weakify(cell);
        
        cell.addIndexData  = ^{
            
            strongify(cell);
            passView = [[PasswordView alloc] initWithTitle:[NSString stringWithFormat:@"请填写%@",model.name] cancelBtn:@"取消" sureBtn:@"确定更新" unit:model.unit btnClickBlock:^(NSInteger index,NSString *str) {
                if (index == 0) {
                    NSLog(@"0000000");
                }else if (index == 1){
                    NSLog(@"111111");
                    NSLog(@"%@",str);
                    
                    if (str.length == 0) {
                        
                        [Utils postMessage:@"输入有效值" onView:self.view];
                        
                        return;
                        
                    }
                    
                    addIndexHeader *head = [[addIndexHeader alloc]init];
                    
                    head.target = @"indexsControl";
                    
                    head.method = @"updateIndexs";
                    
                    head.versioncode = Versioncode;
                    
                    head.devicenum = Devicenum;
                    
                    head.fromtype = Fromtype;
                    
                    head.token = [User LocalUser].token;
                    
                    addIndexbody *body = [[addIndexbody alloc]init];
                    
                    body.id = model.id;
                    
                    body.num = str;
                    
                    AddIndexListRequest *request = [[AddIndexListRequest alloc]init];
                    
                    request.head = head;
                    
                    request.body = body;
                    
                    NSLog(@"%@",request);
                    
                    [self.addApi addIndexList:request.mj_keyValues.mutableCopy];
                    
                }
                
            }];
            [passView show];
            
            
            [cell refreshWithModel:model];
            
            
        };
        
        
        return cell;
        
    }
    
    
}


- (void)tapAction{
    
    TumorMarkerViewController *tum = [TumorMarkerViewController new];

    [self.navigationController pushViewController:tum animated:YES];
    
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0) {
        
        IndexListModel *model = [self.list1 objectAtIndex:indexPath.row];

        if (indexPath.row == 0) {
        
            if ([model.finallynum isEqualToString:@"0"]) {
                
                [Utils postMessage:[NSString stringWithFormat:@"暂无%@记录，请添加记录吧",model.name] onView:self.view];
                
                return;
                
            }
            
            WeightViewController *weight = [WeightViewController new];
            
            weight.ID  =model.id;
   
            [self.navigationController pushViewController:weight animated:YES];
            
        }else if (indexPath.row == 1){
            
            if ([model.finallynum isEqualToString:@"0"]) {
                
                [Utils postMessage:[NSString stringWithFormat:@"暂无%@记录，请添加记录吧",model.name] onView:self.view];
                
                return;
                
            }
            
            
            BloodSugarViewController *blood = [BloodSugarViewController new];
            
            blood.ID  =model.id;

            [self.navigationController pushViewController:blood animated:YES];
            
        }else if (indexPath.row== 2){
            
            if ([model.finallynum isEqualToString:@"0"]) {
                
                [Utils postMessage:[NSString stringWithFormat:@"暂无%@记录，请添加记录吧",model.name] onView:self.view];
                
                return;
                
            }
            
            BloodPressureViewController *suger = [BloodPressureViewController new];
            
            suger.ID  =model.id;

            [self.navigationController pushViewController:suger animated:YES];
            
        }
        
    }else{
    
        IndexListModel *model = [self.list2 objectAtIndex:indexPath.row];

        if ([model.finallynum isEqualToString:@"0"]) {
            
            [Utils postMessage:[NSString stringWithFormat:@"暂无%@记录，请添加记录吧",model.name] onView:self.view];
            
            return;
            
        }
        
        TumorMarkerViewController *tum = [TumorMarkerViewController new];
        
        tum.ID = model.id;
        
        [self.navigationController pushViewController:tum animated:YES];
        
    }
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
