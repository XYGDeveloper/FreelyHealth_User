//
//  ButtonTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/8/31.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ButtonTableViewCell.h"


@interface ButtonTableViewCell()




@end


@implementation ButtonTableViewCell


- (IBAction)picConsult:(id)sender {
    
    if (self.pic) {
        
        self.pic();
        
    }
    
    
}


- (IBAction)vioConsult:(id)sender {
    
    if (self.vio) {
        
        self.vio();
    }
    
}


- (IBAction)vedConsult:(id)sender {
    
    if (self.ved) {
        
        self.ved();
    }
    
    
}

- (IBAction)yueConsult:(id)sender {
    
    if (self.yu) {
        
        self.yu();
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
