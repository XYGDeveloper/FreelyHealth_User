//
//  ConsultTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/20.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TeamModel;

@protocol delegateColl

-(void)ClickCooRow :(NSInteger)CellRow teamModel:(TeamModel *)model;

@end

@interface ConsultTableViewCell : UITableViewCell

@property (nonatomic,strong)UICollectionView *collect;

@property(weak,nonatomic)id <delegateColl> delegateColl;

@end
