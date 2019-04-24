//
//  FreeConsultViewController.m
//  FreelyHeath
//
//  Created by L on 2017/7/25.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "FreeConsultViewController.h"
#import "SZTextView.h"
#import "CommentCell.h"
#define MaxCount 9
#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count
#import "UploadToolRequest.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "SendApi.h"
#import "SendPicRequest.h"
#import "CustomerViewController.h"
#import "HUPhotoBrowser.h"
#import <UIImageView+WebCache.h>
#import "UIImageView+HUWebImage.h"
#import "HUImagePickerViewController.h"
#import "UIImage+compress.h"
#import "UIImage+Extensions.h"
#import "GetUdeskTokenRequest.h"
#import "UdeskApi.h"
#import "UModel.h"
#import "HTTPRequestTool.h"
#import "CommitWorkOrderReQuest.h"
#import "UdeskSDKManager.h"
#import "WorkOrderModel.h"
#import "WorkOrderApi.h"
#import "Uploader.h"
#import "Udesk_WHC_HttpManager.h"
#import "Udesk_WHC_BaseOperation.h"
#import "UdeskTicketViewController.h"
@interface FreeConsultViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ApiRequestDelegate,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>
{
    UIView          *addImgView;         //评论图片View
    UIButton        *addImg;             //中间添加图片按钮
    UICollectionView *collection;        //存放图片的容器
    NSMutableArray  *imageArr;           //存放图片数据源
    UIActionSheet   *myActionSheet;
    BOOL cansend;
}

@property (nonatomic, strong)SZTextView *remark;

@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic, strong)UILabel *label;

@property (nonatomic,strong)UIButton *commitButton;


@property (nonatomic,assign)BOOL flag;

//
@property (nonatomic,strong)NSMutableArray *imagesArray;

@property (nonatomic,strong)NSMutableArray *sendArray;

@property (nonatomic,strong)NSArray *imageS;

@property (nonatomic,strong)NSMutableArray *patameterArr;

@property (nonatomic, strong)NSString *userID;

@property (nonatomic, strong)NSString *hotelRoomNumID;

@property (nonatomic, strong)NSString *orderID;

@property (nonatomic, strong)NSMutableArray *workOderFillArray;


@property (nonatomic,strong)OSSApi *api;

@property (nonatomic,strong)OSSModel *oss;


@property (nonatomic,strong)SendApi *sendapi;

@property (nonatomic,strong)JGProgressHUD *hub;

@property (nonatomic,strong)UdeskApi *Uapi;

@property (nonatomic,strong)WorkOrderModel *workapi;


@end

@implementation FreeConsultViewController


- (NSMutableArray *)imagesArray
{

    if (!_imagesArray) {
        
        _imagesArray = [NSMutableArray array];
    }
    
    return _imagesArray;

}

- (NSMutableArray *)sendArray
{

    if (!_sendArray) {
        
        _sendArray = [NSMutableArray array];
    }
    
    return _sendArray;

}


- (OSSApi *)api
{

    if (!_api) {
        
        _api = [[OSSApi alloc]init];
        
        _api.delegate = self;
    }
    return _api;
    
}

- (UdeskApi *)Uapi
{
    
    if (!_Uapi) {
        
        _Uapi = [[UdeskApi alloc]init];
        
        _Uapi.delegate  =self;
        
    }
    return _Uapi;
}

- (SendApi *)sendapi
{
    
    if (!_sendapi) {
        
        _sendapi = [[SendApi alloc]init];
        
        _sendapi.delegate = self;
        
    }
    
    return _sendapi;
    
}


- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    
}

- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _api) {
        
        OSSModel *model = responsObject;
        
        NSLog(@"uuuuuuuuuuuuxxxxxxxx%@    %@ %@ %@ %@",model.accessKeyId,model.accessKeySecret,model.bucket,model.expiration,model.securityToken);
        
        if (imageArr.count <= 0) {
            
            [Utils postMessage:@"为了专家快速诊断，我们建议您上传病历资料" onView:self.view];
            
            return;
            
        }
        
        self.hub = [Public hudWhenRequest];
        [self.hub showInView:self.view animated:YES];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (UIImage *image in imageArr) {
            
            [arr addObject:[[image fixOrientation]compressedImage]];
            
        }
        
        [OSSImageUploader asyncUploadImages:arr access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            for (NSString *image in names) {
                
                UIImageModel *model1 = [[UIImageModel alloc]init];
                
                model1.imagepath = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,image];
                
                [self.sendArray addObject:[NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,image]];
                
                [self.imagesArray addObject:model1];
                
            }
            
        }];

    }
    
    if (api == _sendapi) {
        
        [self.hub dismissAnimated:YES];
        
        udeskHeader *head = [[udeskHeader alloc]init];
        
        head.target = @"generalControl";
        
        head.method = @"getUdeskToken";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        udeskBody *body = [[udeskBody alloc]init];
        
        GetUdeskTokenRequest *request = [[GetUdeskTokenRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        NSLog(@"%@",request);
        
        [self.Uapi getudesk:request.mj_keyValues.mutableCopy];

        
    }
    
    
    if (api == _Uapi) {
        
        UModel *model = responsObject;
        
        NSLog(@"%@,%@,%@",model.timestamp,model.open_api_auth_token,model.sign);
        
        [self creatWorkOrder:model.timestamp sign:model.sign];
        
    }
    
}


- (void)creatWorkOrder:(NSString *)timestamp sign:(NSString *)sign{
    
    //创建工单
    //        http://shanghaidemo0705.udesk.cn/open_api_v1/tickets?email=shudesk@163.com&timestamp=1509346527&sign=bbbb42ab376fa02d20055b95f5d953b604cd978d
//    http://freelyhealth.udesk.cn/open_api_v1/tickets/upload_file?email=admin@freelyhealth.cn
    
    NSString *url = [NSString stringWithFormat:@"http://freelyhealth.udesk.cn/open_api_v1/tickets?email=admin@freelyhealth.cn&timestamp=%@&sign=%@",timestamp,sign];
    
    NSLog(@"%@",url);
    
    ticket *ticke = [[ticket alloc]init];
    //标题
    ticke.subject = self.remark.text;
    //内容
    ticke.content = self.remark.text;
    //工单关注人,如[1,2,3],数组内是客服id
//    ticke.follower_ids = @"";
    //        工单模板id,无传入值则使用默认模板
//    ticke.template_id = @"3274";
    ticke.type = @"cellphone";
    ticke.type_content = [User LocalUser].phone;
//    ticke.tags = @"标签1，标签2";
//    ticke.priority = @"标准";
//    ticke.status = @"解决中";
//    ticke.agent_group_name = @"深圳直医客服";
//    ticke.assignee_email = @"2418872494@qq.com";
//    ticke.ticket_field = @"";
    
    CommitWorkOrderReQuest *request = [[CommitWorkOrderReQuest alloc]init];
    request.ticket = ticke;
    
    NSLog(@"%@",request.mj_keyValues.mutableCopy);
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    //设置网络请求超时时间
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    manger = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    AFJSONResponseSerializer *responseSerializer = (AFJSONResponseSerializer *)manger.responseSerializer;
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manger.securityPolicy = securityPolicy;
    manger.requestSerializer = [AFJSONRequestSerializer serializer];
    if ([responseSerializer respondsToSelector:@selector(setRemovesKeysWithNullValues:)]) {
        [responseSerializer setRemovesKeysWithNullValues:YES];
    }
    
    NSMutableSet *set = [NSMutableSet setWithSet:manger.responseSerializer.acceptableContentTypes];
    [set addObject:@"text/html"];
    [set addObject:@"text/json"];
    [set addObject:@"text/plain"];
    [set addObject:@"charset=utf-8"];
//    [set addObject:@"Set-Cookie"];
//    [set addObject:@"application/octet-stream"];
    manger.responseSerializer.acceptableContentTypes = set;
    
    [manger POST:url parameters:request.mj_keyValues.mutableCopy success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSLog(@"%@",responseObject);
        
        [Utils postMessage:responseObject[@"message"] onView:self.view];
        
        [self upLoadImageWithTargetId:responseObject[@"ticket_id"] timestamp:timestamp sign:sign fileName:@"my_picture.gif" type:@"image/gif"];

        NSLog(@"%@",responseObject[@"ticket_id"]);
        
        UdeskSDKManager *manager = [[UdeskSDKManager alloc] initWithSDKStyle:[UdeskSDKStyle blueStyle]];
        
        [UdeskManager setupCustomerOnline];
        //设置头像
        [manager setCustomerAvatarWithURL:[User LocalUser].facepath];
        
        NSDictionary *dict = @{@"productImageUrl":[self.imageArray firstObject], @"productTitle":self.remark.text,@"productDetail":self.remark.text,@"productURL":[self.imageArray firstObject]};
        [manager setProductMessage:dict];
        
        [manager pushUdeskInViewController:self completion:nil];
        //点击留言回调
        [manager leaveMessageButtonAction:^(UIViewController *viewController){
            
            UdeskTicketViewController *offLineTicket = [[UdeskTicketViewController alloc] init];
            [viewController presentViewController:offLineTicket animated:YES completion:nil];
            
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
}

- (NSString *)imageTypeWithData:(NSData *)data {
    uint8_t type;
    [data getBytes:&type length:1];
    switch (type) {
        case 0xFF:
            return @"image/jpg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
            
    }
    return nil;
}


- (void)upLoadImageWithTargetId:(NSString *)targrtId timestamp:(NSString *)timestamp sign:(NSString *)sign fileName:(NSString *)filename type:(NSString *)type{

        for (int i = 0; i < imageArr.count; i++) {

            NSData * imageData = UIImageJPEGRepresentation(imageArr[i], 0.5);
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filePath = [NSString stringWithFormat:@"%@/%f.jpg", path, [[NSDate date] timeIntervalSince1970]];
            [imageData writeToFile:filePath atomically:YES];
            
            NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
//
//            [[Udesk_WHC_HttpManager shared] addUploadFileData:imageData withFileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpeg" forKey:@"file"];
            [[Udesk_WHC_HttpManager shared] addUploadFile:filePath forKey:@"file"];
            
        }

//             NSDictionary *dic = @{@"email":@"admin@freelyhealth.cn",
//                                  @"timestamp":timestamp? timestamp:@"",
//                                  @"sign":sign,
//                                  @"ticket_id":targrtId,
//                                  @"file_name":@"1.jpg",
//                                  @"type":@"image/jpeg"
//                                  };
    
//    http://demo.udesk.cn/open_api_v1/tickets/upload_file?email=admin@udesk.cn&timestamp=1503298812&sign=4a38e71a044e4dccb6069418abd2153e905a31cb&ticket_id=1&file_name=my_picture.gif&type=image/gif
    
    [[Udesk_WHC_HttpManager shared] upload:[NSString stringWithFormat:@"http://freelyhealth.udesk.cn/open_api_v1/tickets/upload_file?email=admin@freelyhealth.cn&timestamp=%@&sign=%@&ticket_id=%@&file_name=my_picture.jpg&type=image/jpeg",timestamp,sign,targrtId] param:nil process:^(Udesk_WHC_BaseOperation * _Nullable operation, uint64_t recvLength, uint64_t totalLength, NSString * _Nullable speed) {
        
        
    } didFinished:^(Udesk_WHC_BaseOperation * _Nullable operation, NSData * _Nullable data, NSError * _Nullable error, BOOL isSuccess) {
        
        //处理上传结果数据
        [self.hub dismissAnimated:YES];
        
        [Utils postMessage:@"图片上传成功" onView:self.view];
        
    }];
//        [[Udesk_WHC_HttpManager shared] upload:@"http://freelyhealth.udesk.cn/open_api_v1/tickets/upload_file"
//                                         param:dic didFinished:^(Udesk_WHC_BaseOperation *operation,
//                                                                 NSData *data,
//                                                                 NSError *error,
//                                                                 BOOL isSuccess) {
//
//
//                                         }];
   
//    for (int i = 0; i < imageArr.count; i++) {
//
//    NSData *imageData = UIImageJPEGRepresentation(imageArr[i], 0.3);
//
//    NSString *subStr = [[[self imageTypeWithData:imageData] componentsSeparatedByString:@"/"] lastObject];
//    NSDictionary *dic = @{    @"email":@"admin@freelyhealth.cn",
//                              @"timestamp":timestamp? timestamp:@"",
//                              @"sign":sign,
//                              @"ticket_id":targrtId,
//                              @"file_name":[NSString stringWithFormat:@"%d.%@",i,subStr],
//                              @"type":[NSString stringWithFormat:@"image/%@",subStr]
//                              };
//
//    [[Uploader sharedUploader]uploadImage:imageArr[i] para:dic withCompletionBlock:^(ApiCommand *cmd, BOOL success, NSString *imageUrl) {
//
//        if (success) {
//
//            [Utils postMessage:@"上传图片附件成功！" onView:self.view];
//
//        }
//
//    }];
    
//};
    
}

- (NSArray *)imageS{
    
    if (!_imageS) {
        
        _imageS = [NSArray array];
    }
    
    return _imageS;
    
}


- (NSMutableArray *)imageArray
{
    
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
    
}


- (SZTextView *)remark {
    if (!_remark) {
        _remark = [[SZTextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 184)];
        _remark.backgroundColor = [UIColor whiteColor];
        _remark.delegate = self;
        _remark.font = Font(16);
        _remark.textColor = HexColor(0x333333);
        _remark.placeholder = @"请填写您需要咨询的问题，如症状+持续时间";
        _remark.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
        _remark.showsHorizontalScrollIndicator = NO;
        _remark.showsVerticalScrollIndicator = NO;
        
    }
    return _remark;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提问";

    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    self.view.backgroundColor = DefaultBackgroundColor;
    
    imageArr = [NSMutableArray array];
    
    [self.view addSubview:self.remark];
  
    self.remark.tintColor = DefaultGrayTextClor;
    UIView *linView = [[UIView alloc]initWithFrame:CGRectMake(0, self.remark.bottom+5, kScreenWidth, 10)];
    linView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:linView];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, linView.bottom, kScreenWidth, 20)];
    [self.view addSubview:self.label];
    self.label.textColor = DefaultGrayTextClor;
    self.label.text = @"请上传病历资料图片";
    self.label.backgroundColor = [UIColor whiteColor];
    addImgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.label.bottom, kScreenWidth, ImageWidth+20)];
    addImgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addImgView];
    addImg = [UIButton buttonWithType:UIButtonTypeCustom];
    addImg.frame = CGRectMake(10, 10, ImageWidth, ImageWidth);
    [addImg setBackgroundImage:[UIImage imageNamed:@"addImg"] forState:UIControlStateNormal];
    [addImg setBackgroundImage:[UIImage imageNamed:@"addImg"] forState:UIControlStateSelected];
    [addImg addTarget:self action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [addImgView addSubview:addImg];
    
    //存放图片的UICollectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addImg.frame)+10, 5, kScreenWidth-10-CGRectGetMaxX(addImg.frame), ImageWidth+10) collectionViewLayout:flowLayout];
    [collection registerClass:[CommentCell class] forCellWithReuseIdentifier:@"myCell"];
    [collection setAllowsMultipleSelection:YES];
    collection.showsHorizontalScrollIndicator = NO;
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor clearColor];
    [addImgView addSubview:collection];
    
    UILabel *bottomView = [[UILabel alloc]initWithFrame:CGRectMake(10,310, kScreenWidth - 40, 20)];
    
    bottomView.font = Font(14);
    
    bottomView.text = @"问题情况填写越清楚，越有利于专家的准确回答";
    
    bottomView.textAlignment = NSTextAlignmentLeft;
    
    bottomView.textColor = DefaultGrayTextClor;
    
    [self.view addSubview:bottomView];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:self.commitButton];
    
    self.commitButton.backgroundColor = AppStyleColor;
    
    [self.commitButton setTitle:@"确定咨询" forState:UIControlStateNormal];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];
    
    [self.commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

- (void)commitAction{

    if (self.remark.text.length <=0) {
        
        [Utils postMessage:@"请输入您要咨询的问题" onView:self.view];
        
        return;
        
    }
    
    UploadHeader *head = [[UploadHeader alloc]init];
    
    head.target = @"generalControl";
    
    head.method = @"getOssSign";
    
    head.versioncode = Versioncode;
    
    head.devicenum = Devicenum;
    
    head.fromtype = Fromtype;
    
    head.token = [User LocalUser].token;
    
    UploadBody *body = [[UploadBody alloc]init];
    
    UploadToolRequest *request = [[UploadToolRequest alloc]init];
    
    request.head = head;
    
    request.body = body;
    
    NSLog(@"%@",request);
    
    [self.api getoss:request.mj_keyValues.mutableCopy];
    
    double delayInSeconds = 5.0;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, mainQueue, ^{
        
        sendPicHeader *head = [[sendPicHeader alloc]init];
        
        head.target = @"consultControl";
        
        head.method = @"consultAsk";
        
        head.versioncode = Versioncode;
        
        head.devicenum = Devicenum;
        
        head.fromtype = Fromtype;
        
        head.token = [User LocalUser].token;
        
        sendPicBody *body = [[sendPicBody alloc]init];
        
        SendPicRequest *request = [[SendPicRequest alloc]init];
        
        request.head = head;
        
        request.body = body;
        
        body.images = self.imagesArray;
        
        body.ask = self.remark.text;
        
        NSLog(@"99%@",request);
        
        [self.sendapi sendPic:request.mj_keyValues.mutableCopy];
        
    });

    
}


- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 添加图片监听
- (void)addImage {
    
    NSLog(@"ddddddd");
    
    if (imageArr.count>=MaxCount) {
        
        //[BHUD showErrorMessage:@"亲，最多只能上传9张图片哦~~"];
        
    } else {
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"从本地图库获取", nil];
        [myActionSheet showInView:self.view];
    }
    
}

#pragma mark - UIActionSheetDelegate代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://打开照相机拍照
            [self takePhoto];
            break;
        case 1://打开本地相册
            [self LocalPhoto];
            break;
    }
}

#pragma mark - 打开照相机
-(void)takePhoto{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        ////NSLog(@"模拟器中无法使用照相机，请在真机中使用");
    }
    
}

#pragma mark - 打开本地图库
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MaxCount-imageArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate【把选中的图片放到这里】
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image=[info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        data=UIImageJPEGRepresentation(image, 0.5); //0.0最大压缩率  1.0最小压缩率
        //将获取到的图像image赋给UserImage，改变其头像
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIImage *originalImage = [UIImage imageWithData:data];
        UIImage *handleImage;
        handleImage = originalImage;
        
        if (imageArr.count<MaxCount) {
            [imageArr addObject:originalImage];
        }
        
        if (imageArr.count<MaxCount) {
        } else {
            addImg.hidden = YES; //最多上传6张图片
        }
        if (imageArr.count*(ImageWidth+10)>kScreenWidth+20) {
            
        }
        [collection reloadData];
        
        NSLog(@"jjjjjjjjjjjjj%@",imageArr);
        
    }
    
}

