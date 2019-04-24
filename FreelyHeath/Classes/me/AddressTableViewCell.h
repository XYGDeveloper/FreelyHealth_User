//
//  AddressTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/2/5.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^tolocation)();
@interface AddressTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel *typeName;

@property (nonatomic, strong, readonly) UITextField *textField;

@property (nonatomic, assign) NSInteger maxEditCount;

@property (nonatomic, copy) void(^contentChangedBlock)();

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) tolocation location;

//设置是否可以编辑，默认为YES
- (void)setEditAble:(BOOL)editAble;

- (void)setTypeName:(NSString *)typeName
        placeholder:(NSString *)placeholder;
@end
