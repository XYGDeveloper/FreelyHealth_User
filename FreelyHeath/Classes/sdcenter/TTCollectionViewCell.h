//
//  TTCollectionViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/11/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TeamListModel;

@interface TTCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *Headimage;

@property (weak, nonatomic) IBOutlet UILabel *teamName;

@property (weak, nonatomic) IBOutlet UILabel *hospitalName;

@property (weak, nonatomic) IBOutlet UILabel *jopName;

@property (weak, nonatomic) IBOutlet UILabel *leaderName;


- (void)refreshwithModel:(TeamListModel *)model;


@end
