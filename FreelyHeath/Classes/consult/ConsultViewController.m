//
//  ConsultViewController.m
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ConsultViewController.h"
#import "consultHeadView.h"
#import "customTableViewCell.h"
#import "QuestionCenterViewController.h"
#import "FreeConsultViewController.h"
#import "UIImage+ImageEffects.h"
#import "IndexManagementViewController.h"
#import "IndexManagerFillDataViewController.h"
#import "ConsultApi.h"
#import "ConsultIndexRequest.h"
#import "WKWebViewController.h"
#import "ConsultIndexModel.h"
#import "ResultViewController.h"
#import "AssessmentRequest.h"
#import "AssApi.h"
#import "UINavigationController+NAV.h"
@interface ConsultViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ApiRequestDelegate>

@property (nonatomic,strong)UITableView *consultTableView;

@property (nonatomic,strong)consultHeadView *headView;

@property (nonatomic,strong)ConsultApi *consultApi;

@property (nonatomic,strong)ConsultIndexModel *model;

@property (nonatomic,strong)AssApi *isAssApi;



@end


@implementation ConsultViewController


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    [LSProgressHUD hide];
    
    
    if (api == _consultApi) {
        
        NSLog(@"[[[[[[[[%@",responsObject);
        
        self.model = [ConsultIndexModel mj_objectWithKeyValues:responsObject];
        
        [self.consultTableView reloadData];

    }
    
    if (api == _isAssApi) {
        
        if ([responsObject[@"isassessment"] isEqualToString:@"0"]) {
            
            NSLog(@"%@",responsObject[@"isassessment"]);
            
             [[EmptyManager sharedManager]showEmptyOnView:self.consultTableView withImage:[UIImage imageNamed:@"consult_emptyPage"] explain:@"在线评估健康评估\n获取免费专业咨询" operationText:@"立即评估" operationBlock:^{
             
             if ([Utils showLoginPageIfNeeded]) {
             
                 
                 
             }else{
             
                 //去评估
                 WKWebViewController *ass = [WKWebViewController new];
                 
                 [ass loadWebURLSring:[NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/pinggu_list.html?token=%@",[User LocalUser].token]];
                 
                 //        ass.hidesBottomBarWhenPushed = YES;
                 
                 ass.title = @"评估";
                 
                 [self.navigationController pushViewController:ass animated:YES];
                 
             }
             
             }];
            
            
        }else{
        
            [[EmptyManager sharedManager]removeEmptyFromView:self.consultTableView];
            ConsultHeader *header = [[ConsultHeader alloc]init];
            
            header.target = @"assessmentControl";
            
            header.method = @"consultFirst";
            
            header.versioncode = Versioncode;
            
            header.devicenum = Devicenum;
            
            header.fromtype = Fromtype;
            
            header.token = [User LocalUser].token;
            
            ConsultBody *bodyer = [[ConsultBody alloc]init];
            
            ConsultIndexRequest *requester = [[ConsultIndexRequest alloc]init];
            
            requester.head = header;
            
            requester.body = bodyer;
            
            NSLog(@"%@",requester);
            
            [self.consultApi getassConsult:requester.mj_keyValues.mutableCopy];
            
            
        }

    }
    
    [self.consultTableView reloadData];

    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{

    [LSProgressHUD hide];
    
}


- (ConsultApi *)consultApi
{

    if (!_consultApi) {
        
        _consultApi = [[ConsultApi alloc]init];
        
        _consultApi.delegate  =  self;
        
    }
    
    return _consultApi;

}

- (AssApi *)isAssApi
{

    if (!_isAssApi) {
        
        _isAssApi = [[AssApi alloc]init];
        
        _isAssApi.delegate = self;
        
    }

    return _isAssApi;
    

}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self hiddenNavigationControllerBar:NO];

    [self.navigationController setNeedsNavigationBackground:0.05];
    
    if ([User hasLogin]== YES) {
        
        
        [LSProgressHUD showWithMessage:nil];
        
        ConsultHeader *header = [[ConsultHeader alloc]init];
        
        header.target = @"assessmentControl";
        
        header.method = @"consultFirst";
        
        header.versioncode = Versioncode;
        
        header.devicenum = Devicenum;
        
        header.fromtype = Fromtype;
        
        header.token = [User LocalUser].token;
        
        ConsultBody *bodyer = [[ConsultBody alloc]init];
        
        ConsultIndexRequest *requester = [[ConsultIndexRequest alloc]init];
        
        requester.head = header;
        
        requester.body = bodyer;
        
        NSLog(@"%@",requester);
        
        [self.consultApi getassConsult:requester.mj_keyValues.mutableCopy];

        [LSProgressHUD showWithMessage:nil];

        assHeader *head = [[assHeader alloc]init];
        
        head.target = @"assessmentControl";
        
        head.method = @"assessment";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        assBody *body = [[assBody alloc]init];
        
        AssessmentRequest *request = [[AssessmentRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.isAssApi getass:request.mj_keyValues.mutableCopy];
        
    }else{
    
        
        [[EmptyManager sharedManager]showEmptyOnView:self.consultTableView withImage:[UIImage imageNamed:@"consult_emptyPage"] explain:@"在线评估健康评估\n获取免费专业咨询" operationText:@"立即评估" operationBlock:^{
            
            if ([Utils showLoginPageIfNeeded]) {
                
                
            }else{
                
                //去评估
                WKWebViewController *ass = [WKWebViewController new];
                
                [ass loadWebURLSring:[NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/pinggu_list.html?token=%@",[User LocalUser].token]];
                
                //        ass.hidesBottomBarWhenPushed = YES;
                
                ass.title = @"评估";
                
                [self.navigationController pushViewController:ass animated:YES];
                
                
            }
            
        }];
        
    
    }
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self scrollViewDidScroll:self.consultTableView];
    
    
    
}


- (UITableView *)consultTableView
{
    
    if (!_consultTableView) {
        
        _consultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        
        _consultTableView.delegate = self;
        
        _consultTableView.dataSource = self;
        
        _consultTableView.backgroundColor = DefaultBackgroundColor;
        
        
    }
    
    return _consultTableView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tabbar_sdcenter", nil);

//    [self setRightNavigationItemWithTitle:@"评估" action:@selector(toValuteAction)];
    
    self.view.backgroundColor = DefaultBackgroundColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.headView = [[consultHeadView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth, 216.5)];
    
    [self.consultTableView registerClass:[customTableViewCell class] forCellReuseIdentifier:NSStringFromClass([customTableViewCell class])];
        self.consultTableView.tableHeaderView = self.headView;
    
    [self.view addSubview:self.consultTableView];

    //导航
  
    //免费咨询
    
    weakify(self);
    
    
    self.headView.eva = ^(){
    
        if ([Utils showLoginPageIfNeeded]) {
            
        } else {
            strongify(self);
            //去评估
//            WKWebViewController *ass = [WKWebViewController new];
//            
//            [ass loadWebURLSring:[NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/pinggu_list.html?token=%@",[User LocalUser].token]];
//            
//            //        ass.hidesBottomBarWhenPushed = YES;
//            
//            ass.title = @"评估";
//            
//            [self.navigationController pushViewController:ass animated:YES];
            
            
        }

    
    };
    
    self.headView.FreeConsultation = ^{
        
        FreeConsultViewController *freeConsult = [FreeConsultViewController new];
        
        freeConsult.title = @"提问";
        
        strongify(self);
        
        [self.navigationController pushViewController:freeConsult animated:YES];
        
    };
    
    self.headView.OneshotInterpretation = ^{
        
        
        if ([Utils showLoginPageIfNeeded]) {
            
        }else{
            
            IndexManagerFillDataViewController *indexManager = [IndexManagerFillDataViewController new];
            
            indexManager.title = @"每日一记";
            
            strongify(self);
            
            [self.navigationController pushViewController:indexManager animated:YES];
            
        }
        
        
    };
    
    
    //
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 355;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    customTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([customTableViewCell class])];

    [cell refreshWithModel:self.model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.ques = ^(NSInteger index){
    
        QuestionCenterViewController *qcenter = [QuestionCenterViewController new];
        
        qcenter.title = @"问答中心";
        
        [self.navigationController pushViewController:qcenter animated:YES];
        
    };
    
    
    cell.result = ^{
  
        
        if ([Utils showLoginPageIfNeeded]) {
            
        }else{
            
            ResultViewController *result = [ResultViewController new];
            
            result.title = @"评估结果";
            
            result.redult = self.model.suggest;
            
            result.hidesBottomBarWhenPushed  = YES;
            
            [self.navigationController pushViewController:result animated:YES];
            
        }
        
    };
    
    return cell;
    
}



- (void)toValuteAction{

    
    if ([Utils showLoginPageIfNeeded]) {
        
    } else {
       
        
     
        //去评估
//        WKWebViewController *ass = [WKWebViewController new];
//        
//        [ass loadWebURLSring:[NSString stringWithFormat:@"https://api.zhiyi365.cn/h5/pinggu_list.html?token=%@",[User LocalUser].token]];
//        
////        ass.hidesBottomBarWhenPushed = YES;
//        
//        ass.title = @"评估";
//        
//        [self.navigationController pushViewController:ass animated:YES];
        
    }

}


#pragma mark -  UITableViewDelegate
//开始拖拽
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//停止
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offset_Y = scrollView.contentOffset.y;
    
    //NSLog(@"上下偏移量 OffsetY:%f ->",offset_Y);
    
    //1.处理图片放大
    CGFloat imageH = self.headView.size.height;
    CGFloat imageW = kScreenWidth;
    
    //下拉
    if (offset_Y < 0)
    {
        CGFloat totalOffset = imageH + ABS(offset_Y);
        CGFloat f = totalOffset / imageH;
        
        //如果想下拉固定头部视图不动，y和h 是要等比都设置。如不需要则y可为0
        self.headView.backGroungImage.frame = CGRectMake(-(imageW * f - imageW) * 0.5, offset_Y, imageW * f, totalOffset);
    }
    else
    {
        self.headView.backGroungImage.frame = self.headView.bounds;
    }
    
    //2.处理导航颜色渐变  3.底部工具栏动画
    
    if (offset_Y > Max_OffsetY)
    {
//        CGFloat alpha = MIN(1, 1 - ((Max_OffsetY + INVALID_VIEW_HEIGHT - offset_Y) / INVALID_VIEW_HEIGHT));
        
//        [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:alpha]];
//        
//              self.title = alpha > 0.5 ? @"咨询":@"";
    }
    else
    {
//        [self.navigationController.navigationBar ps_setBackgroundColor:[AppStyleColor colorWithAlphaComponent:1]];
        
    }
    
 
}


- (void)viewWillDisappear:(BOOL)animated {
   [self hiddenNavigationControllerBar:NO];
    [self.navigationController setNeedsNavigationBackground:1.0f];

    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];
//    [self.navigationController.navigationBar ps_reset];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self hiddenNavigationControllerBar:NO];
    [self.navigationController setNeedsNavigationBackground:1.0f];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setShadowImage:[UINavigationBar appearance].shadowImage];


}

@end
