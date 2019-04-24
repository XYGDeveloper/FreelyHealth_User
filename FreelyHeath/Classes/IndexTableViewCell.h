//
//  IndexTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/4.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^toEvalute)();
typedef void (^toAuswer)();
typedef void (^toIndexManager)();
typedef void (^tobaogaoManager)();

@interface IndexTableViewCell : UITableViewCell

@property (nonatomic,strong)toEvalute evalute;

@property (nonatomic,strong)toAuswer auswer;

@property (nonatomic,strong)toIndexManager indexManager;

@property (nonatomic,strong)tobaogaoManager baogaoManager;

@end
