//
//  CustomShareView.h
//  CustomShareStyle
//
//  Created by ljw on 16/6/2.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol selectPayModelDelegate <NSObject>

- (void)selectPayModel:(NSInteger)index;


@end



@interface CustomShareView : UIView

@property(nonatomic,strong)UIView           *shareListView;
@property(nonatomic,strong)UIControl        *huiseControl;

@property (nonatomic, assign) id<selectPayModelDelegate>delegate;//代理属性


- (void)showInView:(UIView *) view;
- (void)hideInView;

@end
