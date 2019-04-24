//
//  BCViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/14.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "BCViewController.h"
#import <TPKeyboardAvoidingTableView.h>
#import "ISTableViewCell.h"
#import "UpDateDetailTableViewCell.h"
#import "ACMediaFrame.h"
#import "UIView+ACMediaExt.h"
#import "CaseListRequest.h"
#import "EditBCApi.h"
#import "Utils.h"
#import "CaseDetailModel.h"
#import "CaseDetailApi.h"

@interface BCViewController ()<ApiRequestDelegate>{
    CGFloat _mediaH;
    ACSelectMediaView *_mediaView;

}

@property (nonatomic,strong)ACSelectMediaView *YWmamediaView;
@property (nonatomic,strong)ACSelectMediaView *BGmamediaView;

@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)ISTableViewCell *IsYoungYao;
@property (nonatomic,strong)ISTableViewCell *IsKouFu;
@property (nonatomic,strong)UpDateDetailTableViewCell *yongYaoDetail;
@property (nonatomic,strong)NSArray *data;
//
@property (nonatomic,strong)EditBCApi *api;
@property (nonatomic,strong)CaseDetailApi *detailapi;
@property (nonatomic,strong)CaseDetailModel *model;//是编辑还是修改
@property (nonatomic,assign)BOOL isEditOrUpdate;
//
@property (nonatomic,strong)NSMutableArray *YWselectImages;
@property (nonatomic,strong)NSMutableArray *YWselectImageUrls;
@property (nonatomic,strong)NSMutableArray *BGselectImages;
@property (nonatomic,strong)NSMutableArray *BGselectImageUrls;
//
@property (nonatomic,strong)NSMutableArray *EYWselectImages;
@property (nonatomic,strong)NSMutableArray *EYWselectImageUrls;
@property (nonatomic,strong)NSMutableArray *EBGselectImages;
@property (nonatomic,strong)NSMutableArray *EBGselectImageUrls;
@end

@implementation BCViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isEditEnter == YES) {
        [Utils addHudOnView:self.view withTitle:@"正在获取..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blDetail";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        bodyer.id = self.id;
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.detailapi detailCase:requester.mj_keyValues.mutableCopy];
    }
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    if (api == _api) {
        //返回到指定的控制器，要保证前面有入栈。
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        if (index >3) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-3)] animated:YES];
        }else
        {
            //            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if (api == _detailapi) {
        self.model = responsObject;
        if (self.model.ywimages.length > 0) {
            self.YWmamediaView.preShowMedias = [self.model.ywimages componentsSeparatedByString:@";"];
            self.YWselectImageUrls = [[self.model.ywimages componentsSeparatedByString:@";"] mutableCopy];
            [self.YWmamediaView reload];

        }

        if (self.model.blimages.length > 0) {
            self.BGmamediaView.preShowMedias = [self.model.blimages componentsSeparatedByString:@";"];
            self.BGselectImageUrls = [[self.model.blimages componentsSeparatedByString:@";"] mutableCopy];
            [self.BGmamediaView reload];
        }

        if (self.model.yaowu.length > 0) {
            self.yongYaoDetail.textView.text = self.model.yaowu;
        }
    }
}

- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}
- (ISTableViewCell *)IsYoungYao{
    if (!_IsYoungYao) {
        _IsYoungYao = [[ISTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_IsYoungYao setEditAble:NO];
        [_IsYoungYao setSex:@"0"];
        _IsYoungYao.selectionStyle = UITableViewCellSelectionStyleNone;
        [_IsYoungYao setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"用药记录"];
    }
    return _IsYoungYao;
}
- (ISTableViewCell *)IsKouFu{
    if (!_IsKouFu) {
        _IsKouFu = [[ISTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_IsKouFu setEditAble:NO];
        [_IsKouFu setSex:@"0"];
        _IsKouFu.selectionStyle = UITableViewCellSelectionStyleNone;
        [_IsKouFu setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"口服记录"];
    }
    return _IsKouFu;
}
- (UpDateDetailTableViewCell *)yongYaoDetail{
    if (!_yongYaoDetail) {
        _yongYaoDetail = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _yongYaoDetail.label.text = @"口服记录";
        _yongYaoDetail.textView.placeholder = @"记录所有服用的口服药物名称以及用药剂量\n并在下方上传处方单，口服药物图片记录。";
        _yongYaoDetail.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _yongYaoDetail;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _saveButton.backgroundColor = AppStyleColor;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveButton;
}

- (EditBCApi *)api{
    if (!_api) {
        _api = [[EditBCApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (CaseDetailApi *)detailapi{
    if (!_detailapi) {
        _detailapi = [[CaseDetailApi alloc]init];
        _detailapi.delegate = self;
    }
    return _detailapi;
}

//
- (NSMutableArray *)EBGselectImageUrls{
    if (!_EBGselectImageUrls) {
        _EBGselectImageUrls = [NSMutableArray array];
    }
    return _EBGselectImageUrls;
}

- (NSMutableArray *)EYWselectImageUrls{
    if (!_EYWselectImageUrls) {
        _EYWselectImageUrls = [NSMutableArray array];
    }
    return _EYWselectImageUrls;
}

- (NSMutableArray *)EBGselectImages{
    if (!_EBGselectImages) {
        _EBGselectImages = [NSMutableArray array];
    }
    return _EBGselectImages;
}

- (NSMutableArray *)EYWselectImages{
    if (!_EYWselectImages) {
        _EYWselectImages = [NSMutableArray array];
    }
    return _EYWselectImages;
}
#pragma mark AutolayOut
- (void)layoutsubview{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(105);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}
- (void)setheader{
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView *stepline = [[UIView alloc]init];
    
    stepline.backgroundColor = AppStyleColor;
    
    [topView addSubview:stepline];
    
    [stepline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.height.mas_equalTo(1.5);
        
    }];
    
    UIView *normalFlag = [[UIView alloc]init];
    
    normalFlag.backgroundColor = AppStyleColor;
    
    normalFlag.layer.cornerRadius = 10;
    
    normalFlag.layer.masksToBounds = YES;
    
    [topView addSubview:normalFlag];
    
    [normalFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stepline.mas_left);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UIImageView *img1 = [[UIImageView alloc]init];
    img1.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    [normalFlag addSubview:img1];
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    UIView *normalFlag1Line = [[UIView alloc]init];
    normalFlag1Line.backgroundColor = AppStyleColor;
    normalFlag1Line.layer.cornerRadius = 3.5;
    normalFlag1Line.layer.masksToBounds = YES;
    [stepline addSubview:normalFlag1Line];
    
    [normalFlag1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(stepline.mas_left);
        make.width.mas_equalTo((kScreenWidth - 80)/2);
        make.height.mas_equalTo(1.5);
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    
    UILabel *norLabel = [[UILabel alloc]init];
    [topView addSubview:norLabel];
    norLabel.textColor = AppStyleColor;
    norLabel.textAlignment = NSTextAlignmentCenter;
    norLabel.text = @"患者信息";
    norLabel.font = FontNameAndSize(15);
    [norLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(normalFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(normalFlag.mas_centerX);
    }];
    
    //
    
    UIView *authFlag = [[UIView alloc]init];
    authFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    authFlag.layer.cornerRadius = 10;
    authFlag.layer.masksToBounds = YES;
    authFlag.backgroundColor = AppStyleColor;
    [topView addSubview:authFlag];
    
    [authFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(stepline.mas_centerX);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UIImageView *img2 = [[UIImageView alloc]init];
    img2.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    [authFlag addSubview:img2];
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    UILabel *authLabel = [[UILabel alloc]init];
    [topView addSubview:authLabel];
    authLabel.textColor = AppStyleColor;
    authLabel.textAlignment = NSTextAlignmentCenter;
    authLabel.text = @"病史资料";
    authLabel.font = FontNameAndSize(15);
    [authLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(authFlag.mas_centerX);
    }];
    //
    UIView *noteFlag = [[UIView alloc]init];
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    noteFlag.layer.cornerRadius = 10;
    noteFlag.backgroundColor = AppStyleColor;
    noteFlag.layer.masksToBounds = YES;
    [topView addSubview:noteFlag];
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(stepline.mas_right);
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UIView *noteFlag1 = [[UIView alloc]init];
    noteFlag1.backgroundColor = [UIColor whiteColor];
    noteFlag1.layer.cornerRadius = 3.5;
    noteFlag1.layer.masksToBounds = YES;
    [noteFlag addSubview:noteFlag1];
    
    [noteFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
        make.width.height.mas_equalTo(7);
        make.centerY.mas_equalTo(noteFlag.mas_centerY);
    }];
    UILabel *noteLabel = [[UILabel alloc]init];
    [topView addSubview:noteLabel];
    noteLabel.textColor = AppStyleColor;
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.text = @"病程记录";
    noteLabel.font = FontNameAndSize(15);
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setheader];
    [self.view addSubview:self.tableView];
    [self layoutsubview];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    self.data = @[self.IsYoungYao,self.IsKouFu,self.yongYaoDetail];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.saveButton addTarget:self action:@selector(tosave) forControlEvents:UIControlEventTouchUpInside];
    weakify(self);
    self.IsYoungYao.type = ^(NSString *type) {
        strongify(self);
        if ([type isEqualToString:@"1"]) {
            self.IsYoungYao.sex = @"1";
            self.IsKouFu.hidden = YES;
            self.yongYaoDetail.textView.text = @"";
            self.YWmamediaView.showAddButton = NO;
        }else{
            self.IsYoungYao.sex = @"0";
            self.IsKouFu.hidden = NO;
            self.yongYaoDetail.textView.text = @"";
            self.YWmamediaView.showAddButton = YES;
        }
        NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];//
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];//
    };
    
    self.IsKouFu.type = ^(NSString *type) {
        strongify(self);
        if ([type isEqualToString:@"1"]) {
            self.IsKouFu.sex  =@"1";
            self.yongYaoDetail.textView.text = @"";
            self.yongYaoDetail.hidden = YES;
        }else{
            self.IsKouFu.sex  =@"0";
            self.yongYaoDetail.hidden = NO;
            self.yongYaoDetail.textView.text = @"";
        }
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];//

    };
    //即将要填写的 (0:有，1:无)
//    self.IsYoungYao.sex = @"1";
//    self.IsKouFu.sex = @"1";
//    NSLog(@"----------------------%@",self.IsYoungYao.sex);

    //footview；病例报告
    UIView *bgView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    label.backgroundColor = DefaultBackgroundColor;
    [bgView addSubview:label];
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), kScreenWidth, 40)];
    label0.font  = [UIFont systemFontOfSize:16.0f weight:0.3];
    label0.textColor  =DefaultBlackLightTextClor;
    label0.textAlignment = NSTextAlignmentLeft;
    label0.text = @"病历报告";
    [bgView addSubview:label0];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label0.frame), kScreenWidth, 20)];
    label1.font  =FontNameAndSize(16);
    label1.textColor  =DefaultGrayTextClor;
    label1.textAlignment = NSTextAlignmentLeft;
    label1.text = @"请上传检查记录,检验报告出院小结,手术小结";
    [bgView addSubview:label1];
    bgView.backgroundColor = [UIColor whiteColor];
    UIView *descView = [[UIView alloc] init];
    descView.backgroundColor = [UIColor yellowColor];
    [bgView addSubview:descView];
    self.BGmamediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0,80, [[UIScreen mainScreen] bounds].size.width, 1)];
    self.BGmamediaView .type = ACMediaTypePhotoAndCamera;
    self.BGmamediaView .maxImageSelected = 9;
    self.BGmamediaView .naviBarBgColor = AppStyleColor;
    self.BGmamediaView .rowImageCount = 3;
    self.BGmamediaView .lineSpacing = 20;
    self.BGmamediaView .interitemSpacing = 20;
    self.BGmamediaView .sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    [self.BGmamediaView  observeViewHeight:^(CGFloat mediaHeight) {
        descView.frame = CGRectMake(0, CGRectGetMaxY(self.BGmamediaView .frame) +0, CGRectGetWidth(self.BGmamediaView .frame),0);
        bgView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(descView.frame) + 0);
        //注意：在里面更新，避免滚动不到底
        self.tableView.tableFooterView = bgView;
    }];
    if (self.isEditEnter == YES) {
        [self.BGmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
            NSLog(@"---yyyyy----%@",list);
            NSLog(@"%@",self.EBGselectImageUrls);
//            [self.EBGselectImageUrls removeAllObjects];
//            NSMutableArray *newArr = [NSMutableArray array];
//            for (ACMediaModel *model in list) {
//                if (model.imageUrlString) {
//                    [self.EBGselectImageUrls addObject:model.imageUrlString];
//                }else{
//                    [newArr addObject:model.image];
//                }
//                NSLog(@"-------%@",model.imageUrlString);
//            }
//            if (newArr.count > 0) {
//                [Utils addHudOnView:self.view];
//                [Utils uploadImgs:newArr withResult:^(id imgs,NSInteger status) {
//                    if (status == 1) {
//                        [self.EBGselectImageUrls addObjectsFromArray:imgs];
//                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//                            // Do something...
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [Utils removeHudFromView:self.view];
//                            });
//                        });
//                    }
//                }];
//                NSLog(@"编辑后的数组：%@",self.EBGselectImageUrls);
//            }
            
        }];
    }else{
        [self.BGmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
            self.BGselectImages = [NSMutableArray array];
            [self.BGselectImages removeAllObjects];
            for (ACMediaModel *model in list) {
                [self.BGselectImages addObject:model.image];
            }
            self.BGselectImageUrls = [NSMutableArray array];
            [self.BGselectImageUrls removeAllObjects];
            if (!self.BGselectImages) {
                return ;
            }else{
                //            [Utils addHudOnView:self.view];
                [Utils uploadImgs:self.BGselectImages withResult:^(id imgs,NSInteger status) {
                    //                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    //                    // Do something...
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                        [Utils removeHudFromView:self.view];
                    //                    });
                    //                });
                    self.BGselectImageUrls = (NSMutableArray *)imgs;
                    NSLog(@"%@",imgs);
                    NSLog(@"%@",self.BGselectImageUrls);
                }];
            }
        }];
    }
    
    // observeViewHeight 存在时可以不写
    //    [mediaView reload];
    [bgView addSubview:self.BGmamediaView];
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.IsYoungYao.sex isEqualToString:@"1"]) {   //无用药记录
        if (indexPath.section == 0 && indexPath.row == 2) {
            if ([self.IsKouFu.sex isEqualToString:@"1"]) {  //无口福记录
                return CGFLOAT_MIN;
            }else{
                return CGFLOAT_MIN;
            }
        }else if(indexPath.section == 0 && indexPath.row == 1){
            return CGFLOAT_MIN;
        }else if(indexPath.section == 0 && indexPath.row == 0){
            return 52;
        }else{
            return 0;
        }
    }else{
        if (indexPath.section == 0 && indexPath.row == 2) {
            if ([self.IsKouFu.sex isEqualToString:@"1"]) {  //无口福记录
                return CGFLOAT_MIN;
            }else{
                return 120;
            }
        }else if(indexPath.section == 0 && indexPath.row == 1){
            return 52;
        }else if(indexPath.section == 0 && indexPath.row == 0){
            return 52;
        }else{
            return 0;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.data.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self.data safeObjectAtIndex:indexPath.row];
    }else{
        return nil;
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.IsYoungYao.sex isEqualToString:@"0"]) {
        if ([self.IsKouFu.sex isEqualToString:@"0"]) {
            return MAX(_mediaH, 0.1);
        }else{
            return MAX(0, 0.1);
        }
    }else{
        return MAX(0, 0.1);
    }
