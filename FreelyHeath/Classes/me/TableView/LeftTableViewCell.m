//
//  LeftTableViewCell.m
//  Linkage
//
//  Created by LeeJay on 16/8/22.
//  Copyright © 2016年 LeeJay. All rights reserved.
//  代码下载地址https://github.com/leejayID/Linkage

#import "LeftTableViewCell.h"
#import "UIImage+GradientColor.h"
#define defaultColor rgba(253, 212, 49, 1)

@interface LeftTableViewCell ()

@property (nonatomic, strong) UIView *yellowView;

@end

@implementation LeftTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 100 - 10 - 5-5, 55)];
        self.name.numberOfLines = 0;
        self.name.font = FontNameAndSize(15);
        self.name.textColor = DefaultGrayTextClor;
        self.name.highlightedTextColor = DefaultGrayLightTextClor;
        [self.contentView addSubview:self.name];
        self.yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 55)];
        self.yellowView.backgroundColor = AppStyleColor;
        [self.contentView addSubview:self.yellowView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : DefaultBackgroundColor;
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

@end
