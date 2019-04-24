//
//  ChildConsultViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ChildConsultViewController.h"
#import "ConsultTableViewCell.h"
#import "PolularScienceTableViewCell.h"
#import "TumorConsultationViewController.h"
#import "QAListTableViewCell.h"
#import "TeamExpertViewController.h"
#import "TumorZoneListModel.h"
@interface ChildConsultViewController ()<UITableViewDelegate,UITableViewDataSource,delegateColl>

@property (nonatomic,strong)UITableView *ConsulttableView;


@end

@implementation ChildConsultViewController


- (UITableView *)ConsulttableView
{

    if (!_ConsulttableView) {
        
        _ConsulttableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _ConsulttableView.delegate = self;
        
        _ConsulttableView.dataSource = self;
        
    }

    return _ConsulttableView;
    
}

- (void)layoutsubview{

    [self.ConsulttableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.ConsulttableView];
    
     self.view.backgroundColor = DefaultBackgroundColor;
    
    [self.ConsulttableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    [self.ConsulttableView registerClass:[ConsultTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ConsultTableViewCell class])];
    [self.ConsulttableView registerClass:[PolularScienceTableViewCell class] forCellReuseIdentifier:NSStringFromClass([PolularScienceTableViewCell class])];
    
     [self.ConsulttableView registerClass:[QAListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([QAListTableViewCell class])];
    [self layoutsubview];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    NSMutableArray *sectionArr = @[@"专家咨询",@"肿瘤问答",@"科普天地"].mutableCopy;
    
    UIView *content = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    content.backgroundColor = [UIColor whiteColor];
    UIView *letView = [[UIView alloc]init];
    letView.backgroundColor = AppStyleColor;
    [content addSubview:letView];
    [letView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(16);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = Font(16);
    titleLabel.textColor = DefaultGrayTextClor;
    [content addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(letView.mas_right).mas_equalTo(5);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"查看全部" forState:UIControlStateNormal];
    [button setTitleColor:AppStyleColor forState:UIControlStateNormal];
    button.titleLabel.font = Font(16);
    [content addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(content.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-16);
    }];
    
    titleLabel.text = [sectionArr objectAtIndex:section];
    
    return content;
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 44;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        return 264;
        
    }else if (indexPath.section == 1)
    {
    
        return 80;
    
    }
    else{
    
        return 112;
    }

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0 || section == 1) {
        return 1;
        
    }else{
    
        return 10;
    
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];

    if (indexPath.section == 0) {
        
        ConsultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ConsultTableViewCell class])];
        
        cell.delegateColl = self;
        
        return cell;
        
    }else if (indexPath.section == 2)
    {

        PolularScienceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PolularScienceTableViewCell class])];
        
        return cell;
    
    }else{
    
        QAListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QAListTableViewCell class])];
        
        return cell;
        
    }
    
    return cell;
    

}


@end
