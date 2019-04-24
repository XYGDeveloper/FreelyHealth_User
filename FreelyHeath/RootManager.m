//
//  RootManager.m
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "RootManager.h"
#import "SDetailViewController.h"
#import "MeViewController.h"
#import "ZYindexViewController.h"
#import <UIImage+GIF.h>
//#import "BaseNavigationController.h"
@interface RootManager()
@property (nonatomic, strong) RMTabBarViewController *tabbarController;

@end
@implementation RootManager
+ (instancetype)sharedManager {
    static RootManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[RootManager alloc] init];
    });
    return __manager;
}

- (void)dealloc {
    [self.tabbarController removeObserver:self forKeyPath:@"selectedIndex"];
}
- (id)init {
    if (self = [super init]) {
        [self initTabbarController];
        [self.tabbarController addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        NSUInteger oldIndex = [[change objectForKey:NSKeyValueChangeOldKey] integerValue];
        UIViewController *vc = [self.tabbarController.viewControllers safeObjectAtIndex:oldIndex];
        UINavigationController *nav = (UINavigationController *)vc;
        if (nav.viewControllers.count > 1) {
            nav.viewControllers = @[nav.viewControllers.firstObject];
        }
    }
}

- (void)initTabbarController {
    self.tabbarController = [[RMTabBarViewController alloc]init];
    UIViewController *vc1 =  [self.tabbarController setupChildViewController:[SDetailViewController new] navigationController:[NavigationController class] title:@"肿瘤专区" imageName:@"tabbar_left" selectedImageName:@"tabbar_left_s" offset:NO  badge:@"0"];
    UIViewController *vc2 =  [self.tabbarController setupChildViewController:[ZYindexViewController new] navigationController:[NavigationController class] title:@"直医" imageName:@"tabbar_middle" selectedImageName:@"tabbar_middle_s" offset:YES badge:@"0"];
    UIViewController *vc3 = [self.tabbarController setupChildViewController:[MeViewController new] navigationController:[NavigationController class] title:@"我的" imageName:@"tabbar_right" selectedImageName:@"tabbar_right_s" offset:NO badge:@"0"];
    self.tabbarController.viewControllers = @[vc1,vc2,vc3];
    self.tabbarController.selectedIndex = 1;
}

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor clearColor]]];
    self.view.backgroundColor = DefaultBackgroundColor;
    UIColor *topleftColor = [UIColor colorWithRed:29/255.0f green:231/255.0f blue:185/255.0f alpha:1.0f];
    UIColor *bottomrightColor = [UIColor colorWithRed:27/255.0f green:200/255.0f blue:225/255.0f alpha:1.0f];
    UIImage *bgImg = [UIImage gradientColorImageFromColors:@[topleftColor,bottomrightColor] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 64)];
    [self.navigationBar setBackgroundImage:bgImg forBarMetrics:UIBarMetricsDefault];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        if ([obj isKindOfClass:[MessageListViewController class]]) {
        //            MessageViewController *chatListVC = (MessageViewController *)obj;
        //            [chatListVC updateBadgeValueForTabBarItem];
        //        }
        //        NSLog(@"\\\\\\\\\\\\\\\\\\\%@",obj);
    }];
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //    NSLog(@"hhhhhhhhhhhhhhhhhhhhhhhhhhhh   %@",[self.viewControllers lastObject]);
    //    if ([[self.viewControllers lastObject] isMemberOfClass:[QqwPersonalViewController class]]) {
    //        [self setNavigationBarHidden:YES animated:animated];
    //    }else{
    //        [self setNavigationBarHidden:NO];
    //    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end

