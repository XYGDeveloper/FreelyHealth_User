//
//  OVSDeployableLabel.m
//  LabelDemo
//
//  Created by cm on 2017/5/23.
//  Copyright © 2017年 com.peiziming. All rights reserved.
//

#import "OVSDeployableLabel.h"
#import <CoreText/CoreText.h>

@interface OVSDeployableLabel ()

@property (nonatomic, assign) BOOL isFold;
@property (nonatomic, assign) NSUInteger defaultNumeberOfLines;

@end

@implementation OVSDeployableLabel

- (instancetype)init
{
    return [self initWithFrame:CGRectZero DeployTip:nil];
}

- (instancetype)initWithDeployTip:(NSString *)deployTip
{
    return  [self initWithFrame:CGRectZero DeployTip:deployTip];
}

- (instancetype)initWithFrame:(CGRect)frame DeployTip:(NSString *)deployTip
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.deployTip = deployTip ? :@"更多";
        self.isFold = YES;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [self addGestureRecognizer:tap];

    }
    
    return self;
}

- (void)tapLabel:(UITapGestureRecognizer *)tap
{
    self.isFold = !self.isFold;
    self.numberOfLines = self.isFold ? _defaultNumeberOfLines : 0;
    
    [self setupLayout:self.numberOfLines width:self.frame.size.width];
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

- (void)drawRect
{
    [self drawRectWith:nil];
}

-(void)drawRectWith:(NSMutableAttributedString *)deployAttributdString
{
    if (deployAttributdString) {
        _deployAttributedString = deployAttributdString;
    }
    
    [self setNeedsDisplay];
    [self layoutIfNeeded];
}

#pragma mark 得到数组数量
- (NSUInteger)getLinesCount
{
    CFIndex linesCount = 0;

    if (self.bounds.size.width > 0) {
        NSAttributedString *attrbutedString = nil;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,self.textColor, NSForegroundColorAttributeName,nil];
            
        attrbutedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, FLT_MAX));
        
        CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attrbutedString);
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path, NULL);
        CFArrayRef linesRef = CTFrameGetLines(frameRef);
        linesCount = CFArrayGetCount(linesRef);
    }

    return linesCount;
}

- (void)drawRect:(CGRect)rect
{
    if (self.frame.size.width > 0) {
        NSAttributedString *attrbutedString = nil;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,self.textColor, NSForegroundColorAttributeName,nil];
            
        attrbutedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];

        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.bounds.size.width, FLT_MAX));
        
        CTFramesetterRef frameSetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) attrbutedString);
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetterRef, CFRangeMake(0, 0), path, NULL);
        CFArrayRef lines = CTFrameGetLines(frameRef);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMaxY(rect)); // 平移
        CGContextScaleCTM(context, 1, -1); // x轴转换
        
        CFIndex numberOfLines = CFArrayGetCount(lines);
        CGFloat lineHeight = self.font.lineHeight;
        
        CGFloat yOffset = self.bounds.size.height - (lineHeight/2);
        for (CFIndex index = 0; index < numberOfLines; index++) {
            CTLineRef lineRef = CFArrayGetValueAtIndex(lines, index);
            CGFloat ascent, descent, leading;
            CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
            
            CGContextSetTextPosition(context, 0, yOffset);
            if (index == self.numberOfLines - 1 && numberOfLines > self.numberOfLines && self.isFold == YES) {
                NSAttributedString *tokenAttrStr = [[NSAttributedString alloc] initWithString:@"\u2026" attributes:@{NSForegroundColorAttributeName : self.textColor,
                                                                                                                     NSFontAttributeName: self.font}];
                CTLineRef lineToken = CTLineCreateWithAttributedString((CFAttributedStringRef) tokenAttrStr);
                CTLineRef truncatedLineRef = CTLineCreateTruncatedLine(lineRef, self.bounds.size.width - [self getDeployWidth],
                                                                       kCTLineTruncationEnd, lineToken);
                CTLineDraw(truncatedLineRef, context);
                
                CGContextRestoreGState(context);
                [self.deployTip drawInRect:CGRectMake(self.bounds.size.width - [self getDeployWidth],
                                                      self.bounds.size.height - self.font.lineHeight,
                                                      [self getDeployWidth],
                                                      self.font.lineHeight)
                            withAttributes:@{NSForegroundColorAttributeName : self.deployColor,
                                             NSFontAttributeName: self.deployFont}];
                CGContextSaveGState(context);
                
                break;
            } else {
                CTLineDraw(lineRef, context);
            }
            
            yOffset -= lineHeight;
        }
        
        CGContextRestoreGState(context);
    }
}

- (void)setupLayout:(NSUInteger)numberOfLine width:(CGFloat)width
{
    if (numberOfLine > 0) {
        _defaultNumeberOfLines = numberOfLine;
    }
    
    CGRect rect = self.frame;
    self.numberOfLines = numberOfLine;
    rect.size.width = width;

    if (numberOfLine > 0) {
        self.isFold = YES;
        rect.size.height = self.font.lineHeight * numberOfLine;
    } else {
        self.isFold = NO;
        rect.size.height = self.font.lineHeight * [self getLinesCount];
    }
    
    self.frame = rect;
}

- (CGFloat)getDeployWidth
{
    return  [self.deployTip  boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX)
                                          options:NSStringDrawingUsesFontLeading
                                       attributes:@{NSForegroundColorAttributeName: self.textColor,
                                                    NSFontAttributeName: self.font} context:nil].size.width;
}

#pragma mark getter
//- (NSString *)deployTip
//{
//    if (!_deployTip) {
//        _deployTip = @"更多";
//    }
//    
//    return _deployTip;
//}

- (NSMutableAttributedString *)deployAttributedString
{
    if (!_deployAttributedString) {
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.deployFont, NSFontAttributeName,self.deployColor, NSForegroundColorAttributeName,nil];
        _deployAttributedString = [[NSMutableAttributedString alloc] initWithString:self.deployTip attributes:attributes];
    }

    return _deployAttributedString;
}

- (UIColor *)deployColor
{
    if (!_deployColor) {
        _deployColor = [UIColor blueColor];
    }
    
    return _deployColor;
}

- (UIFont *)deployFont
{
    if (!_deployFont) {
        _deployFont = self.font;
    }
    
    return _deployFont;
}

@end
