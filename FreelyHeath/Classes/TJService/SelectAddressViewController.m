//
//  SelectAddressViewController.m
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SelectAddressViewController.h"
#import "SelectAddressTableViewCell.h"
#import "JGListApi.h"
#import "JGListRequest.h"
#import "UIImage+GradientColor.h"
@interface SelectAddressViewController ()<UISearchBarDelegate,UISearchDisplayDelegate,ApiRequestDelegate>
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic,strong)JGListApi *api;
@property (nonatomic,strong)JGListApi *api1;
@property (nonatomic,strong)NSMutableArray *jopArray;
@end

@implementation SelectAddressViewController

- (void)commonInit
{
    JGListHeader *head = [[JGListHeader alloc]init];
    //
    head.target = @"orderControl";

    head.method = @"getJiGous";

    head.versioncode = Versioncode;

    head.devicenum = Devicenum;

    head.fromtype = Fromtype;
    head.token = [User LocalUser].token;
    JGListBody *body = [[JGListBody alloc]init];

    body.id = self.packageid;
    body.cityid = self.packageCityId;
    
    JGListRequest *request = [[JGListRequest alloc]init];

    request.head = head;

    request.body = body;

    NSLog(@"%@",request);

    [self.api getJGList:request.mj_keyValues.mutableCopy];

}

- (id)initWithid:(NSString *)id cityid:(NSString *)cityid {
    // 调用父类的指定初始化方法
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.packageid = id;
        self.packageCityId = cityid;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self initWithid:self.packageid cityid:self.packageCityId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:AppStyleColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:AppStyleColor]];
}

- (JGListApi *)api
{
    if (!_api) {
        _api = [[JGListApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (JGListApi *)api1
{
    if (!_api1) {
        _api1 = [[JGListApi alloc]init];
        _api1.delegate = self;
    }
    return _api1;
}

- (NSMutableArray *)jopArray
{
    if (!_jopArray) {
        _jopArray = [NSMutableArray array];
    }
    return _jopArray;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    _searchResults = responsObject;
    if (api == _api) {
        _names = responsObject;
        [self.tableView reloadData];
    }
    if (api == _api1) {
        _searchResults = responsObject;
        [self.searchController.searchResultsTableView reloadData];
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"体检机构";
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self configureTableView:self.tableView];
    [self addSearchBarAndSearchDisplayController];
}

- (void)addSearchBarAndSearchDisplayController {

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索符合条件的体检机构";
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(kScreenWidth, 64)];
    searchBar.backgroundImage = bgImg;

    self.tableView.tableHeaderView = searchBar;

    UISearchDisplayController *searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;

    self.searchController = searchDisplayController;
}
//
////===============================================
//#pragma mark -
//#pragma mark Helper
////===============================================
//
- (void)configureTableView:(UITableView *)tableView {
    tableView.separatorInset = UIEdgeInsetsZero;
    [tableView registerClass:[SelectAddressTableViewCell class] forCellReuseIdentifier:NSStringFromClass([SelectAddressTableViewCell class])];
    UIView *tableFooterViewToGetRidOfBlankRows = [[UIView alloc] initWithFrame:CGRectZero];
    tableFooterViewToGetRidOfBlankRows.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = tableFooterViewToGetRidOfBlankRows;
}
//
////===============================================
//#pragma mark -
//#pragma mark UITableView
////===============================================
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.tableView) {
        return [self.names count];
    }
    else {
        return [self.searchResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {



    if (tableView == self.tableView) {

        SelectAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectAddressTableViewCell class]) forIndexPath:indexPath];

        JGModel *model = [_names objectAtIndex:indexPath.row];

        [cell refreshWithModel:model];

        return cell;

    }else {

        SelectAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectAddressTableViewCell class]) forIndexPath:indexPath];

        JGModel *model = [_searchResults objectAtIndex:indexPath.row];

        [cell refreshWithModel:model];

        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == self.tableView) {

        JGModel *model = [_names objectAtIndex:indexPath.row];

        if (self.hospital) {

            self.hospital(model);
        }

        [self.navigationController popViewControllerAnimated:YES];

    }else{

        JGModel *model = [_searchResults objectAtIndex:indexPath.row];

        if (self.hospital) {

            self.hospital(model);
        }

        [self.view endEditing:YES];

        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
//
////===============================================
//#pragma mark -
//#pragma mark UISearchDisplayDelegate
////===============================================

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | will begin search");
    controller.searchBar.barTintColor = AppStyleColor;
}
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | did begin search");
    controller.searchBar.barTintColor = AppStyleColor;

}
- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | will end search");
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    NSLog(@"🔦 | did end search");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did load table");
    [self configureTableView:tableView];
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will unload table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will show table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did show table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller willHideSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | will hide table");
}
- (void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    NSLog(@"🔦 | did hide table");
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"🔦 | should reload table for search string?");
    JGListHeader *head = [[JGListHeader alloc]init];
    //
    head.target = @"orderControl";

    head.method = @"getJiGous";

    head.versioncode = Versioncode;

    head.devicenum = Devicenum;

    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    JGListBody *body = [[JGListBody alloc]init];
    body.keyword = searchString;
    body.id = self.packageid;
    body.cityid = self.packageCityId;
    JGListRequest *request = [[JGListRequest alloc]init];

    request.head = head;

    request.body = body;

    NSLog(@"%@",request);

    [self.api1 getJGList:request.mj_keyValues.mutableCopy];

    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    NSLog(@"🔦 | should reload table for search scope?");
    return YES;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    JGListHeader *head = [[JGListHeader alloc]init];
    //
    head.target = @"orderControl";

    head.method = @"getJiGous";

    head.versioncode = Versioncode;

    head.devicenum = Devicenum;

    head.fromtype = Fromtype;

    JGListBody *body = [[JGListBody alloc]init];
    body.keyword = searchBar.text;
    body.id = self.packageid;
    body.cityid = self.packageCityId;
    JGListRequest *request = [[JGListRequest alloc]init];

    request.head = head;

    request.body = body;

    NSLog(@"%@",request);

    [self.api1 getJGList:request.mj_keyValues.mutableCopy];

}
//


@end
