//
//  TJDetailCollectionViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/1/31.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMGModel;
@interface TJDetailCollectionViewCell : UICollectionViewCell

- (void)refreshWithModel:(IMGModel *)model;

@end
