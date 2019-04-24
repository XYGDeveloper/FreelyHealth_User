//
//  ZFAutoLabel.m
//  DrawTest
//
//  Created by mac on 11/11/14.
//  Copyright (c) 2014 (zhifei - qiuzhifei521@gmail.com). All rights reserved.
//

#import "ZFAutoLabel.h"


NSString * zfNameFromFullName(NSString * fullName) {
    
    UIFont *font = [UIFont fontWithName:fullName size:1];
    return (__bridge NSString *)(CTFontCopyPostScriptName((__bridge CTFontRef)(font)));
}

NSRange maxRangeFromString(NSString * string, NSRange range) {
    
    NSInteger max_length = [string length];
    
    NSInteger location = range.location;
    NSInteger length = range.length;
    
    NSInteger cu_max_length = location + length;
    
    if (cu_max_length <= max_length) {
        
        
    } else {
        
        if (location >= max_length) {
            
            location = 0;
            length = 0;
        } else {
            
            length = max_length - location;
        }
    }
    
    return NSMakeRange(location, length);
}

@interface ZFAutoLabel ()

@property (nonatomic, strong) NSMutableAttributedString * attributedString;

@property (nonatomic, strong) NSMutableAttributedString * tempAttributedString;

- (void) initAttributedString;

@end

@implementation ZFAutoLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.attributedString = nil;
        self.tempAttributedString = nil;

        [self setCharacterSpacing:FONT_SIZE_SPACING
                      withDisplay:NO];
        
        [self setLinesSpacing:LIST_SPACING
                  withDisplay:NO];
    }
    return self;
}

#pragma mark - set text

/*
 *重写setText方法
 */

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    NSString * labelString = @"";
    
    if (self.text) {
        
        labelString = self.text;
    }
    
    NSString *myString = [labelString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    //创建AttributeString
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    self.tempAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
}

#pragma mark - 设置 label 属性

///外部调用设置字间距
- (void)setCharacterSpacing:(CGFloat)characterSpacing
{
    [self setCharacterSpacing:characterSpacing
                  withDisplay:YES];
}

- (void)setCharacterSpacing:(CGFloat)characterSpacing withDisplay:(BOOL)flag
{
    _characterSpacing = characterSpacing;
    
    if (flag) {
        
        [self setNeedsDisplay];
    }
}

///外部调用设置行间距
- (void)setLinesSpacing:(long)linesSpacing
{
    [self setLinesSpacing:linesSpacing
              withDisplay:YES];
}

- (void)setLinesSpacing:(long)linesSpacing withDisplay:(BOOL)flag
{
    _linesSpacing = linesSpacing;
    if (flag) {
        
        [self setNeedsDisplay];
    }
}

/*
 * 初始化AttributedString并进行相应的设置
 */
- (void)initAttributedString
{
    //设置字体大小
    
    CTFontRef helveticaBold = CTFontCreateWithName((CFStringRef)zfNameFromFullName(self.font.familyName), self.font.pointSize, NULL);
    [self.attributedString addAttribute:(id)kCTFontAttributeName value:(__bridge id)helveticaBold range:NSMakeRange(0, [self.attributedString length])];
    
    
    //设置字间距
    
    long number = self.characterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
    [self.attributedString addAttribute:(id) kCTKernAttributeName value:(__bridge id) num range:NSMakeRange(0, [self.attributedString length])];
    
    
    //设置字体颜色
    
    
    [self.attributedString addAttribute:(id)kCTForegroundColorAttributeName value:(__bridge id)(self.textColor.CGColor) range:NSMakeRange(0, [self.attributedString length])];
    
    //创建文本对齐方式
    
    CTTextAlignment alignment = kCTLeftTextAlignment;
    if (self.textAlignment == NSTextAlignmentCenter) {
        alignment = kCTCenterTextAlignment;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        alignment = kCTRightTextAlignment;
    }
    
    CTParagraphStyleSetting alignmentStyle;
    
    alignmentStyle.spec = kCTParagraphStyleSpecifierAlignment;
    
    alignmentStyle.valueSize = sizeof(alignment);
    
    alignmentStyle.value = &alignment;
    
    //设置文本行间距
    
    CGFloat lineSpace = self.linesSpacing;
    CTParagraphStyleSetting lineSpaceStyle;
    lineSpaceStyle.spec = kCTParagraphStyleSpecifierLineSpacingAdjustment;
    lineSpaceStyle.valueSize = sizeof(lineSpace);
    lineSpaceStyle.value = &lineSpace;
    
    
    //设置文本段间距
    CGFloat paragraphpacing = 1.0;
    
    CTParagraphStyleSetting paragraphSpaceStyle;
    paragraphSpaceStyle.spec = kCTParagraphStyleSpecifierParagraphSpacing;
    paragraphSpaceStyle.valueSize = sizeof(CGFloat);
    paragraphSpaceStyle.value = &paragraphpacing;
    
    //创建设置数组
    CTParagraphStyleSetting settings[ ]={alignmentStyle,lineSpaceStyle,paragraphSpaceStyle};
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    
    //给文本添加设置
    [self.attributedString addAttribute:(id) kCTParagraphStyleAttributeName value:(__bridge id)style range:NSMakeRange(0, [self.attributedString length])];
    
    
    //通过temp设置其他属性
    [self.tempAttributedString enumerateAttributesInRange:NSMakeRange(0, self.tempAttributedString.string.length) options:NSAttributedStringEnumerationReverse usingBlock:
     ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
         
         if ([[attributes allKeys] count] > 0) {
             
             for (id key in [attributes allKeys]) {
                 
                 id value = [attributes objectForKey:key];
                 
                 if (value) {
                     
                     [self.attributedString addAttribute:key
                                                   value:value
                                                   range:range];
                     
                 }
             }
         }
     }];
    
    
    CFRelease(helveticaBold);
}

#pragma mark - extentsion

- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range
{
    [self.tempAttributedString addAttribute:name
                                      value:value
                                      range:maxRangeFromString(self.tempAttributedString.string, range)];
    
    [self setNeedsDisplay];
}

#pragma mark - draw

/*
 *开始绘制
 */

-(void) drawTextInRect:(CGRect)requestedRect
{
    [self initAttributedString];
    
    //排版
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    
    CGPathAddRect(leftColumnPath, NULL ,CGRectMake(0 , 0 ,self.bounds.size.width , self.bounds.size.height));
    
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0, 0), leftColumnPath , NULL);
    
    //翻转坐标系统（文本原来是倒的要翻转下）
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context , CGAffineTransformIdentity);
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    
    CGContextScaleCTM(context, 1.0 ,-1.0);
    
    //画出文本
    
    CTFrameDraw(leftFrame,context);
    
    //释放
    
    CGPathRelease(leftColumnPath);
    
    CFRelease(framesetter);
    
    UIGraphicsPushContext(context);
}


#pragma mark - get height

/*
 *绘制前获取label高度
 */
- (int)getAttributedStringHeightWidthValue:(int)width
{
    if (self.text == nil ||
        [self.text isEqualToString:@""]) {
        
        return 0;
    }
    
    [self initAttributedString];
    
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 100000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 100000 - line_y + (int) descent +1;//+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    
    return total_height;
    
}

- (void)autoSizeToFit
{
    CGRect frame = self.frame;
    CGFloat height = [self getAttributedStringHeightWidthValue:self.bounds.size.width];
    frame.size.height = height;
    self.frame = frame;
}



@end
