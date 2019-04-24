//
//  HisBgTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/11/17.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "HisBgTableViewCell.h"
#import "HistoryModel.h"
@interface HisBgTableViewCell()

@property (nonatomic,strong)UILabel *hos;

@property (nonatomic,strong)UILabel *creatTime;

@end

@implementation HisBgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.hos = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kScreenWidth - 100, 30)];
        self.hos.font = [UIFont fontWithName:@"PingFangSC-Light" size:16.0f];

        [self.contentView addSubview:self.hos];
        
        self.creatTime = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.hos.frame), kScreenWidth - 100, 30)];
        
        self.creatTime.textColor = DefaultGrayLightTextClor;
        self.creatTime.font = [UIFont fontWithName:@"PingFangSC-Light" size:13.0f];

        [self.contentView addSubview:self.creatTime];
        
    }
    
    return self;
    
}


- (void)refreshWithModel:(HistoryModel *)model
{
    self.hos.text = model.tjjg;
    self.creatTime.text = model.createtime;
    
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
