//
//  AppionmentSearchViewController.m
//  FreelyHeath
//
//  Created by L on 2018/5/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentSearchViewController.h"
#import "MulChooseTable.h"
#import "SelectTeamApi.h"
#import "SeLectTeamListRequest.h"
#import "JopModel.h"
#import "GroupConSearchModel.h"
#import "GroupSearchRequest.h"
#import "getroupListApi.h"
#import "TableChooseCell.h"
#import <TPKeyboardAvoidingTableView.h>
#define HeaderHeight 50
#define CellHeight 106
#import "GroupConSearchModel.h"
#import "MBProgressHUD+BWMExtension.h"
typedef void(^ChooseBlock) (NSString *chooseContent,NSMutableArray *chooseArr);

@interface AppionmentSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ApiRequestDelegate>
{
    NSMutableArray * dataArr;
}

@property (nonatomic,strong)MBProgressHUD *hub;

@property(nonatomic,strong)NSMutableArray * choosedArr;
@property(nonatomic,copy)ChooseBlock block;
@property (nonatomic,assign)BOOL ifAllSelected;
@property (nonatomic,assign)BOOL ifAllSelecteSwitch;

@property (nonatomic,strong)UISearchBar *searchbar;

@property (nonatomic,strong)TPKeyboardAvoidingTableView *table;  //团队tableview

@property (nonatomic,strong)TPKeyboardAvoidingTableView *MyTable;  //成员tableview

@property (nonatomic,strong)NSArray *teamArray;

@property (nonatomic,strong)NSArray *memberArray;

@property (nonatomic,strong)UIButton *sureButton;

@property (nonatomic,strong)SelectTeamApi *api;   //预设团队团队

@property (nonatomic,strong)getroupListApi *doctorApi;   //预设团队

@property (nonatomic,strong)UILabel *countLabel;
@property (nonatomic,strong)UIView *sepview;

@property (nonatomic,strong)NSMutableArray *selectArr;

@end

@implementation AppionmentSearchViewController

- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,kScreenHeight - 45, kScreenWidth - 123, 45)];
    NSString *startstr = [NSString stringWithFormat:@"    已选择%@人",self.count];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:startstr];
    self.countLabel.textColor = AppStyleColor;
    NSLog(@"==========%lu",(unsigned long)startstr.length);
     [str addAttribute:NSForegroundColorAttributeName value:DefaultGrayTextClor range:NSMakeRange(0,7)];
     [str addAttribute:NSFontAttributeName value:FontNameAndSize(14) range:NSMakeRange(0,7)];
     [str addAttribute:NSForegroundColorAttributeName value:DefaultGrayTextClor range:NSMakeRange(startstr.length-1,1)];
     [str addAttribute:NSFontAttributeName value:FontNameAndSize(14) range:NSMakeRange(startstr.length-1,1)];
    self.countLabel.attributedText = str;
//    self.countLabel.text = [NSString stringWithFormat:@"    已选择%@人",self.count];
    self.countLabel.font = FontNameAndSize(16);
    self.countLabel.backgroundColor = [UIColor whiteColor];
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    [[UIApplication sharedApplication].keyWindow addSubview:self.countLabel];
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.backgroundColor = AppStyleColor;
    _sureButton.frame = CGRectMake(CGRectGetMaxX(self.countLabel.frame), kScreenHeight - 45, 123, 45);
    _sureButton.titleLabel.font = FontNameAndSize(15);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureButton addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sureButton];
    self.sepview = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight - 45, kScreenWidth, 0.5)];
    self.sepview.backgroundColor = HexColor(0xe7e7e9);
    [[UIApplication sharedApplication].keyWindow addSubview:self.sepview];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.countLabel removeFromSuperview];
    [self.sureButton removeFromSuperview];
    [self.sepview removeFromSuperview];

}

