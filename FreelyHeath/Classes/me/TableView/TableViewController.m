
#import "TableViewHeaderView.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "CategoryModel.h"
#import "TableViewController.h"
#import "NSObject+Property.h"
#import "getCancerListApi.h"
#import "GetCancerListRequest.h"
#import "CancerModel.h"
static float kLeftTableViewWidth = 100.f;

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource,ApiRequestDelegate>

@property (nonatomic, strong) NSMutableArray *categoryData;
@property (nonatomic, strong) NSMutableArray *foodData;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) getCancerListApi *api;
@end

@implementation TableViewController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在加载中...";
}

- (getCancerListApi *)api{
    if (!_api) {
        _api = [[getCancerListApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils postMessage:command.response.msg onView:self.view];
        // Do something...
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
  
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSArray *foods = responsObject[@"aizhengs"];

        for (NSDictionary *dict in foods)
        {
            CategoryModel *model = [CategoryModel objectWithDictionary:dict];
            [self.categoryData addObject:model];
    
            NSMutableArray *datas = [NSMutableArray array];
            for (FoodModel *f_model in model.shuxing)
            {
                [datas addObject:f_model];
            }
            [self.foodData addObject:datas];
        }
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    CancerHeader *head = [[CancerHeader alloc]init];
    
    head.target = @"tjjyServeControl";
    
    head.method = @"getAiZhengList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    CancerBody *body = [[CancerBody alloc]init];
    
    GetCancerListRequest *request = [[GetCancerListRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    [self.api sublistDetail:request.mj_keyValues.mutableCopy];
    
    _selectIndex = 0;
    _isScrollDown = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getters

- (NSMutableArray *)categoryData
{
    if (!_categoryData)
    {
        _categoryData = [NSMutableArray array];
    }
    return _categoryData;
}

- (NSMutableArray *)foodData
{
    if (!_foodData)
    {
        _foodData = [NSMutableArray array];
    }
    return _foodData;
}

- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftTableViewWidth, kScreenHeight)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 55;
        _leftTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:kCellIdentifier_Left];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLeftTableViewWidth, 0, kScreenWidth - kLeftTableViewWidth, kScreenHeight-30)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.separatorColor = [UIColor clearColor];
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:NSStringFromClass([RightTableViewCell class])];
    }
    return _rightTableView;
}

#pragma mark - TableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_leftTableView == tableView)
    {
        return 1;
    }
    else
    {
        return self.categoryData.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_leftTableView == tableView)
    {
        return self.categoryData.count;
    }
    else
    {
        return [self.foodData[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Left forIndexPath:indexPath];
        CategoryModel *model = self.categoryData[indexPath.row];
        cell.name.text = model.name;
        return cell;
    }
    else
    {
        RightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RightTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FoodModel *model = self.foodData[indexPath.section][indexPath.row];
        [cell refreshWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_rightTableView == tableView)
    {
        TableViewHeaderView *view = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        view.name.textColor = DefaultGrayTextClor;
        CategoryModel *model = self.categoryData[section];
        NSString *text = [NSString stringWithFormat:@"当前科普章节：%@",model.name];
        NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:text];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:AppStyleColor range:NSMakeRange(7, text.length - 7)];
        view.name.attributedText = attributeStr;
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.rightTableView)
    {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([RightTableViewCell class]) cacheByIndexPath:indexPath configuration: ^(RightTableViewCell *cell) {
            FoodModel *model = self.foodData[indexPath.section][indexPath.row];
            [cell refreshWithModel:model];
        }];
    }else{
        return 55;
    }
}

// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向上，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && !_isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section];
    }
}

// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // 当前的tableView是RightTableView，RightTableView滚动的方向向下，RightTableView是用户拖拽而产生滚动的（（主要判断RightTableView用户拖拽而滚动的，还是点击LeftTableView而滚动的）
    if ((_rightTableView == tableView)
        && _isScrollDown
        && (_rightTableView.dragging || _rightTableView.decelerating))
    {
        [self selectRowAtIndexPath:section + 1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_leftTableView == tableView)
    {
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;

    UITableView *tableView = (UITableView *) scrollView;
    if (_rightTableView == tableView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
