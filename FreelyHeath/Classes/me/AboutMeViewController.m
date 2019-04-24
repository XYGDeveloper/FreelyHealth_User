//
//  AboutMeViewController.m
//  FreelyHeath
//
//  Created by L on 2017/8/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.aboutLabel.textColor = DefaultGrayLightTextClor;
    self.aboutLabel.text = @"";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
//    // 当前应用软件版本  比如：1.0.1
//    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"当前应用软件版本:%@",appCurVersion);
    self.versionLabel.text = [NSString stringWithFormat:@"%@v%@",appCurName,@"1.0.8"];
    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
