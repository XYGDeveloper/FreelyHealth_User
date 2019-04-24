//
//  AppionmentDetailHaveAgreeTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/26.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AppionmentDetailHaveAgreeTableViewCell.h"
@interface AppionmentDetailHaveAgreeTableViewCell()
@property (nonatomic,strong)UIView *agreeContent;
@property (nonatomic,strong)UILabel *agreeLabel;
@property (nonatomic,strong)UIView *agreeLabelsep;
@property (nonatomic,strong)UILabel *agreeLabelcontent;

@end

@implementation AppionmentDetailHaveAgreeTableViewCell

- (UIView *)agreeContent{
    if (!_agreeContent) {
        _agreeContent = [[UIView alloc]init];
        _agreeContent.backgroundColor = [UIColor whiteColor];
    }
    return _agreeContent;
}
- (UILabel *)agreeLabel{
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc]init];
        _agreeLabel.textColor = DefaultBlackLightTextClor;
        _agreeLabel.font = Font(16);
        _agreeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _agreeLabel;
}
- (UIView *)agreeLabelsep{
    if (!_agreeLabelsep) {
        _agreeLabelsep = [[UIView alloc]init];
        _agreeLabelsep.backgroundColor = RGB(231, 231, 233);
    }
    return _agreeLabelsep;
}
- (UILabel *)agreeLabelcontent{
    if (!_agreeLabelcontent) {
        _agreeLabelcontent = [[UILabel alloc]init];
        _agreeLabelcontent.textColor = DefaultGrayTextClor;
        _agreeLabelcontent.font = FontNameAndSize(15);
        _agreeLabelcontent.numberOfLines = 0;
        _agreeLabelcontent.textAlignment = NSTextAlignmentLeft;
    }
    return _agreeLabelcontent;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
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
