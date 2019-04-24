//
//  CaseProfileViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseProfileViewController.h"
#import "UpDateDetailTableViewCell.h"
#import <TPKeyboardAvoidingTableView.h>
#import "BCViewController.h"
#import "CaseListRequest.h"
#import "EditBSApi.h"
#import "CaseDetailModel.h"
#import "CaseNoteViewController.h"
@interface CaseProfileViewController ()<UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)UIView *head;
@property (nonatomic,strong)UpDateDetailTableViewCell *zhengzhuang;
@property (nonatomic,strong)UpDateDetailTableViewCell *bignshi;
@property (nonatomic,strong)UpDateDetailTableViewCell *jilu;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)EditBSApi *bsApi;
@end

@implementation CaseProfileViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isEdit == YES) {
        self.zhengzhuang.textView.text = self.model.zhengzhuang;
        self.bignshi.textView.text = self.model.jiwang;
        self.jilu.textView.text = self.model.zhiliao;
    }
}

- (EditBSApi *)bsApi{
    if (!_bsApi) {
        _bsApi = [[EditBSApi alloc]init];
        _bsApi.delegate  = self;
    }
    return _bsApi;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
    if (api == _bsApi) {
        if (self.isEdit == YES) {
            CaseNoteViewController *note = [CaseNoteViewController new];
            note.id  = responsObject[@"id"];
            note.title = @"病程记录";
            note.isEditEnter = YES;
            [self.navigationController pushViewController:note animated:YES];
        }else{
            CaseNoteViewController *note = [CaseNoteViewController new];
            note.id  = responsObject[@"id"];
            note.title = @"病程记录";
            note.hzEnter = YES;
            [self.navigationController pushViewController:note animated:YES];
        }
    }
}

- (UpDateDetailTableViewCell *)zhengzhuang{
    if (!_zhengzhuang) {
        _zhengzhuang = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _zhengzhuang.label.text = @"主要症状";
        _zhengzhuang.textView.placeholder = @"存在的主要不适症状。";
        _zhengzhuang.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _zhengzhuang;
}
- (UpDateDetailTableViewCell *)bignshi{
    if (!_bignshi) {
        _bignshi = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _bignshi.label.text = @"既往病史";
        _bignshi.textView.placeholder = @"以前是否有过类似情况，是否有慢性病史、外伤、手术等。";
        _bignshi.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _bignshi;
}

- (UpDateDetailTableViewCell *)jilu{
    if (!_jilu) {
        _jilu = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _jilu.label.text = @"治疗记录";
        _jilu.textView.placeholder = @"做过哪些治疗，成效。";
        _jilu.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _jilu;
}

- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = DefaultBackgroundColor;
    }
    return _tableView;
}
- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _saveButton.backgroundColor = AppStyleColor;
        [_saveButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveButton;
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
    stepline.backgroundColor = DividerDarkGrayColor;
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
    
    
    UIView *authFlag1 = [[UIView alloc]init];
    
    authFlag1.backgroundColor = [UIColor whiteColor];
    
    authFlag1.layer.cornerRadius = 3.5;
    
    authFlag1.layer.masksToBounds = YES;
    
    [authFlag addSubview:authFlag1];
    
    [authFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(authFlag.mas_centerX);
        
        make.width.height.mas_equalTo(7);
        
        make.centerY.mas_equalTo(authFlag.mas_centerY);
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
    
    
    UIView *noteFlag = [[UIView alloc]init];
    
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    noteFlag.layer.cornerRadius = 10;
    
    noteFlag.layer.masksToBounds = YES;
    
    [topView addSubview:noteFlag];
    
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(stepline.mas_right);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UILabel *noteLabel = [[UILabel alloc]init];
    
    [topView addSubview:noteLabel];
    
    noteLabel.textColor = DefaultGrayTextClor;
    
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
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setheader];
    self.list = @[self.zhengzhuang,self.bignshi,self.jilu];
    [self.view addSubview:self.tableView];
    [self layoutsubview];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.saveButton addTarget:self action:@selector(tosave) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

-(void)tosave{
    if (self.zhengzhuang.textView.text.length <= 0) {
        [Utils postMessage:@"请填写主要症状" onView:self.view];
        return;
    }
    [Utils addHudOnView:self.view withTitle:@"正在保存..."];
    caseListHeader *header = [[caseListHeader alloc]init];
    header.target = @"bingLiControl";
    header.method = @"blUpdateB";
    header.versioncode = Versioncode;
    header.devicenum = Devicenum;
    header.fromtype = Fromtype;
    header.token = [User LocalUser].token;
    caseListBody *bodyer = [[caseListBody alloc]init];
 
    bodyer.zhengzhuang  = self.zhengzhuang.textView.text;
    bodyer.jiwang  = self.bignshi.textView.text;
    bodyer.zhiliao  =self.jilu.textView.text;
    bodyer.id  = self.id;
    CaseListRequest *requester = [[CaseListRequest alloc]init];
    requester.head = header;
    requester.body = bodyer;
    [self.bsApi EditBS:requester.mj_keyValues.mutableCopy];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 133;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.list safeObjectAtIndex:indexPath.row];
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

@end
