//
//  RootManager.h
//  FreelyHeath
//
//  Created by XI YANGUI on 2018/5/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RMTabBarViewController.h>
@interface RootManager : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) RMTabBarViewController *tabbarController;
@end

@interface NavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic, weak) id PopDelegate;

@end

