//
//  CaseNoteViewController.m
//  FreelyHeath
//
//  Created by L on 2018/3/6.
//  Copyright © 2018年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "CaseNoteViewController.h"
#import "ISTableViewCell.h"
#import "SZTextView.h"
#import "CaseDetailApi.h"
#import <TPKeyboardAvoidingTableView.h>
#import "UpDateDetailTableViewCell.h"
#import "ACMediaFrame.h"
#import "CaseListRequest.h"
#import "EditBCApi.h"
#import "Utils.h"
#import "CaseDetailModel.h"
#import "CaseListViewController.h"
#import "NSMutableArray+safe.h"
#import "CaseListViewController.h"
@interface CaseNoteViewController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,ApiRequestDelegate>
@property (nonatomic,strong)UIButton *saveButton;
@property (nonatomic,strong)ISTableViewCell *yongyao;
@property (nonatomic,strong)ISTableViewCell *koufu;
@property (nonatomic,strong)UpDateDetailTableViewCell *yongyaojilu;
@property (nonatomic,strong)UpDateDetailTableViewCell *koufujilu;
@property (nonatomic,strong)UITableViewCell *photo1;
@property (nonatomic,strong)UITableViewCell *photo2;
@property (nonatomic,strong)UIView *chufangview;
@property (nonatomic,strong)UILabel *chufangLabel;
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)NSArray *list1;
@property (nonatomic,assign)CGFloat height1;
@property (nonatomic,assign)CGFloat height2;
@property (nonatomic,strong)EditBCApi *api;
@property (nonatomic,strong)CaseDetailApi *detailapi;
@property (nonatomic,strong)CaseDetailModel *model;
@property (nonatomic,strong)NSMutableArray *ywimages;
@property (nonatomic,strong)NSMutableArray *blimages;
@property (nonatomic,strong)NSMutableArray *ywimagesURLs;
@property (nonatomic,strong)NSMutableArray *blimagesURLs;
//
@property (nonatomic,strong)ACSelectMediaView *mediaView0;
@property (nonatomic,strong)ACSelectMediaView *mediaView1;
//修改病历
@property (nonatomic,strong)NSMutableArray *mywimages;
@property (nonatomic,strong)NSMutableArray *mblimages;
@property (nonatomic,strong)NSMutableArray *mywimagesURLs;
@property (nonatomic,strong)NSMutableArray *mblimagesURLs;
@property (nonatomic,strong)NSArray *newmywimagesURLs;
@property (nonatomic,strong)NSArray *newmblimagesURLs;
@end

@implementation CaseNoteViewController
//修改病历
- (NSMutableArray *)mywimages{
    if (!_mywimages) {
        _mywimages = [NSMutableArray array];
    }
    return _mywimages;
}

- (NSMutableArray *)mblimages{
    if (!_mblimages) {
        _mblimages = [NSMutableArray array];
    }
    return _mblimages;
}

- (NSMutableArray *)mywimagesURLs{
    if (!_mywimagesURLs) {
        _mywimagesURLs = [NSMutableArray array];
    }
    return _mywimagesURLs;
}

- (NSMutableArray *)mblimagesURLs{
    if (!_mblimagesURLs) {
        _mblimagesURLs = [NSMutableArray array];
    }
    return _mblimagesURLs;
}

//
- (CaseDetailApi *)detailapi{
    if (!_detailapi) {
        _detailapi = [[CaseDetailApi alloc]init];
        _detailapi.delegate = self;
    }
    return _detailapi;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isEditEnter == YES) {
        [Utils addHudOnView:self.view withTitle:@"正在获取..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blDetail";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        bodyer.id = self.id;
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        [self.detailapi detailCase:requester.mj_keyValues.mutableCopy];
    }
}
- (EditBCApi *)api{
    if (!_api) {
        _api = [[EditBCApi alloc]init];
        _api.delegate = self;
    }
    return _api;
}

- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error{
    [Utils removeHudFromView:self.view];
    [Utils postMessage:command.response.msg onView:self.view];
}
- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject{
    [Utils removeHudFromView:self.view];
    if (api == _api) {
     
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        if (index >3) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-3)] animated:YES];
        }else
        {
//            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if (api == _detailapi) {
        self.model = responsObject;
        if (self.model.ywimages.length > 0) {
            self.mediaView0.preShowMedias = [self.model.ywimages componentsSeparatedByString:@";"];
            self.mywimagesURLs = [[self.model.ywimages componentsSeparatedByString:@";"] mutableCopy];
            [self.mediaView0 reload];
            
        }
        
        if (self.model.blimages.length > 0) {
            self.mediaView1.preShowMedias = [self.model.blimages componentsSeparatedByString:@";"];
            self.mblimagesURLs = [[self.model.blimages componentsSeparatedByString:@";"] mutableCopy];
            [self.mediaView1 reload];
        }
        
        if (self.model.yaowu.length > 0) {
            self.koufujilu.textView.text = self.model.yaowu;
        }
       
    }
}
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}
#pragma mark AutolayOut
- (void)layoutsubview{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(105);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        _saveButton.backgroundColor = AppStyleColor;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveButton;
}

- (ISTableViewCell *)yongyao{
    if (!_yongyao) {
        _yongyao = [[ISTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_yongyao setEditAble:NO];
        [_yongyao setSex:@"1"];
        _yongyao.selectionStyle = UITableViewCellSelectionStyleNone;
        [_yongyao setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"用药记录"];
    }
    return _yongyao;
}

- (UITableViewCell *)photo1{
    if (!_photo1) {
        _photo1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        label.backgroundColor  = DefaultBackgroundColor;
        [_photo1 addSubview:label];
        UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(20,CGRectGetMaxY(label.frame)+10, kScreenWidth, 25)];
        label0.font  =FontNameAndSize(16);
        label0.textColor  =DefaultGrayTextClor;
        label0.textAlignment = NSTextAlignmentLeft;
        label0.text = @"处方单、口服药物图片记录 。";
        [_photo1 addSubview:label0];
         self.mediaView0 = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label0.frame) + 10, kScreenWidth-20, 0)];
        self.mediaView0.showDelete = YES;
        self.mediaView0.showAddButton = YES;
        self.mediaView0.maxImageSelected = 9;
        self.mediaView0.allowMultipleSelection = YES;
        self.mediaView0.allowPickingVideo = NO;
        if (self.isEditEnter == YES) {
            [self.mediaView0 observeViewHeight:^(CGFloat mediaHeight) {
                NSLog(@"%f",mediaHeight);
            }];
            [self.mediaView0 observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                NSLog(@"---1111----%@",list);
                [self.mywimagesURLs removeAllObjects];
                NSMutableArray *newArr = [NSMutableArray array];
                        for (ACMediaModel *model in list) {
                            if (model.imageUrlString) {
                                [self.mywimagesURLs addObject:model.imageUrlString];
                            }else{
                                [newArr addObject:model.image];
                            }
                            NSLog(@"-------%@",model.imageUrlString);
               }
                if (newArr.count > 0) {
                    [Utils addHudOnView:self.view];
                    [Utils uploadImgs:newArr withResult:^(id imgs,NSInteger status) {
                        if (status == 1) {
                            [self.mywimagesURLs addObjectsFromArray:imgs];
                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                // Do something...
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [Utils removeHudFromView:self.view];
                                });
                            });
                        }
                    }];
                    NSLog(@"%@",self.mywimagesURLs);
            }
                
            }];
        }else{
            [self.mediaView0 observeViewHeight:^(CGFloat mediaHeight) {
                NSLog(@"%f",mediaHeight);
            }];
            [self.mediaView0 observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                // do something
                self.ywimages = [NSMutableArray array];
                [self.ywimages removeAllObjects];
                for (ACMediaModel *model in list) {
                    [self.ywimages addObject:model.image];
                }
                self.ywimagesURLs = [NSMutableArray array];
                [self.ywimagesURLs removeAllObjects];
                if (!self.ywimages) {
                    return ;
                }else{
                    [Utils addHudOnView:self.view];
                    [Utils uploadImgs:self.ywimages withResult:^(id imgs,NSInteger status) {
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            // Do something...
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [Utils removeHudFromView:self.view];
                            });
                        });
                        self.ywimagesURLs = (NSMutableArray *)imgs;
                        NSLog(@"%@",imgs);
                    }];
                }
                }];
        }
        [_photo1 addSubview:self.mediaView0];
        _photo1.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _photo1;
}

