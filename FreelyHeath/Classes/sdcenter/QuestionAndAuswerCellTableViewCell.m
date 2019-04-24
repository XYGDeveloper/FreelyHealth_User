//
//  QuestionAndAuswerCellTableViewCell.m
//  FreelyHeath
//
//  Created by xyg on 2017/7/30.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QuestionAndAuswerCellTableViewCell.h"
#import "ZYJHeadLineView.h"
#import "QAHomeApi.h"
#import "QAHomeListModel.h"
#import "WAHomePageRequest.h"
@interface QuestionAndAuswerCellTableViewCell ()<ApiRequestDelegate>

@property(nonatomic,strong)NSMutableArray*dataArr;

@property (nonatomic,strong) ZYJHeadLineView *TopLineView;

@property (nonatomic,strong)QAHomeApi *homeApi;

@property (nonatomic,strong)NSMutableArray *BannerArray;


@end


@implementation QuestionAndAuswerCellTableViewCell


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
        
        self.TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(16,10, kScreenWidth - 32, 50)];
        
        [self.contentView addSubview:self.TopLineView];
        
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

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    
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

@end
