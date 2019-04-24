//
//  QuestionCenterViewController.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QuestionCenterViewController.h"
#import "QuestionTableViewCell.h"
#import "QuestionDetailViewController.h"
#import "ToQuestionViewController.h"
#import "ZLImageViewDisplayView.h"
#import "QAcenterApi.h"
#import "QAcenterRequest.h"
#import "bannerModel.h"
#import "QAHomeApi.h"
#import "QAHomeListModel.h"
#import "WAHomePageRequest.h"
#import "User.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"
#import "ThumpApi.h"
#import "ThumpRequest.h"
@interface QuestionCenterViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
{
    NSArray *_imagesURLStrings;
}
@property (nonatomic,strong)UITableView *searchTableView;

@property (nonatomic,strong)UIView *headView;

@property (nonatomic,strong)UITextView *content;

@property (nonatomic,strong)QAcenterApi *getBanner;

@property (nonatomic,strong)QAHomeApi *homeApi;

@property (nonatomic,strong)NSMutableArray *bannerArray;

@property (nonatomic,strong)NSMutableArray *listArray;

@property (nonatomic,strong)ZLImageViewDisplayView *imageViewDisplay;

@property (nonatomic,strong)ThumpApi *thumpApi;



@end

@implementation QuestionCenterViewController

- (NSMutableArray *)bannerArray
{

    if (!_bannerArray) {
        
        _bannerArray = [NSMutableArray array];
    }
    
    return _bannerArray;
    
}

- (ThumpApi *)thumpApi
{
    
    if (!_thumpApi) {
        _thumpApi = [[ThumpApi alloc]init];
        
        _thumpApi.delegate  =self;
        
    }
    
    return _thumpApi;
    
    
}


- (NSMutableArray *)listArray
{
    
    if (!_listArray) {
        
        _listArray = [NSMutableArray array];
    }
    
    return _listArray;
    
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    QARequestHeader *head = [[QARequestHeader alloc]init];
    
    head.target = @"noTokenForumControl";
    
    head.method = @"getBannerList";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    QARequestBody *body = [[QARequestBody alloc]init];
    
    QAcenterRequest *request = [[QAcenterRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.getBanner getBannerListWithRequest:request.mj_keyValues.mutableCopy];

}


- (QAcenterApi *)getBanner
{

    if (!_getBanner) {
        
        _getBanner = [[QAcenterApi alloc]init];
        
        _getBanner.delegate = self;
        
    }
    
    return _getBanner;
    
}


- (QAHomeApi *)homeApi
{
    
    if (!_homeApi) {
        
        _homeApi = [[QAHomeApi alloc]init];
        
        _homeApi.delegate = self;
        
        
    }
    
    return _homeApi;
    
}



- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    
    [self.searchTableView.mj_header endRefreshing];

    [LSProgressHUD hide];

    NSLog(@"%@",responsObject);
    
    if (api == _getBanner) {
        
        self.bannerArray = responsObject;
        
        //获取要显示的位置
        
        CGRect frame = CGRectMake(0,0,kScreenWidth, 166);
        
//        //初始化控件
//        self.imageViewDisplay = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame];
//        self.imageViewDisplay.scrollInterval = 3;
//        self.imageViewDisplay.animationInterVale = 0.6;
//        [self.headView addSubview:self.imageViewDisplay];
//
//        NSMutableArray *banners = [NSMutableArray array];
//
//        for (bannerModel *model in self.bannerArray) {
//
////            NSLog(@"%@",model.imgpath);
////
////            model.imgpath  = [model.imgpath stringByReplacingOccurrencesOfString:@"!/format/webp" withString:@""];
////
////            [banners addObject:model.imgpath];
//
//        }
//        NSLog(@"self.bannerArray%@",self.bannerArray);
//
//        self.imageViewDisplay.imageViewArray = banners;
//
//        NSLog(@"self.imageViewDisplay.imageViewArray%@",self.imageViewDisplay.imageViewArray);

        
    }
    
    
    if (api == _homeApi) {
        
        NSLog(@"%@",responsObject);
        
        self.listArray = [QAHomeListModel mj_objectArrayWithKeyValuesArray:responsObject[@"questions"]];
        
        [self.searchTableView reloadData];

    }
    
    if (api == _thumpApi) {
        
        [Utils postMessage:@"点赞成功" onView:self.view];
        
        QAHomeRequestHeader *head = [[QAHomeRequestHeader alloc]init];
        
        head.target = @"noTokenForumControl";
        
        head.method = @"homePage";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        QAHomeRequestBody *body = [[QAHomeRequestBody alloc]init];
        
        WAHomePageRequest *request = [[WAHomePageRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.homeApi getHomeListWithRequest:request.mj_keyValues.mutableCopy];
        
    }
    
    [self.searchTableView reloadData];

    
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
    [self.searchTableView.mj_header endRefreshing];
    
    
    [LSProgressHUD hide];
    
    
    

    if (api == _thumpApi) {
        
        if ([command.response.code isEqualToString:@"30005"]) {
            
            [Utils postMessage:command.response.msg onView:self.view];

            
        }
        

    }
    

}



- (UITableView *)searchTableView
{

    if (!_searchTableView) {
        
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _searchTableView.delegate = self;
        
        _searchTableView.dataSource = self;
        
        _searchTableView.backgroundColor = DefaultBackgroundColor;
        
    }
    
    return _searchTableView;
    
}

- (void)layOutsubview{

    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}

-(void) addZLImageViewDisPlayView{
    
    [self.imageViewDisplay addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        NSString *str = [NSString stringWithFormat:@"我是第%ld张图片", imageIndex];
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alter show];
    }];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    self.headView.backgroundColor = [UIColor whiteColor];
    
    [self addZLImageViewDisPlayView];

    UIView *line = [[UIView alloc]init];
    
    [self.headView addSubview:line];
    
    line.backgroundColor = DefaultBackgroundColor;
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(166);
    }];
    
   [self setRightNavigationItemWithTitle:@"提问" action:@selector(toQuestion)];
