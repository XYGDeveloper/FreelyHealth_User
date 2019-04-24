//
//  ServiceTypeTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/9/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "ServiceTypeTableViewCell.h"

@interface ServiceTypeTableViewCell()

@property (nonatomic,strong)UIButton *bgView;

@property (nonatomic,strong)UIImageView *img;

@property (nonatomic,strong)UILabel *nameLabel;

@end

@implementation ServiceTypeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = DefaultBackgroundColor;
        UIButton *tjButton = [UIButton buttonWithType:UIButtonTypeSystem];
        tjButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:tjButton];
        [tjButton addTarget:self action:@selector(tjsender) forControlEvents:UIControlEventTouchUpInside];
        
        [tjButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo((kScreenWidth - 2)/2);
            make.height.mas_equalTo(95.5);
        }];
       
        UILabel *tjlabel = [[UILabel alloc]init];
        tjlabel.textAlignment = NSTextAlignmentLeft;
        tjlabel.textColor = AppStyleColor;
        tjlabel.text = @"体检服务";
        tjlabel.userInteractionEnabled = YES;
        tjlabel.font = Font(16);
        [tjButton addSubview:tjlabel];
        [tjlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(tjButton.mas_centerY);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *tjimg = [[UIImageView alloc]init];
        tjimg.image = [UIImage imageNamed:@"index_tijian"];
        tjimg.userInteractionEnabled = YES;
        [tjButton addSubview:tjimg];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tjsender)];
        [tjimg addGestureRecognizer:tap];
        [tjlabel addGestureRecognizer:tap];
        [tjimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [tjButton addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        [btn addTarget:self action:@selector(tjsender) forControlEvents:UIControlEventTouchUpInside];
        
        //
        UIButton *jyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        jyButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:jyButton];
        [jyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(2);
            make.left.mas_equalTo(tjButton.mas_right).mas_equalTo(2);
            make.width.mas_equalTo((kScreenWidth - 2)/2);
            make.height.mas_equalTo(tjButton.mas_height);
        }];

        [jyButton addTarget:self action:@selector(jysender) forControlEvents:UIControlEventTouchUpInside];

        UILabel *jylabel = [[UILabel alloc]init];
        jylabel.textAlignment = NSTextAlignmentLeft;
        jylabel.textColor = AppStyleColor;
        jylabel.text = @"基因检测";
        jylabel.userInteractionEnabled = YES;

        jylabel.font = Font(16);
        [jyButton addSubview:jylabel];
        [jylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(jyButton.mas_centerY);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *jyimg = [[UIImageView alloc]init];
        jyimg.image = [UIImage imageNamed:@"index_jiance"];
        jylabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jysender)];
        [jylabel addGestureRecognizer:tap0];
        [jyimg addGestureRecognizer:tap0];
        [jyButton addSubview:jyimg];
        [jyimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *jybtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [jyButton addSubview:jybtn];
        [jybtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        [jybtn addTarget:self action:@selector(jysender) forControlEvents:UIControlEventTouchUpInside];
//
        UIButton *lsButton = [UIButton buttonWithType:UIButtonTypeSystem];
        lsButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:lsButton];
        [lsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tjButton.mas_bottom).mas_equalTo(2);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo((kScreenWidth - 1)/2);
            make.height.mas_equalTo(95.5);
        }];
        [lsButton addTarget:self action:@selector(jyser) forControlEvents:UIControlEventTouchUpInside];
       
        UILabel *lslabel = [[UILabel alloc]init];
        lslabel.textAlignment = NSTextAlignmentLeft;
        lslabel.textColor = AppStyleColor;
        lslabel.text = @"绿色通道";
        lslabel.userInteractionEnabled = YES;

        lslabel.font = Font(16);
        [lsButton addSubview:lslabel];
        [lslabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(lsButton.mas_centerY);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *lsimg = [[UIImageView alloc]init];
        lsimg.image = [UIImage imageNamed:@"index_jiuyi"];
        [lsButton addSubview:lsimg];
        lsimg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jyser)];
        [lsimg addGestureRecognizer:tap1];
        [lslabel addGestureRecognizer:tap1];
        [lsimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *lsbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lsButton addSubview:lsbtn];
        [lsbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        [lsbtn addTarget:self action:@selector(jyser) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *gjButton = [UIButton buttonWithType:UIButtonTypeSystem];
        gjButton.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:gjButton];
        [gjButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(jyButton.mas_bottom).mas_equalTo(2);;
            make.left.mas_equalTo(lsButton.mas_right).mas_equalTo(2);
            make.width.mas_equalTo((kScreenWidth - 2)/2);
            make.height.mas_equalTo(tjButton.mas_height);
        }];
        [gjButton addTarget:self action:@selector(gjsender) forControlEvents:UIControlEventTouchUpInside];
      
        UILabel *gjlabel = [[UILabel alloc]init];
        gjlabel.textAlignment = NSTextAlignmentLeft;
        gjlabel.textColor = AppStyleColor;
        gjlabel.text = @"国际保险";
        gjlabel.userInteractionEnabled = YES;

        gjlabel.font = Font(16);
        [gjButton addSubview:gjlabel];
        [gjlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.mas_equalTo(gjButton.mas_centerY);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];
        
        UIImageView *gjimg = [[UIImageView alloc]init];
        gjimg.image = [UIImage imageNamed:@"index_baoxian"];
        gjimg.userInteractionEnabled = YES;
        [gjButton addSubview:gjimg];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gjsender)];
        [gjimg addGestureRecognizer:tap2];
        [gjlabel addGestureRecognizer:tap2];
        [gjimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
        UIButton *gjbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gjButton addSubview:gjbtn];

        [gjbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        [gjbtn addTarget:self action:@selector(gjsender) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//体检服务

- (void)tjsender{
    if (self.tijian) {
        
        self.tijian();
        
    }
    
}


- (void)jysender{
    if (self.jiyin) {
        
        self.jiyin();
        
    }
}

- (void)jyser{
    if (self.jiuyi) {
        
        self.jiuyi();
    }
}

- (void)gjsender{
    if (self.guoji) {
        
        self.guoji();
        
    }
}




@end
