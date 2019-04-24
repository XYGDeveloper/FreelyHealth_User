//
//  ToSubsViewController.h
//  FreelyHeath
//
//  Created by L on 2018/1/10.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToSubsViewController : UIViewController<CLLocationManagerDelegate>
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,assign)float latitude;
@property (nonatomic,assign)float longitude;
@property (nonatomic,strong)NSString *addressString;
//
@property (nonatomic,assign)BOOL orderEnter;
@end
