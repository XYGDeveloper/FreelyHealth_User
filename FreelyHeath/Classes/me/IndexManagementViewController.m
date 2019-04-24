//
//  IndexManagementViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IndexManagementViewController.h"
#import "IndexOriTableViewCell.h"
#import "IndexStyleTableViewCell.h"
#import "WeightViewController.h"
#import "BloodSugarViewController.h"
#import "BloodPressureViewController.h"
#import "TumorMarkerViewController.h"

@interface IndexManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *managerTableView;


@end

@implementation IndexManagementViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    [self.view addSubview:self.managerTableView];
  
    [self.managerTableView registerNib:[UINib nibWithNibName:@"IndexOriTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([IndexOriTableViewCell class])];
    
    [self.managerTableView registerNib:[UINib nibWithNibName:@"IndexStyleTableViewCell" bundle:nil] forCellReuseIdentifier:@"IndexStyleTableViewCell"];

    [self layOutSubview];
    
  

    
    
}


- (UITableView *)managerTableView
{

    if (!_managerTableView) {
        
        _managerTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _managerTableView.delegate  = self;
        
        _managerTableView.dataSource  = self;
        
        _managerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
        
        
        IndexOriTableViewCell *contentView = [[IndexOriTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        
        contentView.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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


- (void)tapAction{

    TumorMarkerViewController *tum = [TumorMarkerViewController new];
    
    [self.navigationController pushViewController:tum animated:YES];
    
}



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
        
        return 3;
        
    }else{
        
        return 4;
        
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        IndexOriTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexOriTableViewCell class])];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else{
    
        IndexStyleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([IndexStyleTableViewCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    
    }


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
     
            WeightViewController *weight = [WeightViewController new];
            
            [self.navigationController pushViewController:weight animated:YES];
            
        }else if (indexPath.row == 1){
        
            BloodSugarViewController *weight = [BloodSugarViewController new];
            
            [self.navigationController pushViewController:weight animated:YES];
            
        }else if (indexPath.row== 2){
        
            BloodPressureViewController *weight = [BloodPressureViewController new];
            
            [self.navigationController pushViewController:weight animated:YES];
        
        }
        
    }



}



- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
