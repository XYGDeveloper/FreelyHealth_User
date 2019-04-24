//
//  IndexTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/4.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IndexTableViewCell.h"
#import "UIView+AnimationProperty.h"
@interface IndexTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *healEvaluteButton;

@property (weak, nonatomic) IBOutlet UIButton *quiteAskButton;

@property (weak, nonatomic) IBOutlet UIButton *indexManagerButton;

@property (weak, nonatomic) IBOutlet UIButton *baogaoJiedu;

@end


@implementation IndexTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.healEvaluteButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
     self.quiteAskButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
     self.indexManagerButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
     self.baogaoJiedu.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];

}

//健康评估
- (IBAction)evaluteAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.alpha = 0;
    btn.scale = 1.1f;
    [UIView animateWithDuration:0.5f animations:^{
        btn.alpha = 1.f;
        btn.scale = 1.f;
    }completion:^(BOOL finished) {
        if (self.evalute) {
            self.evalute();
        }
    }];
}

//快速提问

- (IBAction)auiteAuswer:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.alpha = 0;
    btn.scale = 1.1f;
    [UIView animateWithDuration:0.5f animations:^{
        btn.alpha = 1.f;
        btn.scale = 1.f;
    }completion:^(BOOL finished) {
        if (self.auswer) {
            self.auswer();
        }
    }];
  
}

//指标管理

- (IBAction)indexManager:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.alpha = 0;
    btn.scale = 1.1f;
    [UIView animateWithDuration:0.5f animations:^{
        btn.alpha = 1.f;
        btn.scale = 1.f;
    }completion:^(BOOL finished) {
        if (self.indexManager) {
            self.indexManager();
        }
    }];
}


- (IBAction)baogaojiedu:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    btn.alpha = 0;
    btn.scale = 1.1f;
    [UIView animateWithDuration:0.5f animations:^{
        btn.alpha = 1.f;
        btn.scale = 1.f;
    }completion:^(BOOL finished) {
        if (self.baogaoManager) {
            self.baogaoManager();
        }
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
