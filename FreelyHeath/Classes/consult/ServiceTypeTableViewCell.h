//
//  ServiceTypeTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^toTj)();
typedef void(^toJy)();
typedef void(^toJyi)();
typedef void(^toNs)();


@interface ServiceTypeTableViewCell : UITableViewCell

@property (nonatomic,strong)toTj tijian;

@property (nonatomic,strong)toJy jiyin;

@property (nonatomic,strong)toJyi jiuyi;

@property (nonatomic,strong)toNs guoji;


@end
