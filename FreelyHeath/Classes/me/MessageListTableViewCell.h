//
//  MessageListTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/4/25.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyMessageModel;
@interface MessageListTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headImage;
@property (nonatomic,strong)UILabel *messageNameLabel;
@property (nonatomic,strong)UILabel *messageContentLabel;
@property (nonatomic,strong)UILabel *badgeLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *bottomButton;

- (void)refreshWithModel:(MyMessageModel *)model counts:(NSString *)counts;
- (void)refreshWithMessageCounts:(NSString *)counts;

@end