//
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self.view addSubview:self.searchTableView];
    
    [self layOutsubview];
    
    [self.searchTableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QuestionTableViewCell class])];
     [self.searchTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.searchTableView.tableHeaderView = self.headView;
    
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [LSProgressHUD showWithMessage:nil];
    
    
    self.searchTableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        QAHomeRequestHeader *head = [[QAHomeRequestHeader alloc]init];
        
        head.target = @"noTokenForumControl";
        
        head.method = @"homePage";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        QAHomeRequestBody *body = [[QAHomeRequestBody alloc]init];
        
        WAHomePageRequest *request = [[WAHomePageRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.homeApi getHomeListWithRequest:request.mj_keyValues.mutableCopy];

        
    }];
    
    
    [self.searchTableView.mj_header beginRefreshing];
    
    
}



- (void)toQuestion{

    ToQuestionViewController *question = [ToQuestionViewController new];
    
    question.title = @"提问";
    
    [self.navigationController pushViewController:question animated:YES];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   return self.listArray.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([QuestionTableViewCell class]) cacheByIndexPath:indexPath configuration:^(QuestionTableViewCell *cell) {
        
        QAHomeListModel *model = [self.listArray objectAtIndex:indexPath.row];

        [cell refreModel:model];

    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QAHomeListModel *model = [self.listArray objectAtIndex:indexPath.row];

    
    cell.thump = ^(){
        
        
        thumpHeader *head = [[thumpHeader alloc]init];
        
        head.target = @"forumControl";
        
        head.method = @"userAgree";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        thumpBody *body = [[thumpBody alloc]init];
        
//        body.id = model.id;
        
        ThumpRequest *request = [[ThumpRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.homeApi getHomeListWithRequest:request.mj_keyValues.mutableCopy];

        
    };
    
    
        [cell refreModel:model];
    
    
    
        return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

        QuestionDetailViewController *questionDetail = [QuestionDetailViewController new];
    
        QAHomeListModel *model = [self.listArray objectAtIndex:indexPath.row];

        questionDetail.title = @"问答详情";
    
        questionDetail.aid = model.id;
    
        questionDetail.question = model.title;
    
        [self.navigationController pushViewController:questionDetail animated:YES];

}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
