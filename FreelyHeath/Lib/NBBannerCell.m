//
//  NBBannerCell.m
//  页面分离
//
//  Created by xxzx on 2017/12/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NBBannerCell.h"
#import "Masonry.h"
#import "NBBannerConfig.h"

@implementation NBBannerCell

- (void)setConfig:(NBBannerConfig *)config
{
    _config = config;
    self.contentView.layer.cornerRadius = config.cornerRadius;
    self.contentView.layer.masksToBounds = YES;
    _textLabel.textAlignment = config.textAlignment;
    _textLabel.textColor = config.textColor;
    _textLabel.font = [UIFont systemFontOfSize:config.textFontSize];
    _textLabel.hidden = !config.isShowText;
}

- (void)setBannerModel:(id<NBBannerModelProtocol>)bannerModel
{
    _bannerModel = bannerModel;
    _textLabel.text = bannerModel.title;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self imageView];
    
    [self textLabel];
}

#pragma mark - 懒加载
- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _imageView;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
        }];
    }
    return _textLabel;
}

@end
