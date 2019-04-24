//
//  OVSStringHelper.h
//  LabelDemo
//
//  Created by cm on 2017/5/24.
//  Copyright © 2017年 com.peiziming. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIColor;
@class UIFont;

@interface OVSStringHelper : NSObject {

}

/**
 * 处理字符串的helper
 */
+ (instancetype)sharedStringHelper;

/**
 * 分析处理html字符串
 */
- (NSAttributedString *)handleHtmlString:(NSString *)htmlString;

/**
 * 拼接
 */
//- (NSAttributedString *)handleHtmlString:(NSString *)htmlString appendString:(NSString *)appendString;

/**
 *  颜色不一样
 */
- (NSMutableAttributedString *)textColor:(UIColor *)color range:(NSRange)range1 color:(UIColor *)color2 range:(NSRange)range2 text:(NSString *)text;

/**
 * 字体不一样
 */
- (NSMutableAttributedString *)textFontSize:(UIFont *)font1 range:(NSRange)range1 fontSzie:(UIFont *)font2 withRange:(NSRange)range2 text:(NSString *)text;

@end