//    return MAX(_mediaH, 0.1);
  
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        if (!_YWmamediaView) {
            self.YWmamediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 40, [[UIScreen mainScreen] bounds].size.width, 1)];
            self.YWmamediaView.type = ACMediaTypePhotoAndCamera;
            self.YWmamediaView.maxImageSelected = 9;
            self.YWmamediaView.userInteractionEnabled = YES;
            self.YWmamediaView.naviBarBgColor = AppStyleColor;
            self.YWmamediaView.rowImageCount = 3;
            self.YWmamediaView.lineSpacing = 20;
            self.YWmamediaView.interitemSpacing = 20;
            self.YWmamediaView.showDelete = YES;
            self.YWmamediaView.showAddButton = YES;
            self.YWmamediaView.allowMultipleSelection = YES;
            self.YWmamediaView.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            [self.YWmamediaView observeViewHeight:^(CGFloat mediaHeight) {
                _mediaH = mediaHeight;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            }];
            if (self.isEditEnter == YES) {
                [self.BGmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                    NSLog(@"---1111----%@",list);
                    [self.EYWselectImageUrls removeAllObjects];
                    NSMutableArray *newArr = [NSMutableArray array];
                    for (ACMediaModel *model in list) {
                        if (model.imageUrlString) {
                            [self.EYWselectImageUrls addObject:model.imageUrlString];
                        }else{
                            [newArr addObject:model.image];
                        }
                        NSLog(@"-------%@",model.imageUrlString);
                    }
                    if (newArr.count > 0) {
                        [Utils addHudOnView:self.view];
                        [Utils uploadImgs:newArr withResult:^(id imgs,NSInteger status) {
                            if (status == 1) {
                                [self.EYWselectImageUrls addObjectsFromArray:imgs];
                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                    // Do something...
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [Utils removeHudFromView:self.view];
                                    });
                                });
                            }
                        }];
                        NSLog(@"编辑后的数组：%@",self.EYWselectImageUrls);
                    }
                    
                }];
            }else{
                [self.YWmamediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                    self.YWselectImages = [NSMutableArray array];
                    [self.YWselectImages removeAllObjects];
                    for (ACMediaModel *model in list) {
                        [self.YWselectImages addObject:model.image];
                    }
                    self.YWselectImageUrls = [NSMutableArray array];
                    [self.YWselectImageUrls removeAllObjects];
                    if (!self.YWselectImages) {
                        return ;
                    }else{
                        //                    [Utils addHudOnView:self.view];
                        [Utils uploadImgs:self.YWselectImages withResult:^(id imgs,NSInteger status) {
                            //                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            //                            // Do something...
                            //                            dispatch_async(dispatch_get_main_queue(), ^{
                            //                                [Utils removeHudFromView:self.view];
                            //                            });
                            //                        });
                            self.YWselectImageUrls = (NSMutableArray *)imgs;
                            NSLog(@"%@",imgs);
                            NSLog(@"%@",self.YWselectImageUrls);
                        }];
                    }
                }];
            }
                
        }
        
        return self.YWmamediaView;
    }else{
        return nil;
    }
}