- (void)sureAction{
  
    if (self.sure) {
        NSArray *arr = [self originArray:self.defaultMember withchooseArr:_choosedArr];
        self.sure(arr);
    };
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSArray *)originArray:(NSArray *)originArr withchooseArr:(NSArray *)chooseArr{
    NSMutableArray *arr = [NSMutableArray array];
    [arr removeAllObjects];
    
    for (GroupConSearchModel *model in chooseArr) {
        [arr addObject:model.dusername];
    }
    for (NSString *str in originArr) {
        [arr addObject:str];
    }
    NSLog(@"default:%@",originArr);
    NSLog(@"zuihou:%@",arr);
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",originArr];
    //过滤数组
    NSArray * resultArray = [arr filteredArrayUsingPredicate:filterPredicate];
    for (NSString *str in resultArray) {
        [arr addObject:str];
    }
    NSArray *endArr = [arr valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    return endArr;
}

//  将数组重复的对象去除，只保留一个

- (SelectTeamApi *)api
{
    if (!_api) {
        _api = [[SelectTeamApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (getroupListApi *)doctorApi
{
    if (!_doctorApi) {
        _doctorApi = [[getroupListApi alloc]init];
        _doctorApi.delegate  = self;
    }
    return _doctorApi;
}

- (TPKeyboardAvoidingTableView *)table
{
    if (!_table) {
        _table = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-64) style:UITableViewStyleGrouped];
        _table.backgroundColor = [UIColor whiteColor];
        _table.delegate = self;
        _table.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
    }
    return _table;
    
}
- (TPKeyboardAvoidingTableView *)MyTable
{
    if (!_MyTable) {
        _MyTable = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight- 64 - 64- 50) style:UITableViewStylePlain];
        _MyTable.separatorStyle = UITableViewStylePlain;
        _MyTable.backgroundColor = [UIColor whiteColor];
        _MyTable.delegate = self;
        _MyTable.dataSource = self;
        _table.showsVerticalScrollIndicator = NO;
    }
    return _MyTable;
}


- (UIButton *)sureButton
{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = AppStyleColor;
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:18.0f];
    }
    return _sureButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.searchbar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
    // 设置SearchBar的颜色主题为白色
    self.searchbar.backgroundColor = [UIColor whiteColor];
    self.searchbar.placeholder = @"按团队名称/医生姓名";
    self.searchbar.delegate = self;
    [self.view addSubview:self.searchbar];
    UITextField *searchField = [self.searchbar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:DefaultBackgroundColor];
        searchField.layer.cornerRadius = 1.0f;
        searchField.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];
        searchField.layer.borderColor = DefaultBackgroundColor.CGColor;
        searchField.layer.borderWidth = 3;
        searchField.layer.masksToBounds = NO;
    }
    [self.view addSubview:self.table];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.table.hidden = NO;
    
    _choosedArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view addSubview:self.MyTable];
    
    self.MyTable.hidden = YES;
    
    [self.view addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.sureButton.hidden = YES;
    
    [self.sureButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    teamLHeader *head = [[teamLHeader alloc]init];
    //
    head.target = @"userHuizhenControl";
    
    head.method = @"getTeamList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;

    teamLBody *body = [[teamLBody alloc]init];
    
    SeLectTeamListRequest *request = [[SeLectTeamListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api gethosteamList:request.mj_keyValues.mutableCopy];
    
    // Do any additional setup after loading the view.
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIView *)CreateHeaderView_HeaderTitle:(NSString *)title{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, HeaderHeight)];
    UILabel * HeaderTitleLab = [[UILabel alloc]init];
    HeaderTitleLab.text = title;
    [headerView addSubview:HeaderTitleLab];
    [HeaderTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.top.equalTo(headerView.mas_top).offset(0);
        make.height.mas_equalTo(headerView.mas_height);
    }];
    UIButton *chooseIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseIcon.tag = 10;
    [chooseIcon setImage:[UIImage imageNamed:@"kuang_normal"] forState:UIControlStateNormal];
    [chooseIcon setImage:[UIImage imageNamed:@"kuang_sel"] forState:UIControlStateSelected];
    chooseIcon.userInteractionEnabled = NO;
    [headerView addSubview:chooseIcon];
    [chooseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(HeaderTitleLab.mas_right).offset(10);
        make.right.equalTo(headerView.mas_right).offset(-15);
        make.top.equalTo(headerView.mas_top);
        make.height.mas_equalTo(headerView.mas_height);
        make.width.mas_equalTo(50);
    }];
    
    UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.frame = CGRectMake(0, 0, headerView.frame.size.width, headerView.frame.size.height);
    [chooseBtn addTarget:self action:@selector(ChooseAllClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:chooseBtn];
    return headerView;
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
    [self.hub bwm_hideWithTitle:command.response.msg
                      hideAfter:kBWMMBProgressHUDHideTimeInterval
                        msgType:BWMMBProgressHUDMsgTypeError];
    
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    
    if (api == _api) {
        self.teamArray = responsObject;
        [self.table reloadData];
    }
    
    if (api == _doctorApi) {
        self.memberArray = responsObject;
        NSLog(@"%@",self.memberArray);
        [self.MyTable reloadData];
    }
    
//    if (api == _Addapi) {
//
//        //获取团队团队成员跳转传过去
//
//        [self.hub bwm_hideWithTitle:@"添加成功"
//                          hideAfter:kBWMMBProgressHUDHideTimeInterval
//                            msgType:BWMMBProgressHUDMsgTypeSuccessful];
//
//        getGroupHeader *head = [[getGroupHeader alloc]init];
//        //
//        head.target = @"huizhenControl";
//
//        head.method = @"huizhenPeople";
//
//        head.versioncode = Versioncode;
//
//        head.devicenum = Devicenum;
//
//        head.fromtype = Fromtype;
//
//        head.token = [User LocalUser].token;
//
//        getGroupBody *body = [[getGroupBody alloc]init];
//
//        body.id = self.groupID;  //会诊id
//
//        GetGroupInfoRequest *request = [[GetGroupInfoRequest alloc]init];
//
//        request.head = head;
//
//        request.body = body;
//
//        NSLog(@"%@",request);
//
//        [self.Infoapi getGroupInfo:request.mj_keyValues.mutableCopy];
//
//    }
    
//    if (api == _Infoapi) {
//
//        ShowViewController *invite = [ShowViewController new];
//
//        invite.title = @"会诊邀请";
//
//        invite.groupID = self.groupID;
//
//        invite.chooseArr = [GroupConSearchModel mj_objectArrayWithKeyValuesArray:responsObject[@"peoples"]];
//
//        [self.navigationController pushViewController:invite animated:YES];
//
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.MyTable) {
        return CellHeight;
    }else{
        return 40;
    }
    
}


