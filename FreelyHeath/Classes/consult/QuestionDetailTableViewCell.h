//
//  QuestionDetailTableViewCell.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AuswerDetailModel;

typedef void (^tothump)();

@interface QuestionDetailTableViewCell : UITableViewCell

@property (nonatomic,strong)AuswerDetailModel *model;

@property (nonatomic,strong)tothump thump;


- (void)refreshWiothModel:(AuswerDetailModel *)model;


@end
