//
//  MCTabBarController.m
//  MCTabBarDemo
//
//  Created by chh on 2017/12/4.
//  Copyright © 2017年 Mr.C. All rights reserved.
//

#import "MCTabBarController.h"
#import "ConsultViewController.h"
#import "SDetailViewController.h"
#import "MeViewController.h"
#import "ConsultViewController.h"
//#import "BaseNavigationController.h"
#import "ZYindexViewController.h"
#import "MCTabBar.h"
@interface MCTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) MCTabBar *mcTabbar;
@end

@implementation MCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mcTabbar = [[MCTabBar alloc] init];
     [_mcTabbar.centerBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //选中时的颜色
    _mcTabbar.tintColor = AppStyleColor;
   //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    _mcTabbar.translucent = NO;
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:_mcTabbar forKeyPath:@"tabBar"];
    self.delegate = self;
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//添加子控制器
- (void)addChildViewControllers{
    //图片大小建议32*32
//    [self addChildrenViewController:[SDetailViewController new] andTitle:@"肿瘤专区" andImageName:@"tabbar_left" andSelectImage:@"tabbar_left_s"];
//    [self addChildrenViewController:[[ZYindexViewController alloc]init] andTitle:@"直医" andImageName:@"" andSelectImage:@""];
//    [self addChildrenViewController:[MeViewController new] andTitle:@"我的" andImageName:@"tabbar_right" andSelectImage:@"tabbar_right_s"];
}

//- (void)addChildrenViewController:(UIViewController *)childVC andTitle:(NSString *)title andImageName:(NSString *)imageName andSelectImage:(NSString *)selectedImage{
//    childVC.tabBarItem.image = [UIImage imageNamed:imageName];
//    childVC.tabBarItem.selectedImage =  [UIImage imageNamed:selectedImage];
//    childVC.title = title;
//    BaseNavigationController *baseNav = [[BaseNavigationController alloc] initWithRootViewController:childVC];
//    [self addChildViewController:baseNav];
//}

- (void)buttonAction:(UIButton *)button{
    if (self.viewControllers.count >1) {
    }else{
        self.selectedIndex = 1;//关联中间按钮
        [self.mcTabbar.centerBtn setImage:[UIImage imageNamed:@"tabbar_middle_s"] forState:UIControlStateNormal];
    }
//    [self rotationAnimation];
}
//tabbar选择时的代理
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 1){//选中中间的按钮
        [self.mcTabbar.centerBtn setImage:[UIImage imageNamed:@"tabbar_middle_s"] forState:UIControlStateNormal];
    }else {
        [self.mcTabbar.centerBtn setImage:[UIImage imageNamed:@"tabbar_middle"] forState:UIControlStateNormal];
        [_mcTabbar.centerBtn.layer removeAllAnimations];
    }
}
//旋转动画
- (void)rotationAnimation{
    [self.mcTabbar.centerBtn setImage:[UIImage imageNamed:@"tabbar_middle_s"] forState:UIControlStateNormal];
//    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
//    rotationAnimation.duration = 3.0;
//    rotationAnimation.repeatCount = HUGE;
//    [_mcTabbar.centerBtn.layer addAnimation:rotationAnimation forKey:@"key"];
}

@end
