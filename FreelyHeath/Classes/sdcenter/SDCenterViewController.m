//
//  SDCenterViewController.m
//  DirectClientProgect
//
//  Created by L on 2017/7/13.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "SDCenterViewController.h"
#import "LoginViewController.h"
#import "SDCollectionViewCell.h"
#import "sdModel.h"
#import "SDetailViewController.h"
#import "ServiceViewController.h"
#import "SDCenterCollectionViewCell.h"
#import "PhysicalExaminationViewController.h"
#import "MedicalInsuranceViewController.h"

@interface SDCenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *sdCollectionview;

@end

@implementation SDCenterViewController




- (UICollectionView *)sdCollectionview
{

    if (!_sdCollectionview) {
        
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc]init];
        
        layOut.itemSize = CGSizeMake((kScreenWidth- 60)/2, 125.0f);
        
        layOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        layOut.minimumLineSpacing = 20;
        
        layOut.sectionInset=UIEdgeInsetsMake(10,20,10, 20);
        
        layOut.minimumInteritemSpacing = 10;
        
        _sdCollectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layOut];
        
        _sdCollectionview.backgroundColor = DefaultBackgroundColor;
        
        _sdCollectionview.dataSource = self;
        
        _sdCollectionview.delegate = self;
        
    }

    return _sdCollectionview;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"tabbar_consult", nil);

    [self.view addSubview:self.sdCollectionview];
    
    [self.sdCollectionview registerClass:[SDCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([SDCollectionViewCell class])];
    
    self.sdCollectionview.bounces = NO;
    
    self.sdCollectionview.scrollEnabled = NO;
    
    self.sdCollectionview.backgroundColor = [UIColor whiteColor];
    
    
    [self.sdCollectionview registerNib:[UINib nibWithNibName:@"SDCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SDCenterCollectionViewCell class])];

    [self.sdCollectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
    [self layOutsubview];
    
    
}


- (void)layOutsubview{

    [self.sdCollectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(kScreenHeight - 200);
        
        
    }];
    

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 2;

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return CGSizeMake(0, 0);
    }
    else {
       
        return CGSizeMake(kScreenWidth, 34);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        return CGSizeMake(kScreenWidth, 195);
    }
    else {
        
        return CGSizeMake((kScreenWidth- 60)/2, 125.0f);
    }

}



- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    
    UICollectionReusableView* reusableView;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UICollectionReusableView class]) forIndexPath:indexPath];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        
        contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *topsepline = [UIView new];
        
        topsepline.backgroundColor = DividerGrayColor;
        
        [contentView addSubview:topsepline];
        
        [topsepline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        UILabel *publicLabel = [[UILabel alloc]init];
        
        publicLabel.textAlignment = NSTextAlignmentLeft;
        
        publicLabel.textColor = DefaultGrayLightTextClor;
        
        publicLabel.font = Font(15);
        
        publicLabel.text = @"公共服务";
        
        [contentView addSubview:publicLabel];
        
        [publicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.left.mas_equalTo(20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(40);
        }];
        
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [rightButton setTitleColor:AppStyleColor forState:UIControlStateNormal];
        
        [rightButton setTitle:@"" forState:UIControlStateNormal];
        
        rightButton.titleLabel.font = Font(15);
        
        rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [contentView addSubview:rightButton];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(40);
        }];
        
        UIView *sepline = [UIView new];
        
        sepline.backgroundColor = DividerGrayColor;
        
        [contentView addSubview:sepline];
        
        [sepline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        [reusableView addSubview:contentView];
        
       
    }
    
      return reusableView;
 
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (section == 0) {
        
        return 1;
        
    }else{
    
        return 2;
        
    
    }
  
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
         SDCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SDCenterCollectionViewCell class]) forIndexPath:indexPath];
        
        return cell;
        
    }else{
    
        SDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SDCollectionViewCell class]) forIndexPath:indexPath];
        
        NSArray *imageArr = @[@"img2",@"img3"];
        
        cell.bgImage.image = [UIImage imageNamed:imageArr[indexPath.row]];
        
        NSArray *item = @[@"体检服务",@"医疗保险"];
        
        cell.middleLabel.text = [item objectAtIndex:indexPath.row];
        
        return cell;

    }
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        
        if ([Utils showLoginPageIfNeeded]) {
            
        }else{
            
            SDetailViewController *detail = [SDetailViewController new];
            
            detail.hidesBottomBarWhenPushed=  YES;
            
            detail.title = @"肿瘤专区";
            
            [self.navigationController pushViewController:detail animated:YES];
            
        }

        
      
        
        
    }else{
     
        if (indexPath.row == 0) {
            
            
            if ([Utils showLoginPageIfNeeded]) {
                
            }else{
                
                PhysicalExaminationViewController *physicalExam = [PhysicalExaminationViewController new];
                physicalExam.hidesBottomBarWhenPushed=  YES;
                
                physicalExam.title = @"体检服务";
                
                [self.navigationController pushViewController:physicalExam animated:YES];
                
            }
            
            
        
            
        }else{
        
            if ([Utils showLoginPageIfNeeded]) {
                
            }else{
                
                MedicalInsuranceViewController *medicalInsurance = [MedicalInsuranceViewController new];
                medicalInsurance.hidesBottomBarWhenPushed=  YES;
                
                medicalInsurance.title = @"医疗保险";
                
                [self.navigationController pushViewController:medicalInsurance animated:YES];
                
            }
            
            
        }
    
    }
  

}






@end
