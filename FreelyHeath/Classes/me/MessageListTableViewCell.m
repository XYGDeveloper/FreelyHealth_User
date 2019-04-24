//
//  MessageListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MessageListTableViewCell.h"
#import "MyMessageModel.h"
@interface MessageListTableViewCell()

@end

@implementation MessageListTableViewCell

- (UIImageView *)headImage{
    if (!_headImage) {
        _headImage = [[UIImageView alloc]init];
        _headImage.image = [UIImage imageNamed:@"message_notice"];
    }
    return _headImage;
}
- (UILabel *)messageNameLabel{
    if (!_messageNameLabel) {
        _messageNameLabel = [[UILabel alloc]init];
        _messageNameLabel.textAlignment = NSTextAlignmentLeft;
        _messageNameLabel.textColor = DefaultBlackLightTextClor;
        _messageNameLabel.font = Font(16);
    }
    return _messageNameLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = DefaultGrayLightTextClor;
        _timeLabel.font = Font(14);
    }
    return _timeLabel;
}

- (UILabel *)messageContentLabel{
    if (!_messageContentLabel) {
        _messageContentLabel = [[UILabel alloc]init];
        _messageContentLabel.textAlignment = NSTextAlignmentLeft;
        _messageContentLabel.font = FontNameAndSize(15);
        _messageContentLabel.textColor = DefaultGrayTextClor;
    }
    return _messageContentLabel;
}
- (UILabel *)badgeLabel{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.font = FontNameAndSize(10);
        _badgeLabel.layer.cornerRadius = 7.5;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.textColor = [UIColor whiteColor];
    }
    return _badgeLabel;
}

- (UILabel *)bottomButton{
    if (!_bottomButton) {
        _bottomButton = [[UILabel alloc]init];
        _bottomButton.backgroundColor = DefaultBackgroundColor;
    }
    return _bottomButton;
}
- (void)layOut{
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.height.mas_equalTo(30);
    }];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(-10.5);
        make.bottom.mas_equalTo(self.headImage.mas_top).mas_equalTo(10.5);
    }];
    [self.messageNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_top);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImage.mas_top);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(self.messageNameLabel.mas_right).mas_equalTo(15);
    }];
    
    [self.messageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImage.mas_right).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.messageNameLabel.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageContentLabel.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headImage];
        [self.contentView addSubview:self.messageNameLabel];
        [self.contentView addSubview:self.messageContentLabel];
        [self.contentView addSubview:self.badgeLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.bottomButton];
        
        [self layOut];

    }
    return self;
}

- (void)refreshWithModel:(MyMessageModel *)model counts:(NSString *)counts{
    self.messageNameLabel.text = @"会诊消息";
    _headImage.image = [UIImage imageNamed:@"hzmessage"];
    if ([counts intValue] > 0) {
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",[counts intValue]];
        self.badgeLabel.backgroundColor = DefaultRedTextClor;
    }else{
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",[counts intValue]];
        self.badgeLabel.backgroundColor = [UIColor whiteColor];
    }
    if (model.msg) {
        self.messageContentLabel.text = model.msg;
    }else{
        self.messageContentLabel.text = @"暂无会诊消息";
    }
    if (model.createtime) {
        self.timeLabel.text = [Utils formateDate:model.createtime];
    }else{
        self.timeLabel.text = @"";
    }
}

- (void)refreshWithMessageCounts:(NSString *)counts{
    self.messageNameLabel.text = @"会话消息提醒";
//    self.messageContentLabel.text = @"聊天回话消息";
    if ([counts intValue] > 0) {
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",[counts intValue]];
        self.badgeLabel.backgroundColor = DefaultRedTextClor;
    }else{
        self.badgeLabel.text = [NSString stringWithFormat:@"%d",[counts intValue]];
        self.badgeLabel.backgroundColor = [UIColor whiteColor];
    }
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
