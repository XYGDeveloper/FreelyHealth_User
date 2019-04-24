//
//  ZYJHeadLineView.h
//  ZYJHeadLineView
//
//  Created by 张彦杰 on 16/12/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJHeadLineModel.h"
@interface ZYJHeadLineView : UIView
@property (nonatomic,copy) void (^clickBlock)(NSInteger index);//第几个数据被点击

//数组内部数据需要是GBTopLineViewModel类型
- (void)setVerticalShowDataArr:(NSMutableArray *)dataArr;

//停止定时器(界面消失前必须要停止定时器否则内存泄漏)
- (void)stopTimer;
@end
