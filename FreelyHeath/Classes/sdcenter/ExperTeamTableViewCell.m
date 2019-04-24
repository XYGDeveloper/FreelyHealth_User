//
//  ExperTeamTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ExperTeamTableViewCell.h"
#import "TeamListModel.h"
@interface ExperTeamTableViewCell ()

@property (nonatomic,strong)UIImageView *bgimage;

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *Hospital;



@end

@implementation ExperTeamTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.bgimage = [[UIImageView alloc]init];
        
        self.bgimage.image = [UIImage imageNamed:@"sddetail_letbutton_cell_bg_image"];
        
        [self.contentView addSubview:self.bgimage];
        
        self.name = [[UILabel alloc]init];
        
        self.name.textAlignment = NSTextAlignmentLeft;
        
        self.name.font = Font(14);
        
        self.name.textColor = DefaultBlackLightTextClor;
        
        [self.bgimage addSubview:self.name];
        
        self.Hospital = [[UILabel alloc]init];
        
        self.Hospital.textAlignment = NSTextAlignmentLeft;
        
        self.Hospital.textColor = DefaultGrayTextClor;
        
        self.Hospital.font = Font(14);
        
        [self.bgimage addSubview:self.Hospital];
        
    }

    return self;
    

}


- (void)refreshWith:(MemberModel *)model
{

    self.name.text = model.name;
    
    self.Hospital.text = [NSString stringWithFormat:@"%@：%@",model.job,model.hname];

}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.bgimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(43.5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.Hospital mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.name.mas_right).mas_equalTo(5);
        make.right.mas_equalTo(-30.5);
        make.height.mas_equalTo(16);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
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
