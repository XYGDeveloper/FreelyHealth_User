//
//  AppionmentChatTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentChatTableViewCell.h"
@interface AppionmentChatTableViewCell()
@property (nonatomic,strong)UIView *bgview;
@property (nonatomic,strong)UIImageView *groupChat;
@property (nonatomic,strong)UILabel *chatLabel;

@end

@implementation AppionmentChatTableViewCell

- (UIView *)bgview{
    if (!_bgview) {
        _bgview = [[UIView alloc]init];
        _bgview.backgroundColor = DefaultBackgroundColor;
        _bgview.layer.cornerRadius = 0.5;
        _bgview.layer.masksToBounds = YES;
    }
    return _bgview;
}
- (UIImageView *)groupChat{
    if (!_groupChat) {
        _groupChat = [[UIImageView alloc]init];
        _groupChat.image = [UIImage imageNamed:@"appionment_chat"];
        _groupChat.userInteractionEnabled = YES;
    }
    return _groupChat;
}
- (UILabel *)chatLabel{
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc]init];
        _chatLabel.textColor = DefaultGrayTextClor;
        _chatLabel.font = FontNameAndSize(16);
        _chatLabel.textAlignment = NSTextAlignmentLeft;
        _chatLabel.text = @"进入群聊会议";
        _chatLabel.userInteractionEnabled = YES;
    }
    return _chatLabel;
}

- (void)layOut{
    [self.bgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
    [self.groupChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.mas_equalTo(self.bgview.mas_centerY);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(20);
    }];
    [self.chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.groupChat.mas_right).mas_equalTo(25);
        make.centerY.mas_equalTo(self.bgview.mas_centerY);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
    }];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgview];
        [self.bgview addSubview:self.groupChat];
        [self.bgview addSubview:self.chatLabel];
        [self layOut];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
