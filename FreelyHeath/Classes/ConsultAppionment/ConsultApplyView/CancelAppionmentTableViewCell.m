//
//  CancelAppionmentTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CancelAppionmentTableViewCell.h"
@interface CancelAppionmentTableViewCell()
@property (nonatomic,strong)UIButton *cancelButton;

@end

@implementation CancelAppionmentTableViewCell
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.layer.borderWidth = 1;
        _cancelButton.layer.borderColor = RGB(236, 236, 236).CGColor;
        [_cancelButton setTitle:@"取消会诊" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:RGB(206, 206, 206) forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(handelCancelAppionmention) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (void)layOutSubview{
   
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cancelButton];
        [self layOutSubview];
        
    }
    return self;
}

- (void)handelCancelAppionmention{
    if (self.cAppionment) {
        self.cAppionment();
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
