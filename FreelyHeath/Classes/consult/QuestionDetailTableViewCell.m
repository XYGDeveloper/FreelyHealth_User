//
//  QuestionDetailTableViewCell.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QuestionDetailTableViewCell.h"
#import "UIView+WHC_AutoLayout.h"
#import "AuswerDetailModel.h"
@interface QuestionDetailTableViewCell ()

@property (nonatomic,strong)UIImageView *headimg;

@property (nonatomic,strong)UILabel *name;

@property (nonatomic,strong)UILabel *jop;

@property (nonatomic,strong)UILabel *thumpupcount;

@property (nonatomic,strong)UIButton *thumpupButton;

@property (nonatomic,strong)UILabel *questionLabel;

@property (nonatomic,strong)UILabel *auswerLabel;

@property (nonatomic,strong)UIView *line;

@end

@implementation QuestionDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headimg = [UIImageView new];
        
        self.headimg.layer.cornerRadius = 30;
        
        self.headimg.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.headimg];
        
        self.name = [UILabel new];
        
        self.name.textAlignment = NSTextAlignmentLeft;
        
        self.name.font = Font(16);
        
        self.name.textColor = DefaultBlackLightTextClor;
        
        [self.contentView addSubview:self.name];
        
        self.jop = [UILabel new];
        
        self.jop.textAlignment = NSTextAlignmentLeft;
        
        self.jop.font = Font(14);
        
        self.jop.textColor = DefaultGrayTextClor;
        
        [self.contentView addSubview:self.jop];
        
        self.thumpupcount = [UILabel new];
        
        self.thumpupcount.textAlignment = NSTextAlignmentRight;
        
        self.thumpupcount.font = Font(16);
        
        self.thumpupcount.textColor = AppStyleColor;
        
        [self.contentView addSubview:self.thumpupcount];
        
        self.thumpupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.thumpupButton addTarget:self action:@selector(toTHump) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.thumpupButton];

        self.auswerLabel = [UILabel new];
        
        self.auswerLabel.textAlignment = NSTextAlignmentLeft;
        
        self.auswerLabel.numberOfLines = 0;
        
        self.auswerLabel.font = Font(16);
        
        self.auswerLabel.textColor = DefaultBlackLightTextClor;
        
        [self.contentView addSubview:self.auswerLabel];
        
        //
        
//        self.headimg.backgroundColor = [UIColor redColor];
//        
//        self.name.backgroundColor = [UIColor redColor];
//        
//        self.jop.backgroundColor = [UIColor redColor];
//        
//        self.thumpupcount.backgroundColor = [UIColor redColor];
//        
//        self.thumpupButton.backgroundColor = [UIColor redColor];
//        
//        self.questionLabel.backgroundColor = [UIColor redColor];
//        
//        self.auswerLabel.backgroundColor = [UIColor redColor];
        
        self.headimg.image = [UIImage imageNamed:@"machine"];
     
        
        [self.thumpupButton setImage:[UIImage imageNamed:@"thump"] forState:UIControlStateNormal];

        
        self.line = [[UIView alloc]init];
        
        self.line.backgroundColor = DefaultBackgroundColor;
        
        [self.contentView addSubview:self.line];
        
        
    }
    
    return self;
    
    
}

- (void)refreshWiothModel:(AuswerDetailModel *)model
{

    [self.headimg sd_setImageWithURL:[NSURL URLWithString:model.facepath] placeholderImage:[UIImage imageNamed:@"005x68CJgy6NHxegyOW5e&690.jpg"]];
    
    self.name.text = model.dname;
    
    self.jop.text = [NSString stringWithFormat:@"%@ | %@",model.job,model.hname];
    
    self.auswerLabel.text = model.answer;
    
    self.thumpupcount.text = model.agreenum;
    
}



- (void)layoutSubviews
{
    
    [self.headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headimg.mas_top);
        make.left.mas_equalTo(self.headimg.mas_right).mas_equalTo(15);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(-150);
    }];
    
    [self.jop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.name.mas_bottom);
        make.left.mas_equalTo(self.headimg.mas_right).mas_equalTo(15);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(0);
    }];
    
    [self.thumpupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [self.thumpupcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.thumpupButton.mas_left);
        make.centerY.mas_equalTo(self.thumpupButton.mas_centerY);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    
    [self.auswerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headimg.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.auswerLabel.mas_bottom).mas_equalTo(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(15);
    }];
    
}

- (void)toTHump{
    
    if (self.thump) {
        
        self.thump();
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
