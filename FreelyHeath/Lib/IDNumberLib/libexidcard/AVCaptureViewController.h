//
//  AVCaptureViewController.h
//  实时视频Demo
//
//  Created by zhongfeng1 on 2017/2/16.
//  Copyright © 2017年 zhongfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^getIDnumber)(NSString *num);
@interface AVCaptureViewController : UIViewController
@property (nonatomic,strong)getIDnumber getidnumber;
@end