- (void)tosave{
    
    if (self.isEditEnter == YES) {
        [Utils addHudOnView:self.view withTitle:@"正在保存..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blUpdateC";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        if ([self.IsYoungYao.sex isEqualToString:@"1"]) {
            bodyer.blimages =[self.EBGselectImageUrls componentsJoinedByString:@";"];
            bodyer.id  = self.id;
            bodyer.yaowu = @"";
            bodyer.ywimages =@"";
            bodyer.id  = self.id;
        }else{
            if ([self.IsKouFu.sex isEqualToString:@"1"]) {
                bodyer.ywimages =[self.EYWselectImageUrls componentsJoinedByString:@";"];
                bodyer.blimages =[self.EBGselectImageUrls componentsJoinedByString:@";"];
                bodyer.yaowu = @"";
                bodyer.id  = self.id;
            }else{
                bodyer.yaowu = self.yongYaoDetail.textView.text;
                bodyer.ywimages =[self.EYWselectImageUrls componentsJoinedByString:@";"];
                bodyer.blimages =[self.EBGselectImageUrls componentsJoinedByString:@";"];
                bodyer.id  = self.id;
            }
        }
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester.mj_keyValues.mutableCopy);
        [self.api EditBC:requester.mj_keyValues.mutableCopy];
    }else{
        [Utils addHudOnView:self.view withTitle:@"正在保存..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blUpdateC";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        if ([self.IsYoungYao.sex isEqualToString:@"1"]) {
            bodyer.blimages =[self.BGselectImageUrls componentsJoinedByString:@";"];
            bodyer.id  = self.id;
            bodyer.yaowu = @"";
            bodyer.ywimages =@"";
            bodyer.id  = self.id;
        }else{
            if ([self.IsKouFu.sex isEqualToString:@"1"]) {
                bodyer.ywimages =[self.YWselectImageUrls componentsJoinedByString:@";"];
                bodyer.blimages =[self.BGselectImageUrls componentsJoinedByString:@";"];
                bodyer.yaowu = @"";
                bodyer.id  = self.id;
            }else{
                bodyer.yaowu = self.yongYaoDetail.textView.text;
                bodyer.ywimages =[self.YWselectImageUrls componentsJoinedByString:@";"];
                bodyer.blimages =[self.BGselectImageUrls componentsJoinedByString:@";"];
                bodyer.id  = self.id;
            }
        }
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester.mj_keyValues.mutableCopy);
        [self.api EditBC:requester.mj_keyValues.mutableCopy];
    }
}


@end