- (UITableViewCell *)photo2{
    if (!_photo2) {
        _photo2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        label.backgroundColor = DefaultBackgroundColor;
        [_photo2 addSubview:label];
        UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label.frame), kScreenWidth, 40)];
        label0.font  = [UIFont systemFontOfSize:16.0f weight:0.3];
        label0.textColor  =DefaultBlackLightTextClor;
        label0.textAlignment = NSTextAlignmentLeft;
        label0.text = @"病历报告";
        [_photo2 addSubview:label0];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label0.frame), kScreenWidth, 20)];
        label1.font  =FontNameAndSize(16);
        label1.textColor  =DefaultGrayTextClor;
        label1.textAlignment = NSTextAlignmentLeft;
        label1.text = @"请上传检查记录,检验报告出院小结,手术小结";
        [_photo2 addSubview:label1];
        self.mediaView1 = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label1.frame) + 10, kScreenWidth-20, 0)];
        self.mediaView1.showDelete = YES;
        self.mediaView1.showAddButton = YES;
        self.mediaView1.maxImageSelected = 9;
        self.mediaView1.allowMultipleSelection = YES;
        self.mediaView1.allowPickingVideo = NO;
        if (self.isEditEnter == YES) {
            [self.mediaView1 observeViewHeight:^(CGFloat mediaHeight) {
                NSLog(@"%f",mediaHeight);
            }];
            [self.mediaView1 observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                NSLog(@"---1111----%@",list);
                [self.mblimagesURLs removeAllObjects];
                NSMutableArray *newArr = [NSMutableArray array];
                for (ACMediaModel *model in list) {
                    if (model.imageUrlString) {
                        [self.mblimagesURLs addObject:model.imageUrlString];
                    }else{
                        [newArr addObject:model.image];
                    }
                    NSLog(@"-------%@",model.imageUrlString);
                }
                if (newArr.count > 0) {
                    [Utils addHudOnView:self.view];
                    [Utils uploadImgs:newArr withResult:^(id imgs,NSInteger status) {
                        if (status == 1) {
                            [self.mblimagesURLs addObjectsFromArray:imgs];
                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [Utils removeHudFromView:self.view];
                                });
                            });
                        }
                    }];
                    NSLog(@"%@",self.mywimagesURLs);
                }
            }];
            
        }else{
            [self.mediaView1 observeViewHeight:^(CGFloat mediaHeight) {
                NSLog(@"%f",mediaHeight);
            }];
            [self.mediaView1 observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
                // do something
                self.blimages = [NSMutableArray array];
                [self.blimages removeAllObjects];
                for (ACMediaModel *model in list) {
                    NSLog(@"%@",list);
                    [self.blimages addObject:model.image];
                }
                self.blimagesURLs = [NSMutableArray array];
                [self.blimagesURLs removeAllObjects];
                if (!self.blimages) {
                    return ;
                }else{
                    [Utils addHudOnView:self.view];
                    [Utils uploadImgs:self.blimages withResult:^(id imgs,NSInteger status) {
                                            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [Utils removeHudFromView:self.view];
                                                });
                                            });
                        self.blimagesURLs = (NSMutableArray *)imgs;
                        NSLog(@"%@",imgs);
                    }];
                }
            }];
        }
      
        [_photo2 addSubview:self.mediaView1];
        _photo2.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _photo2;
}
- (UpDateDetailTableViewCell *)yongyaojilu{
    if (!_yongyaojilu) {
        _yongyaojilu = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _yongyaojilu.label.text = @"主要症状";
        _yongyaojilu.textView.placeholder = @"存在的主要不适症状。";
        _yongyaojilu.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _yongyaojilu;
}
- (UpDateDetailTableViewCell *)koufujilu{
    if (!_koufujilu) {
        _koufujilu = [[UpDateDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _koufujilu.label.text = @"口服记录";
        _koufujilu.textView.placeholder = @"记录所有服用的口服药物名称以及用药剂量。";
        _koufujilu.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return _koufujilu;
}

- (ISTableViewCell *)koufu{
    if (!_koufu) {
        _koufu = [[ISTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_koufu setEditAble:NO];
        _koufu.selectionStyle = UITableViewCellSelectionStyleNone;
        [_koufu setIcon:[UIImage imageNamed:@"normal_n"] editedIcon:[UIImage imageNamed:@"normal_s"] placeholder:@"口服药物"];
    }
    return _koufu;
}

- (UIView *)chufangview{
    if (!_chufangview) {
        _chufangview = [[UIView alloc]init];
        _chufangview.backgroundColor = [UIColor whiteColor];
    }
    return _chufangview;
}

- (UILabel *)chufangLabel{
    if (!_chufangLabel) {
        _chufangLabel = [[UILabel alloc]init];
        _chufangLabel.font = FontNameAndSize(16);
        _chufangLabel.text = @"处方单，口服药物图片记录";
        _chufangLabel.textColor = DefaultBlackLightTextClor;
        _chufangLabel.backgroundColor = [UIColor whiteColor];
    }
    return _chufangLabel;
}

- (void)setheader{
    UIView *topView = [[UIView alloc]init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(95);
    }];
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UIView *stepline = [[UIView alloc]init];
    
    stepline.backgroundColor = AppStyleColor;
    
    [topView addSubview:stepline];
    
    [stepline mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(35);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.centerX.mas_equalTo(topView.mas_centerX);
        make.height.mas_equalTo(1.5);
        
    }];
    
    UIView *normalFlag = [[UIView alloc]init];
    
    normalFlag.backgroundColor = AppStyleColor;
    
    normalFlag.layer.cornerRadius = 10;
    
    normalFlag.layer.masksToBounds = YES;
    
    [topView addSubview:normalFlag];
    
    [normalFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
        
    }];
    
    UIImageView *img1 = [[UIImageView alloc]init];
    
    img1.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    
    [normalFlag addSubview:img1];
    
    [img1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
  
    UIView *normalFlag1Line = [[UIView alloc]init];
    
    normalFlag1Line.backgroundColor = AppStyleColor;
    
    normalFlag1Line.layer.cornerRadius = 3.5;
    
    normalFlag1Line.layer.masksToBounds = YES;
    
    [stepline addSubview:normalFlag1Line];
    
    [normalFlag1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(stepline.mas_left);
        
        make.width.mas_equalTo((kScreenWidth - 80)/2);
        
        make.height.mas_equalTo(1.5);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
        
    }];
    
    
    UILabel *norLabel = [[UILabel alloc]init];
    
    [topView addSubview:norLabel];
    
    norLabel.textColor = AppStyleColor;
    
    norLabel.textAlignment = NSTextAlignmentCenter;
    
    norLabel.text = @"患者信息";
    
    norLabel.font = FontNameAndSize(15);
    
    [norLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(normalFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(normalFlag.mas_centerX);
    }];
    
    //
    
    UIView *authFlag = [[UIView alloc]init];
    
    authFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    authFlag.layer.cornerRadius = 10;
    
    authFlag.layer.masksToBounds = YES;
    
    authFlag.backgroundColor = AppStyleColor;
    
    [topView addSubview:authFlag];
    
    [authFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(stepline.mas_centerX);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UIImageView *img2 = [[UIImageView alloc]init];
    
    img2.image = [UIImage imageNamed:@"mycollection_dele_sel"];
    
    [authFlag addSubview:img2];
    
    [img2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    UILabel *authLabel = [[UILabel alloc]init];
    
    [topView addSubview:authLabel];
    
    authLabel.textColor = AppStyleColor;
    
    authLabel.textAlignment = NSTextAlignmentCenter;
    
    authLabel.text = @"病史资料";
    
    authLabel.font = FontNameAndSize(15);
    
    [authLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(authFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(authFlag.mas_centerX);
    }];
    //
    UIView *noteFlag = [[UIView alloc]init];
    
    noteFlag.backgroundColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1.0f];
    
    noteFlag.layer.cornerRadius = 10;
    
    noteFlag.backgroundColor = AppStyleColor;
    
    noteFlag.layer.masksToBounds = YES;
    
    [topView addSubview:noteFlag];
    
    [noteFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(stepline.mas_right);
        
        make.width.height.mas_equalTo(20);
        
        make.centerY.mas_equalTo(stepline.mas_centerY);
    }];
    
    UIView *noteFlag1 = [[UIView alloc]init];
    
    noteFlag1.backgroundColor = [UIColor whiteColor];
    
    noteFlag1.layer.cornerRadius = 3.5;
    
    noteFlag1.layer.masksToBounds = YES;
    
    [noteFlag addSubview:noteFlag1];
    
    [noteFlag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
        
        make.width.height.mas_equalTo(7);
        
        make.centerY.mas_equalTo(noteFlag.mas_centerY);
    }];
    UILabel *noteLabel = [[UILabel alloc]init];
    [topView addSubview:noteLabel];
    noteLabel.textColor = AppStyleColor;
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.text = @"病程记录";
    noteLabel.font = FontNameAndSize(15);
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(noteFlag.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
        make.centerX.mas_equalTo(noteFlag.mas_centerX);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBackgroundColor;
    [self setheader];
    self.list = @[self.yongyao,self.koufu,self.koufujilu,self.photo1,self.photo2];
    [self.view addSubview:self.tableView];
    [self layoutsubview];
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];
    self.yongyao.sex = @"0";
    self.koufu.sex = @"0";
    weakify(self);
    self.yongyao.type = ^(NSString *type) {
        if ([type isEqualToString:@"0"]) {
            strongify(self);
            self.yongyao.sex = @"0";
            self.koufu.sex = @"0";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPath1,indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];//
        }else{
            strongify(self);
            self.yongyao.sex = @"1";
            self.koufu.sex = @"1";
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
            NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:3 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPath1,indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];//
        }
    };
    
    self.koufu.type = ^(NSString *type) {
        if ([type isEqualToString:@"0"]) {
            strongify(self);
            self.koufu.sex = @"0";
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];//
        }else{
            strongify(self);
            self.koufu.sex = @"1";
            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:2 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,nil] withRowAnimation:UITableViewRowAnimationNone];//
        }
    };
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self.saveButton addTarget:self action:@selector(tosave) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isEditEnter == YES) {
        
    }
    
}

