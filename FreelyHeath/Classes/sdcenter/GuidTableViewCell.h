//
//  GuidTableViewCell.h
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^guideOneBlock)();

typedef void (^guideTwoBlock)();

typedef void (^guideThreeBlock)();


@interface GuidTableViewCell : UITableViewCell

@property (nonatomic,strong)guideOneBlock oneBlock;

@property (nonatomic,strong)guideTwoBlock twoBlock;

@property (nonatomic,strong)guideThreeBlock threeBlock;


@end
