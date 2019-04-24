//
//  TableViewCell.m
//  Timeline
//
//  Created by YaSha_Tom on 2017/8/18.
//  Copyright © 2017年 YaSha-Tom. All rights reserved.
//

#import "TableViewCell.h"
#import <Masonry.h>
#import "OrderDetailModel.h"

@interface TableViewCell()


@end



@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.roundView = [[UIImageView alloc]init];
        self.roundView.backgroundColor = [UIColor clearColor];
        self.roundView.layer.masksToBounds = YES;
        self.roundView.layer.cornerRadius = 12;
        [self.contentView addSubview:self.roundView];
        [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(8);
            make.left.mas_equalTo(self.mas_left).offset(15);
            make.size.mas_equalTo(CGSizeMake(24, 24));
        }];
    
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.font = [UIFont systemFontOfSize:10.0f];
        self.numLabel.backgroundColor = [UIColor clearColor];
        [self.roundView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        
        self.contentlabel = [[UILabel alloc]init];
        self.contentlabel.textAlignment = NSTextAlignmentLeft;
        self.contentlabel.numberOfLines = 0;
        self.contentlabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.contentlabel];
        [self.contentlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(8);
            make.left.mas_equalTo(self.roundView.mas_right).offset(20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-5);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-5);
            make.width.mas_equalTo(235);
            
        }];

        self.contentlabel.textColor = DefaultGrayTextClor;
        _onLine = [[UILabel alloc]init];
        _onLine.backgroundColor = AppStyleColor;
        [self.contentView addSubview:_onLine];
        [_onLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(27);
            make.size.mas_equalTo(CGSizeMake(1, 15));
        }];

        _downLine = [[UILabel alloc]init];
        _downLine.backgroundColor = AppStyleColor;
        [self.contentView addSubview:_downLine];
        [_downLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.roundView.mas_bottom);
            make.left.mas_equalTo(self.mas_left).offset(27);
            make.bottom.mas_equalTo(self.mas_bottom);
            make.width.mas_equalTo(@1);
        }];
        
    }
    return self;
}

- (void)refreshWithModel:(itemModel *)model
{
    
    self.contentlabel.text = model.name;   //事项
 
    self.numLabel.text = model.no;         //编号
    
    if ([model.finish isEqualToString:@"N"]) {
        
        [self.roundView setImage:[UIImage imageNamed:@"nofinish"]];
        
    }else{
        
        self.roundView.image = [UIImage imageNamed:@"finish"];
        
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
