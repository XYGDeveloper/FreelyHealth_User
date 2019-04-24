//
//  GenTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/8.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GenTableViewCell.h"

@interface GenTableViewCell()


@property (weak, nonatomic) IBOutlet UIButton *general1;

@property (weak, nonatomic) IBOutlet UIButton *general2;


@property (weak, nonatomic) IBOutlet UIButton *general3;

@property (weak, nonatomic) IBOutlet UIButton *general4;


@property (weak, nonatomic) IBOutlet UIButton *general5;

@property (weak, nonatomic) IBOutlet UIButton *general6;

@end

@implementation GenTableViewCell



- (IBAction)general1Action:(id)sender {
    
    if (self.g1) {
        
        self.g1();
        
    }
    
}


- (IBAction)general2Action:(id)sender {
    
    if (self.g2) {
        
        self.g2();
        
    }
    
}

- (IBAction)general3Action:(id)sender {
    
    if (self.g3) {
        
        self.g3();
        
    }
    
}


- (IBAction)general4Action:(id)sender {
    
    if (self.g4) {
        
        self.g4();
        
    }
    
}

- (IBAction)general5Action:(id)sender {
    
    if (self.g5) {
        
        self.g5();
        
    }
}


- (IBAction)general6Action:(id)sender {
    
    if (self.g6) {
        
        self.g6();
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.general1.layer.cornerRadius = 4;
    
    self.general1.layer.borderWidth = 1.0f;
    
    self.general1.layer.borderColor = AppStyleColor.CGColor;
    
    self.general2.layer.cornerRadius = 4;
    
    self.general2.layer.borderWidth = 1.0f;
    
    self.general2.layer.borderColor = AppStyleColor.CGColor;
    
    self.general3.layer.cornerRadius = 4;
    
    self.general3.layer.borderWidth = 1.0f;
    
    self.general3.layer.borderColor = AppStyleColor.CGColor;
    
    self.general4.layer.cornerRadius = 4;
    
    self.general4.layer.borderWidth = 1.0f;
    
    self.general4.layer.borderColor = AppStyleColor.CGColor;
    
    self.general5.layer.cornerRadius = 4;
    
    self.general5.layer.borderWidth = 1.0f;
    
    self.general5.layer.borderColor = AppStyleColor.CGColor;
    
    self.general6.layer.cornerRadius = 4;
    
    self.general6.layer.borderWidth = 1.0f;
    
    self.general6.layer.borderColor = AppStyleColor.CGColor;
    
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
