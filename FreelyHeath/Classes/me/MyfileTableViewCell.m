//
//  MyfileTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/8/3.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MyfileTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FileModel.h"
#define MARGIN 15
#define picWidth (kScreenWidth-40 - 4 * MARGIN) / 3
@interface MyfileTableViewCell()

@property (nonatomic,strong)UILabel *DiseaseCondition;

@property (nonatomic,strong)UILabel *aboutDiseaseHistory;

@property (nonatomic,strong)UIView *imgViews;  //图片容器

@property (nonatomic,strong)UIView *imgViews1;  //图片容器

@property (nonatomic,strong)UIView *topline;  //

@property (nonatomic,strong)UILabel *dis;  //

@property (nonatomic,strong)UIView *bottomline;  //

@property (nonatomic,strong)UIView *topline1;  //

@property (nonatomic,strong)UILabel *dis1;  //

@property (nonatomic,strong)UIView *bottomline1;  //

@property (nonatomic,strong)UILabel *serviceLabel;  //

@property (nonatomic,strong)UILabel *timellabel;  //


@property (nonatomic,strong)UILabel *question;  //

@property (nonatomic,strong)UILabel *aboutHistory;  //

@property (nonatomic,strong)UILabel *disresult;  //
@property (nonatomic,strong)UILabel *creattime;  //
@property (nonatomic,strong)UILabel *resultLabel;  //


@end


@implementation MyfileTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.serviceLabel = [[UILabel alloc]init];
        self.serviceLabel.textAlignment = NSTextAlignmentLeft;
        
        self.serviceLabel.font = Font(14);
        
        self.serviceLabel.textColor = DefaultGrayTextClor;
        self.serviceLabel.text = @"客服咨询";
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
        self.timellabel.text = @"客服咨询";
        
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
            make.top.mas_equalTo(self.serviceLabel.mas_bottom);
        }];
        
        self.aboutHistory = [[UILabel alloc]init];
        
        self.aboutHistory.text  =@"相关病历";
        
        self.aboutHistory.textAlignment = NSTextAlignmentLeft;
        
        self.aboutHistory.font = Font(14);
        
        self.aboutHistory.textColor = DefaultGrayTextClor;
        
        [self.contentView addSubview:self.aboutHistory];
        
        [self.aboutHistory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-16);
            make.top.mas_equalTo(self.question.mas_bottom);
        }];
        
        self.imgViews1 = [[UIView alloc] init];
        [self.contentView addSubview:self.imgViews1];
        [self.imgViews1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.aboutHistory.mas_bottom).offset(5);
            make.width.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@45);
        }];

        
        self.bottomline1 = [[UIView alloc]init];
        
        self.bottomline1.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bottomline1];
        
        [self.bottomline1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(self.imgViews1.mas_bottom);
        }];
        
    }
    
    return self;
    

}

- (CGFloat)cellHeight {
    
    return CGRectGetMaxY(self.bottomline1.frame);
    
}


- (void)refreshWithModel:(recordModel *)model
{

    NSArray *imgArray = [model.imagepath componentsSeparatedByString:@","];
    
    NSLog(@"llll----lllll%@",imgArray);
    
    self.timellabel.text = model.createtime;
    
    self.question.text = [NSString stringWithFormat:@"问题：%@",model.content];
        [self.question mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.serviceLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo([self onGetFontsSizeWithText:model.content].height + MARGIN * 2);
        }];
    
    // 布局图片
    for (NSInteger i = 0; i <imgArray.count; i ++) {
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        UIImageView *picView = [[UIImageView alloc] init];
        [self.imgViews1 addSubview:picView];
        [picView sd_setImageWithURL:[NSURL URLWithString:imgArray[i]] placeholderImage:[UIImage imageNamed:@""]];
        
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(picWidth, picWidth));
            make.left.equalTo(_imgViews1).offset(column * (MARGIN + picWidth) + 0);
            make.top.equalTo(_imgViews1).offset(row * (MARGIN + picWidth) + MARGIN);
        }];
     
    }
    [_imgViews1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.aboutHistory.mas_bottom);
        make.width.mas_equalTo(kScreenWidth- 40);
        make.centerX.equalTo(self.contentView);
        if (imgArray.count <= 3) {
            make.height.mas_equalTo(MARGIN * 2 + picWidth);
        } else {
            make.height.mas_equalTo(2 * (MARGIN + picWidth) + MARGIN);
        }
    }];
    
    [self layoutIfNeeded];

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
