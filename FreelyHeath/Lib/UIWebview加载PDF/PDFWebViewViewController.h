//
//  PDFWebViewViewController.h
//  PDFViewAndDownload
//
//  Created by Dustin on 17/4/6.
//  Copyright © 2017年 PicVision. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetBgApi.h"
#import "GetBgRequest.h"

@interface PDFWebViewViewController : UIViewController

@property (nonatomic,copy) NSString *urlStr;

@property (nonatomic,strong)NSString *his;

@property (nonatomic,strong)GetBgApi *api;


@end