-(void)click{
    
//    self.hub = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"正在添加..."];
//
//    sendHeader *head = [[sendHeader alloc]init];
//    //
//    head.target = @"huizhenControl";
//
//    head.method = @"huizhenPeopleAdd";
//
//    head.versioncode = Versioncode;
//
//    head.devicenum = Devicenum;
//
//    head.fromtype = Fromtype;
//
//    head.token = [User LocalUser].token;
//
//    sendBody *body = [[sendBody alloc]init];
//
//    body.id = self.groupID;    //会诊记录id
//
//    NSMutableArray *peoples = [NSMutableArray array];
//
//    for (GroupConSearchModel *model in _choosedArr) {
//
//        People *people  = [[People alloc]init];
//        people.did = model.did;
//        [peoples addObject:people];
//    }
//
//    body.peoples = peoples;
//
//    SendInviteRequest *request = [[SendInviteRequest alloc]init];
//
//    request.head = head;
//
//    request.body = body;
//
//    NSLog(@"%@",request);
//
//    [self.Addapi sendInvite:request.mj_keyValues.mutableCopy];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    }else{
        
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.table) {
        return self.teamArray.count;
    }else{
        return self.memberArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.table) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.textLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15.0f];
        JopModel *model = [self.teamArray safeObjectAtIndex:indexPath.row];
        cell.textLabel.text = model.name;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        NSString * identifier = [NSString stringWithFormat:@"cellId%ld",(long)indexPath.row];
        TableChooseCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!cell) {
            cell = [[TableChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        GroupConSearchModel *model = [self.memberArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.dusername;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:model.dfacepath] placeholderImage:[UIImage imageNamed:@"1.jpg"]];
        cell.jopLabel.text = [NSString stringWithFormat:@"%@  %@",model.dhospital,model.dpost];
        NSLog(@"%@%@%@%@",model.dusername,model.dfacepath,model.dhospital,model.dpost);
        if (_ifAllSelecteSwitch) {
            [cell UpdateCellWithState:_ifAllSelected];
            if (indexPath.row == self.memberArray.count-1) {
                _ifAllSelecteSwitch  = NO;
            }
        }
        [cell UpdateCellWithState:NO];
        if ([self.defaultMember containsObject:model.dusername]) {
            cell.isSelected  = YES;
            cell.userInteractionEnabled = NO;
            [cell UpdateCellWithState:cell.isSelected];
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.table) {
        JopModel *model = [self.teamArray safeObjectAtIndex:indexPath.row];
        self.searchbar.text = model.name;
        //按照团队进行搜索
        //搜索接口
        presearchHeader *head = [[presearchHeader alloc]init];
        head.target = @"userHuizhenControl";
        head.method = @"search";
        head.versioncode = Versioncode;
        head.devicenum = Devicenum;
        head.fromtype = Fromtype;
        head.token = [User LocalUser].token;
        presearchBody *body = [[presearchBody alloc]init];
        GroupSearchRequest *request = [[GroupSearchRequest alloc]init];
        request.head = head;
        request.body = body;
        body.keyword = self.searchbar.text;
        NSLog(@"%@",request);
        [self.doctorApi getDoctorSearchList:request.mj_keyValues.mutableCopy];
        self.table.hidden = YES;
        self.MyTable.hidden = NO;
        self.sureButton.hidden = NO;
        [self.view endEditing:YES];
        
    }else{
        
        TableChooseCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GroupConSearchModel *model = [self.memberArray objectAtIndex:indexPath.row];
        [cell UpdateCellWithState:!cell.isSelected];
        if (cell.isSelected) {
            NSArray *arr = [self originArray:self.defaultMember withchooseArr:_choosedArr];
            if (arr.count >=9) {
                [Utils postMessage:@"会诊人不能超过9人" onView:self.view];
                [cell UpdateCellWithState:!cell.isSelected];
                return;
            }
            [_choosedArr safeAddObject:model];
        }
        else{
            [_choosedArr removeObject:model];
        }
        
        if (_choosedArr.count<self.memberArray.count) {
            _ifAllSelected = NO;
            UIButton * chooseIcon = (UIButton *)[_MyTable.tableHeaderView viewWithTag:10];
            chooseIcon.selected = _ifAllSelected;
        }
        NSArray *arr = [self originArray:self.defaultMember withchooseArr:_choosedArr];
        NSString *startstr = [NSString stringWithFormat:@"    已选择%ld人",arr.count];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:startstr];
        self.countLabel.textColor = AppStyleColor;
        NSLog(@"==========%lu",(unsigned long)startstr.length);
        [str addAttribute:NSForegroundColorAttributeName value:DefaultGrayTextClor range:NSMakeRange(0,7)];
        [str addAttribute:NSFontAttributeName value:FontNameAndSize(14) range:NSMakeRange(0,7)];
        [str addAttribute:NSForegroundColorAttributeName value:DefaultGrayTextClor range:NSMakeRange(startstr.length-1,1)];
        [str addAttribute:NSFontAttributeName value:FontNameAndSize(14) range:NSMakeRange(startstr.length-1,1)];
        self.countLabel.attributedText = str;
        //    self.countLabel.text = [NSString stringWithFormat:@"    已选择%@人",self.count];
        NSLog(@"%@ %@",model.did,_choosedArr);
    }
}

