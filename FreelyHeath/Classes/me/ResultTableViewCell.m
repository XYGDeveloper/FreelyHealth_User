//
//  ResultTableViewCell.m
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "FileModel.h"
#define MARGIN 15
#define picWidth (kScreenWidth-40 - 4 * MARGIN) / 3
@interface ResultTableViewCell()

@property (nonatomic,strong)UILabel *serviceLabel;  //

@property (nonatomic,strong)UILabel *timellabel;  //


@property (nonatomic,strong)UILabel *question;  //

@property (nonatomic,strong)UIView *bottomline1;  //


@end


@implementation ResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.serviceLabel = [[UILabel alloc]init];
        self.serviceLabel.textAlignment = NSTextAlignmentLeft;
        self.serviceLabel.font = Font(18);
        self.serviceLabel.textColor = DefaultBlackLightTextClor;
        self.serviceLabel.text = @"健康评估";
        [self.contentView addSubview:self.serviceLabel];
        
        [self.serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(self.contentView.mas_top).mas_equalTo(5);
            make.width.mas_equalTo((kScreenWidth - 40)/2);
            make.height.mas_equalTo(20);
            
        }];
        
        self.timellabel = [[UILabel alloc]init];
        self.timellabel.textAlignment = NSTextAlignmentRight;
        
        self.timellabel.font = Font(12);
        
        self.timellabel.textColor = DefaultGrayTextClor;
        self.timellabel.text = @"";
        
        [self.contentView addSubview:self.timellabel];
        
        [self.timellabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.serviceLabel.mas_centerY);
            make.width.mas_equalTo((kScreenWidth - 40)/2);
            make.height.mas_equalTo(20);
        }];
        
        self.question = [[UILabel alloc]init];
        
        self.question.textAlignment = NSTextAlignmentLeft;
        
        self.question.font = Font(14);
        
        self.question.textColor = DefaultGrayTextClor;
        
        self.question.numberOfLines = 0;
        
        [self.contentView addSubview:self.question];
        
        [self.question mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(self.serviceLabel.mas_bottom).mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        
    }

    return self;
    

}


- (CGFloat)cellHeight {
    
    NSLog(@"%f",self.question.frame.size.height);
    
    return CGRectGetMaxY(self.question.frame);
    
}


- (void)setModel:(recordModel *)model
{

    _model = model;
    
    self.timellabel.text = model.createtime;
    
    _question.text = model.content;


}


- (CGSize)onGetFontsSizeWithText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(kScreenWidth - 30 - 45, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
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
