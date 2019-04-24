//
//  WailtToPayNoticeTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "WailtToPayNoticeTableViewCell.h"
#import "AppionmentListDetailModel.h"
#import "AppionmentListModel.h"

@interface WailtToPayNoticeTableViewCell()
@property (nonatomic,strong)UILabel *time;
@property (nonatomic,strong)UILabel *notice;
@property (nonatomic,strong)UILabel *attend;
@property (nonatomic,strong)UILabel *attendcon;
@property (nonatomic,strong)UILabel *timecon;
@property (nonatomic,strong)UILabel *noticecon;

@end

@implementation WailtToPayNoticeTableViewCell
- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.textAlignment = NSTextAlignmentLeft;
        _time.textColor = DefaultGrayLightTextClor;
        _time.font = FontNameAndSize(16);
    }
    return _time;
}
- (UILabel *)timecon{
    if (!_timecon) {
        _timecon = [[UILabel alloc]init];
        _timecon.textAlignment = NSTextAlignmentLeft;
        _timecon.textColor = DefaultGrayLightTextClor;
        _timecon.font = FontNameAndSize(16);
    }
    return _timecon;
}
- (UILabel *)notice{
    if (!_notice) {
        _notice = [[UILabel alloc]init];
        _notice.textAlignment = NSTextAlignmentLeft;
        _notice.textColor = DefaultGrayLightTextClor;
        _notice.font = FontNameAndSize(16);
    }
    return _notice;
}
- (UILabel *)noticecon{
    if (!_noticecon) {
        _noticecon = [[UILabel alloc]init];
        _noticecon.textAlignment = NSTextAlignmentLeft;
        _noticecon.textColor = DefaultGrayLightTextClor;
        _noticecon.font = FontNameAndSize(16);
    }
    return _noticecon;
}
- (UILabel *)attend{
    if (!_attend) {
        _attend = [[UILabel alloc]init];
        _attend.textAlignment = NSTextAlignmentLeft;
        _attend.textColor = DefaultGrayLightTextClor;
        _attend.font = FontNameAndSize(16);
        _attend.numberOfLines = 0;
    }
    return _attend;
}
- (UILabel *)attendcon{
    if (!_attendcon) {
        _attendcon = [[UILabel alloc]init];
        _attendcon.textAlignment = NSTextAlignmentLeft;
        _attendcon.textColor = DefaultGrayLightTextClor;
        _attendcon.font = FontNameAndSize(16);
        _attendcon.numberOfLines = 0;
    }
    return _attendcon;
}

- (void)layOut{
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    [self.timecon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.time.mas_right);
        make.top.mas_equalTo(5);
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
    [self.attend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.notice.mas_bottom).mas_equalTo(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(15);
    }];
    [self.attendcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.attend.mas_right);
        make.top.mas_equalTo(self.notice.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-10);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.timecon];
        [self.contentView addSubview:self.notice];
        [self.contentView addSubview:self.noticecon];
        [self.contentView addSubview:self.attend];
        [self.contentView addSubview:self.attendcon];
        [self layOut];
    }
    return self;
}

- (void)refreshWithAppionmentDetailModel:(AppionmentListDetailModel *)model{
    //state = 2 待审核状态
    if ([model.status isEqualToString:@"1"]) {
        _time.text = @"时      间:";
        _timecon.text = @"时间沟通协调中";
        _notice.text = @"提      醒:";
        _noticecon.text = @"提前1个小时  应用内";
        NSArray *arr = [MemberChildModel mj_objectArrayWithKeyValuesArray:model.members];
        MemberChildModel *childModel = [arr firstObject];
        if (model.member.length > 0) {
            self.attend.text = @"参会人员:";
            self.attendcon.text = model.member;
        }else if(model.members.count > 0){
            NSMutableArray *memberArr = [NSMutableArray array];
            for (MemberChildModel *model in arr) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",model.name,model.hname];
                [memberArr addObject:str];
            }
            self.attend.text = @"参会人员:";
            self.attendcon.text = [NSString stringWithFormat:@"%@",[memberArr componentsJoinedByString:@","]];
        }else{
            self.attend.text = @"参会人员:";
            self.attendcon.text =@"参会成员沟通协调中";
        }
    }else if ([model.status isEqualToString:@"2"]){
        _time.text = @"时      间:";
        _timecon.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        _notice.text = @"提      醒:";
        _noticecon.text = @"提前1个小时  应用内";
        NSArray *arr = [MemberChildModel mj_objectArrayWithKeyValuesArray:model.members];
        if (model.member.length > 0) {
            self.attend.text = @"参会人员:";
            self.attendcon.text = model.member;
        }else if(model.members.count > 0){
            NSMutableArray *memberArr = [NSMutableArray array];
            for (MemberChildModel *model in arr) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",model.name,model.hname];
                [memberArr addObject:str];
            }
            self.attend.text = @"参会人员:";
            self.attendcon.text = [NSString stringWithFormat:@"%@",[memberArr componentsJoinedByString:@","]];
        }else{
            self.attend.text = @"参会人员:";
            self.attendcon.text =@"参会成员沟通协调中";
        }
    }else if([model.status isEqualToString:@"3"]){
        _time.text = @"时      间:";
        _timecon.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        _notice.text = @"提      醒:";
        _noticecon.text = @"提前1个小时  应用内";
        if (model.member.length > 0) {
            self.attend.text = @"参会人员:";
            self.attendcon.text = model.member;
        }else{
            self.attend.text = @"参会人员:";
            self.attendcon.text =@"参会成员沟通协调中";
        }
    }else{
        _time.text = @"时      间:";
        _timecon.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        _notice.text = @"提      醒:";
        _noticecon.text = @"提前1个小时  应用内";
        if (model.member.length > 0) {
            self.attend.text = @"参会人员:";
            self.attendcon.text = model.member;
        }else{
            self.attend.text = @"参会人员:";
            self.attendcon.text =@"参会成员沟通协调中";
        }
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