-(void)tosave{
    
    if (self.isEditEnter == YES) {
        [Utils addHudOnView:self.view withTitle:@"正在修改..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blUpdateC";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        bodyer.id  = self.model.id;
        bodyer.ywimages =[self.mywimagesURLs componentsJoinedByString:@";"];
        bodyer.blimages =[self.mblimagesURLs componentsJoinedByString:@";"];
        if (self.koufujilu.textView.text.length <= 0) {
            bodyer.yaowu = @"";
        }else{
            bodyer.yaowu = self.koufujilu.textView.text;
        }
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester.mj_keyValues.mutableCopy);
        [self.api EditBC:requester.mj_keyValues.mutableCopy];
        
    }else{
        [Utils addHudOnView:self.view withTitle:@"正在保存..."];
        caseListHeader *header = [[caseListHeader alloc]init];
        header.target = @"bingLiControl";
        header.method = @"blUpdateC";
        header.versioncode = Versioncode;
        header.devicenum = Devicenum;
        header.fromtype = Fromtype;
        header.token = [User LocalUser].token;
        caseListBody *bodyer = [[caseListBody alloc]init];
        if ([self.yongyao.sex isEqualToString:@"1"]) {
            bodyer.blimages =[self.blimagesURLs componentsJoinedByString:@";"];
            bodyer.id  = self.id;
            bodyer.yaowu = @"";
            bodyer.ywimages =@"";
            bodyer.id  = self.id;
        }else{
            if ([self.koufu.sex isEqualToString:@"1"]) {
                bodyer.ywimages =[self.ywimagesURLs componentsJoinedByString:@";"];
                bodyer.blimages =[self.blimagesURLs componentsJoinedByString:@";"];
                bodyer.yaowu = @"";
                bodyer.id  = self.id;
            }else{
                bodyer.yaowu = self.koufujilu.textView.text;
                bodyer.ywimages =[self.ywimagesURLs componentsJoinedByString:@";"];
                bodyer.blimages =[self.blimagesURLs componentsJoinedByString:@";"];
                bodyer.id  = self.id;
            }
        }
        CaseListRequest *requester = [[CaseListRequest alloc]init];
        requester.head = header;
        requester.body = bodyer;
        NSLog(@"%@",requester.mj_keyValues.mutableCopy);
        [self.api EditBC:requester.mj_keyValues.mutableCopy];
    }
  
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([self.yongyao.sex isEqualToString:@"1"]) {
            self.tableView.bounces = NO;
            if (indexPath.row == 0) {
                return 40;
            }else if (indexPath.row == 1){
                return 0;
            }else if (indexPath.row == 2){
                if ([self.koufu.sex isEqualToString:@"1"]) {
                    return 0;
                }else{
                    return 120;
                }
            }else if (indexPath.row == 3){
                return 0;
            }else{
                return 410;
            }
        }else{
            self.tableView.bounces = YES;
            if (indexPath.row == 0) {
                return 40;
            }else if (indexPath.row == 1){
                return 40;
            }else if (indexPath.row == 2){
                if ([self.koufu.sex isEqualToString:@"1"]) {
                    return 0;
                }else{
                    return 120;
                }
            }else if (indexPath.row == 3){
                return 353.5;
            }
            else{
                return 410;
            }
        }
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.list safeObjectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        if (section == 0) {
            return 0.000001;
        }else{
            return 0;
        }
    } else {
        if (section == 0) {
            return CGFLOAT_MIN;
        }else{
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (@available(iOS 11.0, *)) {
        return [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    } else {
        return nil;
    }
}

@end
