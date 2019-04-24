//
//  GuideExTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GuideExTableViewCell.h"


@interface GuideExTableViewCell()

@end

@implementation GuideExTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.guideButton1.layer.cornerRadius = 4;
    
    self.guideButton1.layer.borderWidth = 1.0f;
    
    self.guideButton1.layer.borderColor = AppStyleColor.CGColor;
    
    self.guide2Button.layer.cornerRadius = 4;
    
    self.guide2Button.layer.borderWidth = 1.0f;
    
    self.guide2Button.layer.borderColor = AppStyleColor.CGColor;
    
    
    self.guide3Button.layer.cornerRadius = 4;
    
    self.guide3Button.layer.borderWidth = 1.0f;
    
    self.guide3Button.layer.borderColor = AppStyleColor.CGColor;
    
    self.guid4Button.layer.cornerRadius = 4;
    
    self.guid4Button.layer.borderWidth = 1.0f;
    
    self.guid4Button.layer.borderColor = AppStyleColor.CGColor;
}


- (IBAction)guide1Action:(id)sender {
    
    if (self.guide1) {
        
        self.guide1();
        
    }
    
}

- (IBAction)guide2Action:(id)sender {
    
    if (self.guide2) {
        
        self.guide2();
    }
    
}

- (IBAction)guide3Action:(id)sender {
    
    if (self.guide3) {
        
        self.guide3();
    }
    
}


- (IBAction)guide4Action:(id)sender {
    
    if (self.guide4) {
        self.guide4();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
