//
//  QAListTableViewCell.m
//  FreelyHeath
//
//  Created by L on 2017/7/27.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "QAListTableViewCell.h"
#import "ZYJHeadLineView.h"
@interface QAListTableViewCell()

@property (nonatomic,strong)ZYJHeadLineView *TopLineView;

@property (nonatomic,strong)NSMutableArray *dataArr;


@end


@implementation QAListTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.TopLineView = [[ZYJHeadLineView alloc]initWithFrame:CGRectMake(20,10, kScreenWidth - 60, 50)];
        
        [self.contentView addSubview:self.TopLineView];
        
        NSArray *arr1 = @[@"热评",@"热议"];
        NSArray *arr2 = @[@"早起糖尿病如何处理，可不可以.....",@"胃癌早期该吃什么，不该吃什么"];
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
    
    return self;
    
}



@end
