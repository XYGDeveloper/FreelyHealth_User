//
//  MiddleTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MiddleTableViewCell.h"
#import "TumorZoneListModel.h"
#import "NSMutableArray+safe.h"
#import "SGAdvertScrollView.h"
@interface MiddleTableViewCell() <SGAdvertScrollViewDelegate>
@property (nonatomic, strong) SGAdvertScrollView *advertScrollViewBottom;

////左边的图片
@property (nonatomic,strong)UIImageView *leftImg;
//@property(nonatomic,strong)NSMutableArray*dataArr;
////滚动字幕
//滚动字幕内容接口
@end


@implementation MiddleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.leftImg = [[UIImageView alloc]init];
        self.leftImg.contentMode = UIViewContentModeScaleAspectFit;
        self.leftImg.image = [UIImage imageNamed:@"index_scient"];
        [self.contentView addSubview:self.leftImg];
        [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth/4);
        }];
        self.advertScrollViewBottom = [[SGAdvertScrollView alloc] initWithFrame:CGRectMake(kScreenWidth/4+20+10,10,kScreenWidth- (kScreenWidth/4+20+30+0), 50)];
        self.advertScrollViewBottom.delegate = self;
        self.advertScrollViewBottom.titleFont  =FontNameAndSize(14);
        self.advertScrollViewBottom.topTitleColor = DefaultGrayTextClor;
        self.advertScrollViewBottom.bottomTitleColor = DefaultGrayTextClor;
        [self.contentView addSubview:self.advertScrollViewBottom];
    }
    return self;
}

- (void)refreshcellWithModel:(NSArray *)informations{
   
    NSMutableArray *signArr = [NSMutableArray array];
    infomationModel *model = [informations safeObjectAtIndex:0];
    infomationModel *model1 = [informations safeObjectAtIndex:1];
    [signArr safeAddObject:model.title];
    [signArr safeAddObject:model1.title];
    NSMutableArray *signArr0 = [NSMutableArray array];
    infomationModel *model0 = [informations safeObjectAtIndex:2];
    infomationModel *model01 = [informations safeObjectAtIndex:3];
    [signArr0 safeAddObject:model0.title];
    [signArr0 safeAddObject:model01.title];
    _advertScrollViewBottom.advertScrollViewStyle = SGAdvertScrollViewStyleMore;
    _advertScrollViewBottom.topSignImages = @[@"hot_c",@"hot_c"];
    _advertScrollViewBottom.topTitles = signArr;
    _advertScrollViewBottom.bottomSignImages = @[@"hot_d",@"hot_d"];
    _advertScrollViewBottom.bottomTitles = signArr0;
  
}

- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index {
    if (self.ques) {
        self.ques();
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
