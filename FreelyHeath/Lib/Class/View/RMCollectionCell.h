//
//  RMCollectionCell.h
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMCalendarModel;

@interface RMCollectionCell : UICollectionViewCell
/**
 *  显示日期
 */
@property (nonatomic, weak) UILabel *dayLabel;
/**
 *  显示农历
 */
@property (nonatomic, weak) UILabel *chineseCalendar;
/**
 *  选中的背景图片
 */
@property (nonatomic, weak) UIImageView *selectImageView;
/**
 *  票价   此处可根据项目需求自行修改
 */
@property (nonatomic, weak) UILabel *price;
@property(nonatomic, strong) RMCalendarModel *model;

@end