#pragma mark - 照片选取取消
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            NSData *data;
            data=UIImageJPEGRepresentation(tempImg, 0.0); //0.0最大压缩率  1.0最小压缩率
            UIImage *originalImage = [UIImage imageWithData:data];
            UIImage *scaleImage = [self imageWithImageSimple:[UIImage imageWithData:data] scaledToSize:CGSizeMake(originalImage.size.width*0.5, originalImage.size.height*0.5)];
            
            UIImage *handleImage;
            double diagonalLength = hypot(scaleImage.size.width, scaleImage.size.height); //对角线
            if (diagonalLength>917) {
                double i = diagonalLength/917;
                handleImage = [self cutImage:scaleImage andSize:CGSizeMake(scaleImage.size.width/i, scaleImage.size.height/i)];
            } else {
                handleImage = scaleImage;
            }
            
            if (imageArr.count<MaxCount) {
                [imageArr addObject:originalImage];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (imageArr.count<MaxCount) {
            } else {
                addImg.hidden = YES; //最多上传9张图片
            }
            
            [collection reloadData];
            
        });
        
        NSLog(@"jjjjjjjjjjjjj%@",imageArr);
        
        // [self.ossApi workOrderWithOssParameter];
        
    });
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.9451 green:0.5686 blue:0.1725 alpha:1.0]];
    //    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ImageWidth, ImageWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"myCell";
    CommentCell *cell = (CommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   
    cell.imageView.image = imageArr[indexPath.row];
    cell.cancelBtn.tag = indexPath.row;
    [cell.cancelBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    CommentCell *cell = (CommentCell *)[collectionView cellForItemAtIndexPath:indexPath];

    cell.imageView.image = imageArr[indexPath.row];

    [HUPhotoBrowser showFromImageView:cell.imageView withImages:imageArr atIndex:indexPath.row];

}

#pragma mark - 取消选择的图片
- (void)cancelImg:(UIButton *)btn {
    CommentCell *cell = (CommentCell *)btn.superview;
    NSIndexPath *indexPath = [collection indexPathForCell:cell];
    [imageArr removeObjectAtIndex:indexPath.row];
    if (imageArr.count<MaxCount) {
        addImg.hidden = NO;
        //添加图片的按钮在第一行
        [collection reloadData];
    } else {
        addImg.hidden = YES; //最多上传6张图片
    }
    
}

//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#pragma mark - 压缩、裁剪图片
- (UIImage *)cutImage:(UIImage*)image andSize:(CGSize)size
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (size.width / size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * size.height / size.width;
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * size.width / size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    
    return [UIImage imageWithCGImage:imageRef];
}



@end
