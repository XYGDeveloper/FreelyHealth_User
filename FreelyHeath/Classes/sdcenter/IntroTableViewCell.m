//
//  IntroTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/21.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IntroTableViewCell.h"
#import "DoctorModel.h"
@interface IntroTableViewCell ()

@property (nonatomic,strong)UILabel *intro;

@property (nonatomic,strong)UILabel *sep;

@property (nonatomic,strong)UILabel *introContent;

@end


@implementation IntroTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.introContent = [[UILabel alloc]init];
        
        self.introContent.numberOfLines = 0;
        
        self.introContent.textColor = DefaultGrayLightTextClor;
        
        self.introContent.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        
        [self.contentView addSubview:self.introContent];
        
        [self layOut];
        
    }
    
    return self;
    
}

- (void)layOut{
    
    [self.introContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        
        make.left.mas_equalTo(16);
        
        make.right.mas_equalTo(-16);
        
        make.bottom.mas_equalTo(-15);
        
    }];
    
}


- (void)refreWithdocModel:(DoctorModel *)model{

    if (model.introduction.length <=0) {
        self.introContent.text = @"暂无个人介绍，请更新您的个人详细介绍";
    }else{
        NSString *_test  = model.introduction;
        NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
        paraStyle01.alignment = NSTextAlignmentLeft;
        paraStyle01.headIndent = 0.0f;
        CGFloat emptylen = self.introContent.font.pointSize * 2;
        paraStyle01.firstLineHeadIndent = emptylen;
        paraStyle01.tailIndent = 0.0f;
        paraStyle01.lineSpacing = 2.0f;
        NSAttributedString *attrText = [[NSAttributedString alloc] initWithString:_test attributes:@{NSParagraphStyleAttributeName:paraStyle01}];
        self.introContent.attributedText = attrText;
    }
}

- (void)refreWithdocModelTime:(DoctorModel *)model{
    
    if (model.menzhen.length <=0) {
        self.introContent.text = @"暂无门诊时间";
    }else{
        self.introContent.text = model.menzhen;
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
