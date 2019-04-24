//
//  SectionCollectionReusableView.h
//  FreelyHeath
//
//  Created by L on 2018/1/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^toJump)(NSInteger tagindex);

@interface SectionCollectionReusableView : UICollectionReusableView
@property (nonatomic,strong)UILabel *textLabel;
@property (nonatomic,strong)toJump jump;

@end