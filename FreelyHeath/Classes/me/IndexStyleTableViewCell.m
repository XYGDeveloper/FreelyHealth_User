//
//  IndexStyleTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IndexStyleTableViewCell.h"
#import "HIstoryIndexModel.h"
@implementation IndexStyleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)refreshWithModel:(HIstoryIndexModel *)model
{

    self.name.text  = model.createtime;
    
    self.numLabel.text = [NSString stringWithFormat:@"%@ %@",model.num,model.unit];
    
    
}


@end
