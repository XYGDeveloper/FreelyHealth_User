//
//  ZFAutoLabel.h
//  DrawTest
//
//  Created by mac on 11/11/14.
//  Copyright (c) 2014 (zhifei - qiuzhifei521@gmail.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#define FONT_SIZE_SPACING 1.5f
#define LIST_SPACING      2.0f

@interface ZFAutoLabel : UILabel


@property (assign, nonatomic) CGFloat characterSpacing; //字间距

@property (assign, nonatomic) long    linesSpacing; //行间距


#pragma mark - extension

/**
 * 更改扩展 label 中的文字效果
 
 * @param name  扩展的属性名 , CoreText 下的扩展 eg: kCTForegroundColorAttributeName
 * @param value 扩展的属性值
 * @param range 产生效果的位置
 */

- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;


#pragma mark - auto height

/**
 * 得到 label 的高度
 */

- (int)getAttributedStringHeightWidthValue:(int)width;

/**
 * 动态适配高度
 */
- (void)autoSizeToFit;

@end
