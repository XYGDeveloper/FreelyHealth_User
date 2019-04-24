//
//  GuidTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "GuidTableViewCell.h"


@interface GuidTableViewCell ()


@property (weak, nonatomic) IBOutlet UIView *guidone;

@property (weak, nonatomic) IBOutlet UIView *guidTwo;

@property (weak, nonatomic) IBOutlet UIView *guidThree;


@end


@implementation GuidTableViewCell


- (IBAction)guidOneAction:(id)sender {
    
    if (self.oneBlock) {
        
        self.oneBlock();
        
    }
    
}


- (IBAction)guidTwoAction:(id)sender {
    
    if (self.twoBlock) {
        
        self.twoBlock();
        
    }
    
}


- (IBAction)guideThreeAction:(id)sender {
    
    if (self.threeBlock) {
        
        self.threeBlock();
        
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.guidone.layer.cornerRadius = 4;
    
    self.guidone.layer.borderColor  =AppStyleColor.CGColor;
    
    self.guidone.layer.borderWidth  =1;
    
    self.guidTwo.layer.cornerRadius = 4;
    
    self.guidTwo.layer.borderColor  =AppStyleColor.CGColor;
    
    self.guidTwo.layer.borderWidth  =1;
    
    self.guidThree.layer.cornerRadius = 4;
    
    self.guidThree.layer.borderColor  =AppStyleColor.CGColor;
    
    self.guidThree.layer.borderWidth  =1;
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
