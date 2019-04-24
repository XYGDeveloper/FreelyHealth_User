//
//  QuestionTableViewCell.h
//  FreelyHeath
//
//  Created by xyg on 2017/7/23.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QAHomeListModel;
typedef void (^tothump)();

@interface QuestionTableViewCell : UITableViewCell


@property (nonatomic,strong)tothump thump;

- (void)refreModel:(QAHomeListModel *)model;

@end
