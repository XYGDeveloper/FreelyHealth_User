//
//  NoticeTableViewCell.m
//  app
//
//  Created by XI YANGUI on 2018/4/26.
//  Copyright © 2018年 XI YANGUI. All rights reserved.
//

#import "NoticeTableViewCell.h"
#import <Masonry.h>
#import "AppionmentListDetailModel.h"
@interface NoticeTableViewCell()
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UILabel *timecon;
@property (nonatomic,strong)UILabel *notice;
@property (nonatomic,strong)UILabel *noticecon;
@property (nonatomic,strong)UILabel *state;

@end
@implementation NoticeTableViewCell
- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textAlignment = NSTextAlignmentLeft;
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont systemFontOfSize:15];
    }
    return _time;
}

- (UILabel *)timecon{
    if (!_timecon) {
        _timecon = [[UILabel alloc]init];
        _timecon.textAlignment = NSTextAlignmentLeft;
        _timecon.textColor = [UIColor grayColor];
        _timecon.font = [UIFont systemFontOfSize:15];
    }
    return _timecon;
}

- (UILabel *)notice{
    if (!_notice) {
        _notice = [[UILabel alloc]init];
        _notice.textAlignment = NSTextAlignmentLeft;
        _notice.textColor = [UIColor grayColor];
        _notice.font = [UIFont systemFontOfSize:15];
    }
    return _notice;
}

- (UILabel *)noticecon{
    if (!_noticecon) {
        _noticecon = [[UILabel alloc]init];
        _noticecon.textAlignment = NSTextAlignmentLeft;
        _noticecon.textColor = [UIColor grayColor];
        _noticecon.font = [UIFont systemFontOfSize:15];
    }
    return _noticecon;
}

- (UILabel *)state{
    if (!_state) {
        _state = [[UILabel alloc]init];
        _state.textAlignment = NSTextAlignmentRight;
        _state.textColor = DefaultGrayLightTextClor;
        _state.font = [UIFont systemFontOfSize:15];
    }
    return _state;
}
- (void)layOut{
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    [self.timecon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.time.mas_right);
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    
    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.time.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    
    [self.noticecon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.notice.mas_right);
        make.top.mas_equalTo(self.time.mas_bottom).mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
    
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.time.mas_centerY);
        make.width.mas_equalTo(150);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(15);
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.timecon];
        [self.contentView addSubview:self.notice];
        [self.contentView addSubview:self.noticecon];
        [self.contentView addSubview:self.state];
        [self layOut];
    }
    return self;
}

- (void)refreshWithModel:(AppionmentListDetailModel *)model{
    _time.text = @"时      间:";
    _timecon.text = [Utils timeFormatterWithTimeString:model.huizhentime];
    _notice.text = @"提      醒:";
    _noticecon.text = @"提前1个小时  应用内";
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
