//
//  IndexStyleFillDataTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IndexListModel;

typedef void (^addData)();

@interface IndexStyleFillDataTableViewCell : UITableViewCell


@property (nonatomic,strong)addData addIndexData;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *numLabel;

- (void)refreshWithModel:(IndexListModel *)model;



@end
