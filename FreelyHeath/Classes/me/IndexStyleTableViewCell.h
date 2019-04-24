//
//  IndexStyleTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HIstoryIndexModel;

@interface IndexStyleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;


- (void)refreshWithModel:(HIstoryIndexModel *)model;


@end
