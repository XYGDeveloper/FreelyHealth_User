//
//  MedicalTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "MedicalTableViewCell.h"
#import "TumorTreamentModel.h"
@interface MedicalTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *topImg;

@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

@property (weak, nonatomic) IBOutlet UITextView *contentLabel;


@end


@implementation MedicalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
        
    CALayer *layer = self.bgView.layer;
    
    layer.shadowOffset = CGSizeMake(0, 0);
    
    layer.shadowOpacity = 0.6;
    
    layer.shadowColor = [UIColor lightGrayColor].CGColor;

    
    
//    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0,280, 150) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(8,8)];//圆角大小
//    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
//    maskLayer1.path = maskPath1.CGPath;
//    
//    self.topImg.layer.mask = maskLayer1;
    

    
    
}


- (void)refreshWithModel:(TumorTreamentModel *)model
{
    self.middleLabel.text  = model.name;
    [self.topImg sd_setImageWithURL:[NSURL URLWithString:model.imagepath]];
    self.contentLabel.text = model.des;    // Initialization code
    self.contentLabel.scrollEnabled = NO;
    self.contentLabel.userInteractionEnabled = YES;
    self.contentLabel.editable = NO;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
