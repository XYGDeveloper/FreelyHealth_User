//
//  OVSDeployableLabel.h
//  LabelDemo
//
//  Created by cm on 2017/5/23.
//  Copyright © 2017年 com.peiziming. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OVS_LEFT_RIGHT_GAP 20

@interface OVSDeployableLabel : UILabel {

}
/**
 * deployTip label尾部展开的提醒文字 @“展开” @“更多”
 */
@property (nonatomic, copy) NSString *deployTip;

/**
 * 展开文字的颜色，default is nil (text draws black)
 */
@property (nonatomic, strong) UIColor *deployColor;

/**
 * 展开文字的字体，default is nil (system font 17 plain) 
 * tip: font size需要和OVSDeployableLabel统一，尽量避免出现出界的情况。**
 */
@property (nonatomic, strong) UIFont *deployFont;

/**
 * 展开文字的属性字符  default is nil.
 */
@property (nonatomic, strong) NSMutableAttributedString *deployAttributedString;

/**
 * 初始化OVSDeployableLabel
 * @deployTip label尾部展开的提醒文字 @“展开” @“更多” 默认是@“更多”
 */
- (instancetype)initWithFrame:(CGRect)frame DeployTip:(NSString *)deployTip;

/**
 * 
 */
- (instancetype)initWithDeployTip:(NSString *)deployTip;

/**
 * 根据deployAttributdString，开始绘制OVSDeployableLabel。
 * 如果 deployAttributdString passed in nil, 将会参照deployColor，deployFont绘制。
 * 可以通过自己调用layoutIfNeeded等方法进行绘制。
 * 默认numberOfLines为1
 
 * @numberOfLines 传递一个NSUInteger 控制OVSDeployableLabel显示行数。
 */
- (void)drawRectWith:(NSMutableAttributedString *)deployAttributdString;

/**
 * 直接绘制
 * 将会参照deployColor，deployFont绘制
 */
- (void)drawRect;

/**
 * 返回line的count get line count by attributedString
 * if attributedString == nil use default value font 
 */
- (NSUInteger)getLinesCount;

/**
 * 根据宽度计算出合理的高度
 */
- (void)setupLayout:(NSUInteger)numberOfLine width:(CGFloat)width;

@end
