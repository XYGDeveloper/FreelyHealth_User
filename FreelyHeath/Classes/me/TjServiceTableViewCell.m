//
//  TjServiceTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/12/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "TjServiceTableViewCell.h"
#import "TJListModel.h"
@interface TjServiceTableViewCell()

@property (nonatomic,strong)UIImageView *bgContentView;

@property (nonatomic,strong)UILabel *middleView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)UILabel *middleContent;

@property (nonatomic,strong)UIButton *rightRrow;

@end


@implementation TjServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.backgroundColor = DefaultBackgroundColor;
        
        self.bgContentView = [[UIImageView alloc]init];
        
        self.bgContentView.userInteractionEnabled = YES;
        
        [self.bgContentView setImage:[UIImage imageNamed:@"tj_bg"]];
        
        [self.contentView addSubview:self.bgContentView];
        
        [self.bgContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(15);
            make.bottom.right.mas_equalTo(-15);
        }];
        
        self.leftView = [[UIImageView alloc]init];
        
        self.leftView.userInteractionEnabled = YES;
        
        self.leftView.layer.cornerRadius = 52/2;
        
        self.leftView.layer.masksToBounds = YES;
        
        [self.bgContentView addSubview:self.leftView];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.bgContentView.mas_centerY);
            make.width.height.mas_equalTo(52);
        }];
        
        self.middleView = [[UILabel alloc]init];
        self.middleView.userInteractionEnabled = YES;
        [self.bgContentView addSubview:self.middleView];
        
        [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgContentView.mas_centerY);
            make.left.mas_equalTo(self.leftView.mas_right).mas_equalTo(15);
            make.right.mas_equalTo(-30);
        }];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = DefaultBlackLightTextClor;
        self.titleLabel.font = Font(16);
        self.titleLabel.numberOfLines = 0;
        [self.middleView addSubview:self.titleLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
//
        self.middleContent = [[UILabel alloc]init];
        self.middleContent.textAlignment = NSTextAlignmentLeft;
        self.middleContent.textColor = DefaultGrayTextClor;
        self.middleContent.numberOfLines = 0;
        self.middleContent.font = FontNameAndSize(15);
        [self.middleView addSubview:self.middleContent];

        [self.middleContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(4);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        self.rightRrow = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.rightRrow setBackgroundImage:[UIImage imageNamed:@"rightrrow"] forState:UIControlStateNormal];
        
        [self.bgContentView addSubview:self.rightRrow];
        
        [self.rightRrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(15.5);
            make.centerY.mas_equalTo(self.bgContentView.mas_centerY);
        }];
        
    }
    return self;

}

- (void)refdreshWith:(TJListModel *)model{
    
    self.titleLabel.text = model.name;
    
//    self.middleContent.text = model.des;
    
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
