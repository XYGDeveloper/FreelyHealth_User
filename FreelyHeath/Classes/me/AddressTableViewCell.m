//
//  AddressTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2018/2/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "AddressTableViewCell.h"
@interface AddressTableViewCell()<UITextFieldDelegate>

@property (nonatomic, strong, readwrite) UILabel *typeName;

@property (nonatomic, strong, readwrite) UITextField *textField;

@property (nonatomic, strong, readwrite) UIButton *button;

@end

@implementation AddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.maxEditCount = INT16_MAX;
        [self.contentView addSubview:self.typeName];
        [self.contentView addSubview:self.textField];
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.button];
        [self.button addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];
        [self.button setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)address:(UIButton *)send{
    if (self.location) {
        self.location();
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.typeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(@20);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.typeName.mas_centerY);
        make.left.equalTo(self.typeName.mas_right).offset(10);
        make.right.equalTo(@-60);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.textField.mas_right).offset(0);
        make.right.equalTo(@-5);
    }];
  
}


#pragma mark - Public Methods

- (void)setTypeName:(NSString *)typeName placeholder:(NSString *)placeholder
{
    
    self.typeName.text = typeName;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [str addAttribute:NSForegroundColorAttributeName value:HexColor(0x909090) range:NSMakeRange(0, placeholder.length)];
    self.textField.attributedPlaceholder = str;
    
}

- (NSString *)text {
    return [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)setText:(NSString *)text {
    self.textField.text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.contentChangedBlock) {
        self.contentChangedBlock();
    }
}

- (void)setEditAble:(BOOL)editAble {
    self.textField.enabled = editAble;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= self.maxEditCount && string.length > range.length) {
        return NO;
    }
    return YES;
}
#pragma mark - Properties
- (UILabel *)typeName {
    if (!_typeName) {
        _typeName = [[UILabel alloc] init];
        _typeName.textAlignment = NSTextAlignmentLeft;
        _typeName.font = Font(16);
        _typeName.textColor = DefaultGrayTextClor;
    }
    return _typeName;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.font = FontNameAndSize(16);
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.textColor = DefaultBlackLightTextClor;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    }
    return _textField;
}

@end
