//
//  CountTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CountTableViewCell.h"
#import "DoctorModel.h"
@interface CountTableViewCell ()

@property (nonatomic,strong)UILabel *goodCommentCount;

@property (nonatomic,strong)UILabel *goodCommentContent;

@property (nonatomic,strong)UILabel *sep;

@property (nonatomic,strong)UILabel *auswerCountLabel;

@property (nonatomic,strong)UILabel *auswerContent;


@end

@implementation CountTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.goodCommentCount = [UILabel new];
        
        self.goodCommentCount.text = @"好评数";
        
        self.goodCommentCount.textAlignment = NSTextAlignmentCenter;
        
        self.goodCommentCount.textColor = DefaultGrayTextClor;
        
        self.goodCommentCount.font = Font(16);
        
        [self.contentView addSubview:self.goodCommentCount];
        
        self.goodCommentContent = [UILabel new];
        
        self.goodCommentContent.text = @"6789";
        
        self.goodCommentContent.textAlignment = NSTextAlignmentCenter;
        
        self.goodCommentContent.textColor = DefaultBlueTextClor;
        
        self.goodCommentContent.font = Font(20);
        
        [self.contentView addSubview:self.goodCommentContent];
        
        self.sep = [UILabel new];
        
        self.sep.backgroundColor = DividerGrayColor;
        
        [self.contentView addSubview:self.sep];
        
        self.auswerCountLabel = [UILabel new];
        
        self.auswerCountLabel.text = @"回答数";
        
        self.auswerCountLabel.textAlignment = NSTextAlignmentCenter;
        
        self.auswerCountLabel.textColor = DefaultGrayTextClor;
        
        self.auswerCountLabel.font = Font(16);
        
        [self.contentView addSubview:self.auswerCountLabel];
        
        self.auswerContent = [UILabel new];
        
        self.auswerContent.text = @"4567";
        
        self.auswerContent.textAlignment = NSTextAlignmentCenter;
        
        self.auswerContent.textColor = DefaultBlueTextClor;
        
        self.auswerContent.font = Font(20);
        
        [self.contentView addSubview:self.auswerContent];
        
        
        
    }
    
    return self;
    
    

}


- (void)refreshWithModel:(DoctorModel *)model
{

    self.goodCommentContent.text = [NSString stringWithFormat:@"%d",model.agreenum];
    
    self.auswerContent.text = [NSString stringWithFormat:@"%d",model.backnum];


}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    CGFloat width = 60;
    
    [self.goodCommentCount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo((kScreenWidth - 60 *4)/6);
        
        make.width.mas_equalTo(width);
        
        make.height.mas_equalTo(20);
        
    }];
    
    [self.goodCommentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(self.goodCommentCount.mas_right).mas_equalTo((kScreenWidth - 60 *4)/6);
        
        make.width.mas_equalTo(width);
        
        make.height.mas_equalTo(20);
        
    }];
    
    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        
        make.width.mas_equalTo(1);
        
        make.top.mas_equalTo(10);
        
        make.bottom.mas_equalTo(-10);

        
    }];
    
    [self.auswerCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(self.sep.mas_right).mas_equalTo((kScreenWidth - 60 *4)/6);
        
        make.width.mas_equalTo(width);
        
        make.height.mas_equalTo(20);
        
    }];
    
    [self.auswerContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        
        make.left.mas_equalTo(self.auswerCountLabel.mas_right).mas_equalTo((kScreenWidth - 60 *4)/6);
        
        make.width.mas_equalTo(width);
        
        make.height.mas_equalTo(20);
        
    }];


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
