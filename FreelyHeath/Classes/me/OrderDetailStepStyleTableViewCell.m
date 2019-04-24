//
//  OrderDetailStepStyleTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/26.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "OrderDetailStepStyleTableViewCell.h"
#import "OrderDetailModel.h"
@interface OrderDetailStepStyleTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *step;

@property (weak, nonatomic) IBOutlet UILabel *stepText;

@property (weak, nonatomic) IBOutlet UIImageView *line;

@end


@implementation OrderDetailStepStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.step.layer.cornerRadius = 14;
    
    self.step.layer.masksToBounds  = YES;
    
}

- (void)refreshWithModel:(itemModel *)model
{

    self.stepText.text = model.name;

    if ([_stepNum.text isEqualToString:@"1"]) {
        
        self.line.hidden = YES;
    }else{
    
        self.line.hidden = NO;

    }
    
    
    
    if ([model.finish isEqualToString:@"N"]) {
        
        [self.step setImage:[UIImage imageNamed:@"nofinish"]];
    
//        self.step.image = [UIImage imageNamed:@"nofinish"];
        
        
    }else{
    
        self.step.image = [UIImage imageNamed:@"finish"];

        self.stepNum.text = @"";
        
        self.line.backgroundColor = DividerGrayColor;
        
        self.stepText.textColor = DefaultGrayTextClor;
        
        
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
