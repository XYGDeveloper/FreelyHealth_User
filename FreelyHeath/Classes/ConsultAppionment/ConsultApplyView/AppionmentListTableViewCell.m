//
//  AppionmentListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentListTableViewCell.h"
#import "AppionmentListModel.h"
@interface AppionmentListTableViewCell()
@property (nonatomic,strong)UIImageView *mainImage;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *detailLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *stateLabel;

@end

@implementation AppionmentListTableViewCell
- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc]init];
        _mainImage.layer.cornerRadius = 5;
        _mainImage.layer.masksToBounds = YES;
    }
    return _mainImage;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = FontNameAndSize(17);
        _nameLabel.textColor = DefaultBlackLightTextClor;
    }
    return _nameLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = FontNameAndSize(14);
        _detailLabel.textColor = DefaultGrayLightTextClor;
    }
    return _detailLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.font = FontNameAndSize(14);
        _stateLabel.textColor = DefaultGrayLightTextClor;
    }
    return _stateLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = DefaultGrayLightTextClor;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.font = FontNameAndSize(14);
    }
    return _timeLabel;
}

- (void)layOut{
    [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.width.mas_equalTo(30.5);
        make.height.mas_equalTo(33.5);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mainImage.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(-80);
        make.height.mas_equalTo(16);
        make.top.mas_equalTo(self.mainImage.mas_top);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.mainImage.mas_top);
        make.height.mas_equalTo(15);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.detailLabel.mas_bottom).mas_equalTo(15);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(-15);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mainImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.stateLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.timeLabel];
        [self layOut];
        //test Datasource
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
    }
    return self;
}

- (void)refreshWithAppionmentModel:(AppionmentListModel *)model{
    NSArray *arr = [MemberChildModel mj_objectArrayWithKeyValuesArray:model.members];
    MemberChildModel *childModel = [arr firstObject];
    self.nameLabel.text = model.topic;
    if ([model.status isEqualToString:@"2"]) {
        self.mainImage.image = [UIImage imageNamed:@"appionment_wre"];
        self.stateLabel.text = @"待审核";
        if (![model.huizhentime isEqualToString:@""]) {
            self.timeLabel.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        }else{
            self.timeLabel.text = @"时间待沟通协调";
        }
        self.stateLabel.textColor = DefaultRedTextClor;
        if (model.member.length > 0) {
            self.detailLabel.text = model.member;
        }else if(model.members.count > 0){
            NSMutableArray *memberArr = [NSMutableArray array];
            for (MemberChildModel *model in arr) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",model.name,model.hname];
                [memberArr addObject:str];
            }
            self.detailLabel.text = [memberArr componentsJoinedByString:@","];
        }else{
            self.detailLabel.text = @"参会成员待沟通协调";

        }
    }else if ([model.status isEqualToString:@"1"]){
        self.mainImage.image = [UIImage imageNamed:@"appionment_wre"];
        if (model.member.length > 0) {
            self.detailLabel.text = model.member;
        }else if(model.members.count > 0){
            NSMutableArray *memberArr = [NSMutableArray array];
            for (MemberChildModel *model in arr) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",model.name,model.hname];
                [memberArr addObject:str];
            }
            self.detailLabel.text = [memberArr componentsJoinedByString:@","];
        }else{
            self.detailLabel.text = @"参会成员待沟通协调";
            
        }
        self.stateLabel.text = @"待审核";
        if (![model.huizhentime isEqualToString:@""]) {
            self.timeLabel.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        }else{
            self.timeLabel.text = @"时间待沟通协调";
        }
        self.stateLabel.textColor = DefaultRedTextClor;
        
    }else if ([model.status isEqualToString:@"3"]){
        self.mainImage.image = [UIImage imageNamed:@"appionment_whz"];
        self.timeLabel.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        if (model.member.length > 0) {
            self.detailLabel.text = model.member;
        }else if(model.members.count > 0){
            NSMutableArray *memberArr = [NSMutableArray array];
            for (MemberChildModel *model in arr) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",model.name,model.hname];
                [memberArr addObject:str];
            }
            self.detailLabel.text = [memberArr componentsJoinedByString:@","];
        }else{
            self.detailLabel.text = @"参会成员待沟通协调";
        }
        self.stateLabel.text = @"待会诊";
        self.stateLabel.textColor = AppStyleColor;
    }else{
        self.mainImage.image = [UIImage imageNamed:@"appionment_finish"];
        self.timeLabel.text = [Utils timeFormatterWithTimeString:model.huizhentime];
        if (model.member.length > 0) {
            self.detailLabel.text = model.member;
        }else if(model.members.count > 0){
            NSMutableArray *memberArr = [NSMutableArray array];
            for (MemberChildModel *model in arr) {
                NSString *str = [NSString stringWithFormat:@"%@ %@",model.name,model.hname];
                [memberArr addObject:str];
            }
            self.detailLabel.text = [memberArr componentsJoinedByString:@","];
        }else{
            self.detailLabel.text = @"参会成员待沟通协调";
            
        }
        self.stateLabel.text = @"已完成";
        self.stateLabel.textColor = DefaultGrayTextClor;
        
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
