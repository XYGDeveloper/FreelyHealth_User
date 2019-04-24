//
//  TJMenuCollectionViewCell.h
//  FreelyHeath
//
//  Created by L on 2018/1/29.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceModel;
@class serverModel;
@interface TJMenuCollectionViewCell : UICollectionViewCell

- (void)refreshWithModel:(ServiceModel *)model;
- (void)refreshWithserverModel:(serverModel *)model;

@end
