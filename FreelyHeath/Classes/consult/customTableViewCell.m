//
//  customTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/19.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "customTableViewCell.h"
#import "ZYJHeadLineModel.h"
#import "ZYJHeadLineView.h"
#import "UIView+WHC_AutoLayout.h"
#import "UITableViewCell+WHC_AutoHeightForCell.h"
#import "ConsultIndexModel.h"
#import "QAHomeApi.h"
#import "QAHomeListModel.h"
#import "WAHomePageRequest.h"
@interface customTableViewCell ()<ApiRequestDelegate>

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UILabel *evaluteResult;

@property (nonatomic,strong)UILabel *sepline;

@property (nonatomic,strong)UIView *middleView;

@property (nonatomic,strong)UILabel *advicelabel;

@property (nonatomic,strong)UITextView *adviceContent;

@property (nonatomic,strong)UIButton *scanMore;

@property (nonatomic,strong)UIView *bottomLine;

@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,strong)UIImageView *leftImg;

@property (nonatomic,strong)UILabel *hotComment;

@property (nonatomic,strong)UILabel *hotDiscuss;

@property(nonatomic,strong)NSMutableArray*dataArr;

@property (nonatomic,strong) ZYJHeadLineView *TopLineView;

@property (nonatomic,strong)QAHomeApi *homeApi;

@property (nonatomic,strong)NSMutableArray *BannerArray;


@end

@implementation customTableViewCell


- (NSMutableArray *)BannerArray
{

    if (!_BannerArray) {
        
        _BannerArray = [NSMutableArray array];
    }
    
    return _BannerArray;

}


- (QAHomeApi *)homeApi
{
    
    if (!_homeApi) {
        
        _homeApi = [[QAHomeApi alloc]init];
        
        _homeApi.delegate = self;
        
        
    }
    
    return _homeApi;
    
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{



}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{

    if (api == _homeApi) {
        
        NSLog(@"%@",responsObject);
        
        NSArray *arr = [QAHomeListModel mj_objectArrayWithKeyValuesArray:responsObject[@"questions"]];
        
        for (QAHomeListModel *model in arr) {
            
            [self.BannerArray addObject:model.title];
            
        }
        
        self.TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftImg.frame)+10,20, kScreenWidth - 60, 50)];
        
        [self.bottomView addSubview:self.TopLineView];
        
        NSMutableArray *arr1 = [NSMutableArray array];
        
        for (NSInteger i= 0; i <= self.BannerArray.count; i++) {
            
            NSString *str = @"热议";
            
            [arr1 addObject:str];
            
        }
        
        NSArray *arr2 = self.BannerArray;
        self.dataArr = [NSMutableArray array];
        for (int i=0; i<arr2.count; i++) {
            ZYJHeadLineModel *model = [[ZYJHeadLineModel alloc]init];
            model.type = arr1[i];
            model.title = arr2[i];
            [_dataArr addObject:model];
            
            NSLog(@"%@",_dataArr);
            
        }
        [_TopLineView setVerticalShowDataArr:_dataArr];
        
        __weak __typeof(self)weakSelf = self;
        self.TopLineView.clickBlock = ^(NSInteger index){
            ZYJHeadLineModel *model = weakSelf.dataArr[index];
            NSLog(@"%@,%@",model.type,model.title);
            
            if (weakSelf.ques) {
                
                weakSelf.ques(index);
                
            }
        };

        
    }


}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //
        
        QAHomeRequestHeader *head = [[QAHomeRequestHeader alloc]init];
        
        head.target = @"noTokenForumControl";
        
        head.method = @"homePage";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        QAHomeRequestBody *body = [[QAHomeRequestBody alloc]init];
        
        WAHomePageRequest *request = [[WAHomePageRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.homeApi getHomeListWithRequest:request.mj_keyValues.mutableCopy];
        
        self.topView =[UIView new];
        [self.contentView addSubview:self.topView];
        
        self.evaluteResult = [UILabel new];
        self.evaluteResult.textAlignment = NSTextAlignmentCenter;
        self.evaluteResult.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.0f];
        [self.topView addSubview:self.evaluteResult];
        self.sepline = [[UILabel alloc]init];
        [self.topView addSubview:self.sepline];
        self.sepline.backgroundColor = DividerGrayColor;
        
        //
        self.middleView = [UIView new];
        
        self.middleView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.middleView];
        
        self.advicelabel = [UILabel new];
        
        self.advicelabel.textAlignment = NSTextAlignmentCenter;
        
        self.advicelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
        
        self.advicelabel.text = @"智能建议";
        
        [self.middleView addSubview:self.advicelabel];
        
        self.adviceContent = [UITextView new];
        self.adviceContent.editable = NO;
        self.adviceContent.bounces = NO;
        self.adviceContent.scrollEnabled = NO;
        
        self.adviceContent.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0f];
        
        self.adviceContent.textColor = DefaultGrayTextClor;
        
        [self.middleView addSubview:self.adviceContent];
        
        self.scanMore = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.scanMore.backgroundColor = [UIColor clearColor];
        
        [self.middleView addSubview:self.scanMore];
        
        [self.scanMore setTitle:@"查看更多 >>" forState:UIControlStateNormal];
        
        [self.scanMore setTitleColor:AppStyleColor forState:UIControlStateNormal];
        
        [self.scanMore addTarget:self action:@selector(scanDetailAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.scanMore.titleLabel.font = Font(17.0f);
        
        self.bottomLine = [[UILabel alloc]init];
        
        [self.middleView addSubview:self.bottomLine];
        
        self.bottomLine.backgroundColor = DividerGrayColor;
        
        
        [self.middleView addSubview:self.bottomLine];
        
        self.bottomView = [UIView new];
        
        self.bottomView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.bottomView];
        
        self.leftImg = [UIImageView new];
        
        [self.bottomView addSubview:self.leftImg];
//
        self.leftImg.image = [UIImage imageNamed:@"consult_askandauswer"];
        
       }
    
    return self;
    
}


- (void)refreshWithModel:(ConsultIndexModel *)model
{

    self.evaluteResult.text =[NSString stringWithFormat:@"评估结果：%@",model.name];

    self.adviceContent.text = model.suggest;
    
}



- (void)scanDetailAction{

    if (self.result) {
        
        self.result();
    }
    


}


- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        
        make.height.mas_equalTo(48);
        
    }];
    
    [self.evaluteResult mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.topView.mas_centerY);
        make.centerX.mas_equalTo(self.topView.mas_centerX);
        make.height.mas_equalTo(32);
    }];
    
    [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(1);
    }];
    
    
    //
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(223.0);
        
        make.top.mas_equalTo(self.topView.mas_bottom).mas_equalTo(0);
    }];
    
    [self.advicelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
    
    [self.adviceContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(23.5);
        
        make.right.mas_equalTo(-23.5);

        make.height.mas_equalTo(100);
        
        make.top.mas_equalTo(self.advicelabel.mas_bottom).mas_equalTo(0);
        
    }];
    
    [self.scanMore mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.adviceContent.mas_bottom).mas_equalTo(0);
        make.height.mas_equalTo(30);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scanMore.mas_bottom).mas_equalTo(5);
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        
        make.top.mas_equalTo(self.middleView.mas_bottom).mas_equalTo(0);
        
        make.height.mas_equalTo(65);
        
    }];
    
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.bottomView.mas_centerY).mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(55);
    }];
    
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
