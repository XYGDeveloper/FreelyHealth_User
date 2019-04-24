//
//  MyIntroTableViewCell.m
//  MedicineClient
//
//  Created by xyg on 2017/8/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyIntroTableViewCell.h"

#import "CaseDetailModel.h"

@interface MyIntroTableViewCell()

@property (nonatomic,strong)UILabel *intro;

@property (nonatomic,strong)UILabel *sep;



@end

@implementation MyIntroTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

        
        self.intro = [[UILabel alloc]init];
        
        self.intro.textColor = DefaultGrayTextClor;
        
        
        self.intro.textAlignment = NSTextAlignmentLeft;
        
        self.intro.font = FontNameAndSize(16);
        
        [self.contentView addSubview:self.intro];
        
        self.sep = [[UILabel alloc]init];
        
        self.sep.backgroundColor = DefaultGrayLightTextClor;
        
        self.sep.alpha  = 0;
        
        [self.contentView addSubview:self.sep];
        
        self.introContent = [[UILabel alloc]init];
        
        self.introContent.numberOfLines = 0;
        
        self.introContent.textColor = DefaultGrayLightTextClor;
        
        self.introContent.font = FontNameAndSize(16);
        
        [self.contentView addSubview:self.introContent];
        [self layOut];
    }
    
    return self;
    
}


- (void)layOut{

     [self.intro mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(20);
         make.top.mas_equalTo(5);
         make.right.mas_equalTo(-16);
         make.height.mas_equalTo(25);
     }];
    
    [self.sep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.intro.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.introContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sep.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-15);
    }];
}
- (void)refreshWirthModel:(CaseDetailModel *)model
{
    self.intro.text = @"婚育史、月经史（女性）";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.hun.length <= 0) {
        self.introContent.text = @"用户未填写";
    }else{
        self.introContent.text = model.hun;
    }
}

- (void)refreshWirthModel1:(CaseDetailModel *)model{
    self.intro.text = @"家族病史";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.jiazu.length <= 0) {
        self.introContent.text = @"用户未填写";
    }else{
        self.introContent.text = model.jiazu;
    }
}

- (void)refreshWirthModel2:(CaseDetailModel *)model{
    self.intro.text = @"主要症状";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.zhengzhuang.length <= 0) {
        self.introContent.text = @"用户未填写";
    }else{
        self.introContent.text = model.zhengzhuang;
    }
}

- (void)refreshWirthModel3:(CaseDetailModel *)model{
    self.intro.text = @"既往病史";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.jiwang.length <= 0) {
        self.introContent.text = @"用户未填写";
    }else{
        self.introContent.text = model.jiwang;
    }
}

- (void)refreshWirthModel4:(CaseDetailModel *)model{
    self.intro.text = @"治疗记录";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.zhiliao.length <= 0) {
        self.introContent.text = @"用户未填写";
    }else{
        self.introContent.text = model.zhiliao;
    }
}

- (void)refreshWirthModel5:(CaseDetailModel *)model{
    self.intro.text = @"口服药记录";
    self.introContent.textColor = DefaultBlackLightTextClor;
    if (model.yaowu.length <= 0) {
        self.introContent.text = @"用户未填写";
    }else{
        self.introContent.text = model.yaowu;
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
