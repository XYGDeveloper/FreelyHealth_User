//
//  DiseaseHistoryTableViewCell.m
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "DiseaseHistoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <UIImageView+WebCache.h>
#import "FileModel.h"
#define MARGIN 15
#define picWidth (kScreenWidth-40 - 4 * MARGIN) / 3
@interface DiseaseHistoryTableViewCell()

@property (nonatomic,strong)UIView *imgViews;  //图片容器

@property (nonatomic,strong)UIView *topline;  //

@property (nonatomic,strong)UILabel *dis;  //

@property (nonatomic,strong)UIView *bottomline;  //

@end

@implementation DiseaseHistoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.imgViews = [[UIView alloc] init];
        [self.contentView addSubview:self.imgViews];
        [self.imgViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.width.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.height.equalTo(@45);
        }];
        
        self.topline = [[UIView alloc]init];
        
        [self.contentView addSubview:self.topline];
        
        self.bottomline = [[UIView alloc]init];
        
        [self.contentView addSubview:self.bottomline];
        
        self.dis = [[UILabel alloc]init];
        
        [self.contentView addSubview:self.dis];
        
        self.dis.text = @"以下为历史档案";
        
        self.dis.textAlignment = NSTextAlignmentCenter;
        
        self.dis.font = Font(14);
        
        self.dis.backgroundColor = DefaultBackgroundColor;
        
        [self.topline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imgViews.mas_bottom).mas_equalTo(5);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            
        }];
        
        [self.dis mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topline.mas_bottom).mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
        }];
        
        [self.bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(self.dis.mas_bottom).mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
            
        }];
        
    }
    
    return self;
    
    
}

- (CGFloat)cellHeight {
    
    return CGRectGetMaxY(self.bottomline.frame);
    
}

- (void)refreshWithModel:(FileModel *)model
{

    
    NSArray *recorder = [recordModel mj_objectArrayWithKeyValuesArray:model.records];
    
    NSMutableArray *arrType1 = [NSMutableArray array];
    
        for (recordModel *model in recorder) {
    
            if ([model.type isEqualToString:@"1"]) {
    
                [arrType1 addObject:model];
            }
        }
    
    recordModel *model1 = [arrType1 firstObject];
    
    NSArray *imgArray = [model1.imagepath componentsSeparatedByString:@","];
    
    NSLog(@"llll----lllll%@",imgArray);
    
    // 布局图片
    for (NSInteger i = 0; i <imgArray.count; i ++) {
        NSInteger row = i / 3;
        NSInteger column = i % 3;
        UIImageView *picView = [[UIImageView alloc] init];
        [self.imgViews addSubview:picView];
        [picView sd_setImageWithURL:[NSURL URLWithString:imgArray[i]] placeholderImage:[UIImage imageNamed:@""]];
    
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(picWidth, picWidth));
            make.left.equalTo(_imgViews).offset(column * (MARGIN + picWidth) + 0);
            make.top.equalTo(_imgViews).offset(row * (MARGIN + picWidth) + MARGIN);
        }];
        picView.layer.borderWidth = 0.2;
        picView.layer.borderColor = [UIColor grayColor].CGColor;
    }
    [_imgViews mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
