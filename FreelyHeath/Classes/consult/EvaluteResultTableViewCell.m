//
//  EvaluteResultTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/8/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "EvaluteResultTableViewCell.h"
#import "ResultModel.h"
#import "ASSModel.h"
@interface EvaluteResultTableViewCell()

@property (nonatomic,strong)UIImageView *content;

@property (nonatomic,strong)UILabel *label;


@end


@implementation EvaluteResultTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.content = [[UIImageView alloc]init];
        
        self.content.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.content];
        
        self.label = [[UILabel alloc]init];
        
        self.label.textColor = DefaultGrayTextClor;
        
        self.label.numberOfLines = 0;
        
        self.label.font  =Font(16);
        
        [self.content addSubview:self.label];
    
        [self layOutSub];
        
    }
    
    return self;
    


}

- (void)layOutSub{

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.left.top.right.bottom.mas_equalTo(0);
           
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(28.5);
        
        make.left.mas_equalTo(31);
        
        make.right.mas_equalTo(-31);
        
        make.bottom.mas_equalTo(-30);
    }];
    
}


- (void)refreshWithModel:(ASSModel *)model
{

    self.label.text = model.presult;

}

- (void)refreshWithResult:(ResultModel *)result
{

    self.label.text = result.result;

    
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
