//
//  TJItemTableviewCell.h
//  FreelyHeath
//
//  Created by L on 2018/1/18.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BigItemModel;

@interface TJItemTableviewCell : UITableViewCell

- (void)refreshWIthModel:(BigItemModel *)model;

@end
