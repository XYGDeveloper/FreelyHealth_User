//
//  RemarksTableViewCell.h
//  FlowerReceiveDemo
//
//  Created by Eyes on 16/2/19.
//  Copyright © 2016年 DuanGuoLi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppionmentDetailModel;
@protocol RemarksCellDelegate <NSObject>

- (void)remarksCellShowContrntWithDic:(NSDictionary *)dic andCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface RemarksTableViewCell : UITableViewCell

@property (nonatomic, weak) id<RemarksCellDelegate> delegate;
@property (nonatomic ,strong) UILabel *infolable;
@property (nonatomic ,strong) UILabel *textsLabel;
@property (nonatomic ,strong) UIButton *moreBtn;   // 展开收起按钮

- (void)setCellContent:(NSString *)contentStr andIsShow:(BOOL)isShow andCellIndexPath:(NSIndexPath *)indexPath;

@end
