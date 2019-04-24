//
//  IndexOriFillTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexListModel;

typedef void (^ addIndexDate)();



@interface IndexOriFillTableViewCell : UITableViewCell

@property (nonatomic,strong)addIndexDate addIndex;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

- (void)refreshWithModel:(IndexListModel *)model;



@end
