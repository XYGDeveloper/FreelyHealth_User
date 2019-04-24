//
//  IndexOriFillTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "IndexOriFillTableViewCell.h"
#import "IndexListModel.h"
@implementation IndexOriFillTableViewCell


- (IBAction)addData:(id)sender {
    
    if (self.addIndex) {
        
        self.addIndex();
    }
    
    
}


- (void)refreshWithModel:(IndexListModel *)model
{
    self.titleLabel.text = model.name;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
    self.contentLabel.text =[NSString stringWithFormat:@"%@%@",model.finallynum,model.unit];
    self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];

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