#pragma mark-- uisearchbardelegate


- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    self.table.hidden = YES;
    self.MyTable.hidden = NO;
    self.sureButton.hidden = NO;
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.text.length <= 0) {
        self.table.hidden = NO;
        self.MyTable.hidden = YES;
        self.sureButton.hidden = YES;
    }else{
        self.table.hidden = YES;
        self.MyTable.hidden = NO;
        self.sureButton.hidden = NO;
    }
    return YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //搜索接口
    presearchHeader *head = [[presearchHeader alloc]init];
    head.target = @"userHuizhenControl";
    head.method = @"search";
    head.versioncode = Versioncode;
    head.devicenum = Devicenum;
    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    presearchBody *body = [[presearchBody alloc]init];
    GroupSearchRequest *request = [[GroupSearchRequest alloc]init];
    request.head = head;
    request.body = body;
    body.keyword = self.searchbar.text;
    NSLog(@"%@",request);
    [self.doctorApi getDoctorSearchList:request.mj_keyValues.mutableCopy];
    [self.view endEditing:YES];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    if (self.searchbar.text.length <= 0) {

        self.table.hidden = NO;

        self.MyTable.hidden = YES;

        self.sureButton.hidden = YES;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"----------%@",self.searchbar.text);
    if (self.searchbar.text.length <= 0) {
        
        self.table.hidden = NO;
        
        self.MyTable.hidden = YES;
        
        self.sureButton.hidden = YES;
    }
}

-(void)ChooseAllClick:(UIButton *)button{
    _ifAllSelecteSwitch = YES;
    UIButton * chooseIcon = (UIButton *)[_MyTable.tableHeaderView viewWithTag:10];
    chooseIcon.selected = !_ifAllSelected;
    _ifAllSelected = !_ifAllSelected;
    if (_ifAllSelected) {
        [_choosedArr removeAllObjects];
        [_choosedArr addObjectsFromArray:self.memberArray];
    }
    else{
        [_choosedArr removeAllObjects];
    }
    [_MyTable reloadData];
    _block(@"All",_choosedArr);
    
}


@end
