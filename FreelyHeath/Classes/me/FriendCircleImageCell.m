//
//  FriendCircleImageCell.m
//  ReactCocoaDemo
//
//  Created by letian on 16/12/5.
//  Copyright © 2016年 cmsg. All rights reserved.
//

#import "FriendCircleImageCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LTUITools.h"
#import "UIView+AnimationProperty.h"
#import "MBProgressHUD+BWMExtension.h"
@interface FriendCircleImageCell ()

@property (nonatomic,strong)MBProgressHUD *hub;

@end

@implementation FriendCircleImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [LTUITools lt_creatImageView];
        [self.contentView addSubview:self.imageView];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)cellDataWithImageName:(NSString *)imageName
{
    weakify(self);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"bingli_empty"]];
   
}

@end
