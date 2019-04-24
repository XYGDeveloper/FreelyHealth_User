//
//  UpdateViewController.h
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TPKeyboardAvoidingTableView.h>
#import "SelectTypeTableViewCell.h"
#import "HClActionSheet.h"
#import "CityListApi.h"
#import "GetOrderCityListRequest.h"
#import "CityModel.h"
#import <ZYQAssetPickerController.h>
#import <AliyunOSSiOS/OSSService.h>
#import "OSSImageUploader.h"
@class FileModel;

@interface UpdateViewController : UIViewController

@property (nonatomic,strong)FileModel *model;


@end
