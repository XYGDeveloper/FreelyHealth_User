//
//  TableViewCell.h
//  Timeline
//
//  Created by YaSha_Tom on 2017/8/18.
//  Copyright © 2017年 YaSha-Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

@class itemModel;

@interface TableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *numLabel;

@property (nonatomic,strong) UIImageView *roundView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *contentlabel;

@property (nonatomic,strong) UILabel *onLine;

@property (nonatomic,strong)  UILabel *downLine;

- (void)refreshWithModel:(itemModel *)model;



@end
