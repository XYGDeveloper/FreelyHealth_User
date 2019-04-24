//
//  OVSStringHelper.m
//  LabelDemo
//
//  Created by cm on 2017/5/24.
//  Copyright © 2017年 com.peiziming. All rights reserved.
//

#import "OVSStringHelper.h"
#import <UIKit/UIKit.h>

static OVSStringHelper *helper;

@implementation OVSStringHelper

+ (instancetype)sharedStringHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    
    return helper;
}

- (NSAttributedString *)handleHtmlString:(NSString *)htmlString
{
    return [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
}

- (NSMutableAttributedString *)textColor:(UIColor *)color range:(NSRange)range1 color:(UIColor *)color2 range:(NSRange)range2 text:(NSString *)text
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSForegroundColorAttributeName value:color range:range1];
    [attrString addAttribute:NSForegroundColorAttributeName value:color2 range:range2];
    
    return attrString;
}

- (NSMutableAttributedString *)textFontSize:(UIFont *)font1 range:(NSRange)range1 fontSzie:(UIFont *)font2 withRange:(NSRange)range2 text:(NSString *)text
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSFontAttributeName value:font1 range:range1];
    [attrString addAttribute:NSFontAttributeName value:font2 range:range2];
    
    return attrString;
}

@end
