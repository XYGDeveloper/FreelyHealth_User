//
//  PhysicalExerTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/7.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "PhysicalExerTableViewCell.h"

#import "TumorTreamentModel.h"
@interface PhysicalExerTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *pacakage1;


@property (weak, nonatomic) IBOutlet UIButton *package2;


@property (weak, nonatomic) IBOutlet UIButton *package3;


@property (weak, nonatomic) IBOutlet UIButton *package4;


@end




@implementation PhysicalExerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.pacakage1.layer.cornerRadius = 4;
    
    self.pacakage1.layer.borderWidth = 1.0f;
    
    self.pacakage1.layer.borderColor = AppStyleColor.CGColor;
    
    self.package2.layer.cornerRadius = 4;
    
    self.package2.layer.borderWidth = 1.0f;
    
    self.package2.layer.borderColor = AppStyleColor.CGColor;
    
    self.package3.layer.cornerRadius = 4;
    
    self.package3.layer.borderWidth = 1.0f;
    
    self.package3.layer.borderColor = AppStyleColor.CGColor;
    
    
    self.package4.layer.cornerRadius = 4;
    
    self.package4.layer.borderWidth = 1.0f;
    
    self.package4.layer.borderColor = AppStyleColor.CGColor;
    
    
}


//套餐1

- (IBAction)packageAction:(id)sender {
    
    if (self.p1) {
        
        self.p1();
        
    }
    
}

//套餐2

- (IBAction)package2Action:(id)sender {
    
    if (self.p2) {
        
        self.p2();
    }
    
}

//套餐3

- (IBAction)package3Action:(id)sender {
    
    if (self.p3) {
        
        self.p3();
    }
    
}

//套餐4


- (IBAction)package4Action:(id)sender {
    
    if (self.p4) {
        
        self.p4();
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
