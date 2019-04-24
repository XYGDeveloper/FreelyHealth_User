//
//  CancelAppionmentTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/4/27.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void  (^cancelAppionment)();
@interface CancelAppionmentTableViewCell : UITableViewCell
@property (nonatomic,strong)cancelAppionment cAppionment;
@end
