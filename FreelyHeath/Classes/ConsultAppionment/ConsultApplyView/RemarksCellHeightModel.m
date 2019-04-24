//
//  RemarksCellHeightModel.m
//  EasyFlowerCustomer
//
//  Created by 罗金 on 16/2/26.
//  Copyright © 2016年 chenglin.zhao. All rights reserved.
//

#import "RemarksCellHeightModel.h"

@implementation RemarksCellHeightModel

/*
 * contentStr：Lable内容
 * isShow：是否展开
 * width：Lable的宽度
 * font：字号
 * defaultHeight：默认高度，若大于该高度则显示展开收起按钮，低于该高度则正常显示文字高度
 * fixedHeight：其他控件固定高度
 * btnHeight：展开收起按钮高度
 */
+ (CGFloat)cellHeightWith:(NSString *)contentStr andIsShow:(BOOL)isShow andLableWidth:(CGFloat)width andFont:(CGFloat)font andDefaultHeight:(CGFloat)defaultHeight andFixedHeight:(CGFloat)fixedHeight andIsShowBtn:(CGFloat)btnHeight
{
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    if (rect.size.height > defaultHeight) {
        if (isShow) {
            return fixedHeight + btnHeight + rect.size.height;
        }else{
            return fixedHeight + btnHeight + defaultHeight;
        }
    } else {
        return fixedHeight + rect.size.height;
    }
    
    return 100;
}

@end
