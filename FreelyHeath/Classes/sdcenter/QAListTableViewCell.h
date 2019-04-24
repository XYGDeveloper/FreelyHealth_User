//
//  QAListTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^questionBlock)(NSInteger index);

@interface QAListTableViewCell : UITableViewCell

@property (nonatomic,strong)questionBlock ques;


@end
