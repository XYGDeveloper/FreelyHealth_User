//
//  UpdateViewController.m
//  FreelyHeath
//
//  Created by xyg on 2017/8/5.
//  Copyright © 2017年 深圳乐易住智能科技股份有限公司. All rights reserved.
//

#import "UpdateViewController.h"
#import "FileModel.h"
#import "MyTextView.h"
#import "CommentCell.h"
#define MaxCount 9
#define Count 5  //一行最多放几张图片
#define ImageWidth ([UIScreen mainScreen].bounds.size.width-80)/Count
#import "UploadToolRequest.h"
#import "OSSApi.h"
#import "OSSModel.h"
#import "SendApi.h"
#import "SendPicRequest.h"
#import "UpdateApi.h"
#import "UpdateRequest.h"
@interface UpdateViewController ()<UITableViewDelegate, UITableViewDataSource,UIActionSheetDelegate,ApiRequestDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,ApiRequestDelegate>
{
    UIView          *addImgView;         //评论图片View
    UIButton        *addImg;             //中间添加图片按钮
    UICollectionView *collection;        //存放图片的容器
    NSMutableArray  *imageArr;           //存放图片数据源
    UIActionSheet   *myActionSheet;
    BOOL cansend;
}

@property (nonatomic, strong)MyTextView *remark;

@property (nonatomic,strong)NSMutableArray *imageArray;

@property (nonatomic, strong)UILabel *label;

@property (nonatomic,strong)UIButton *commitButton;


@property (nonatomic,assign)BOOL flag;

//


@property (nonatomic,strong)NSArray *imageS;

@property (nonatomic,strong)NSMutableArray *patameterArr;

@property (nonatomic, strong)NSString *userID;

@property (nonatomic, strong)NSString *hotelRoomNumID;

@property (nonatomic, strong)NSString *orderID;

@property (nonatomic, strong)NSMutableArray *workOderFillArray;


@property (nonatomic,strong)OSSApi *api;

@property (nonatomic,strong)SendApi *sendapi;

@property (nonatomic,strong)JGProgressHUD *hub;

//
@property (nonatomic,strong)TPKeyboardAvoidingTableView *tableView;

@property (nonatomic,strong)SelectTypeTableViewCell *name;

@property (nonatomic,strong)SelectTypeTableViewCell *sex;

@property (nonatomic,strong)SelectTypeTableViewCell *age;

@property (nonatomic,strong)SelectTypeTableViewCell *phone;

@property (nonatomic,strong)SelectTypeTableViewCell *address;

@property (nonatomic,strong)HClActionSheet *selectSex;

@property (nonatomic,strong)HClActionSheet *selectAddress;

@property (nonatomic,strong)NSMutableArray *citysArr;

@property (nonatomic,strong)CityListApi *cityApi;

@property (nonatomic,strong)UpdateApi *updateapi;


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic,strong)NSMutableArray *cityList;

@property (nonatomic,strong)NSMutableArray *imagesss;


@end

@implementation UpdateViewController

- (NSMutableArray *)imagesss
{

    if (!_imagesss) {
        
        _imagesss = [NSMutableArray array];
    }
    
    return _imagesss;

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

- (CityListApi *)cityApi
{
    
    if (!_cityApi) {
        
        _cityApi = [[CityListApi alloc]init];
        
        _cityApi.delegate  =self;
        
    }
    
    return _cityApi;
    
    
}

- (UpdateApi *)updateapi
{
    
    if (!_updateapi) {
        
        _updateapi = [[UpdateApi alloc]init];
        
        _updateapi.delegate  =self;
        
    }
    
    return _updateapi;
    
    
}


- (NSMutableArray *)citysArr
{
    
    if (!_citysArr) {
        
        _citysArr = [NSMutableArray array];
    }
    
    return _citysArr;
    
}


- (NSMutableArray *)cityList
{
    
    if (!_cityList) {
        
        _cityList = [NSMutableArray array];
    }
    
    return _cityList;
    
}

- (OSSApi *)api
{
    
    if (!_api) {
        
        _api = [[OSSApi alloc]init];
        
        _api.delegate = self;
        
    }
    
    return _api;
    
    
}


- (SendApi *)sendapi
{
    
    if (!_sendapi) {
        
        _sendapi = [[SendApi alloc]init];
        
        _sendapi.delegate = self;
        
    }
    
    return _sendapi;
    
    
}






#pragma mark - Properties
- (TPKeyboardAvoidingTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = DefaultBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)layoutsubview{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftNavigationItemWithImage:[UIImage imageNamed:@"navi_back"] highligthtedImage:[UIImage imageNamed:@"navi_back"] action:@selector(back)];

    self.dataArray = @[self.name, self.sex, self.age,self.address,self.phone];
    
    [self.view addSubview:self.tableView];
    
    
    [self.tableView reloadData];
    
    [self layoutsubview];
    
    cityHeader *cityhead = [[cityHeader alloc]init];
    
    cityhead.target = @"noTokenOrderControl";
    
    cityhead.method = @"getCityList";
    
    cityhead.versioncode = Versioncode;
    
    cityhead.devicenum = Devicenum;
    
    cityhead.fromtype = Fromtype;
    
    cityhead.token = [User LocalUser].token;
    
    cityBody *citybody = [[cityBody alloc]init];
    
    GetOrderCityListRequest *cityrequest = [[GetOrderCityListRequest alloc]init];
    
    cityrequest.head = cityhead;
    
    cityrequest.body = citybody;
    
    [self.cityApi getCityList:cityrequest.mj_keyValues.mutableCopy];
    
    
    self.name.text = self.model.name;
    
    self.sex.text  =self.model.sex;
    
    self.age.text  =self.model.age;

    self.address.text  =self.model.city;

    self.phone.text  =self.model.rname;

    //
    
    NSArray *recorder = [recordModel mj_objectArrayWithKeyValuesArray:self.model.records];
    
    NSMutableArray *arrType1 = [NSMutableArray array];
    
    for (recordModel *model in recorder) {
        
        if ([model.type isEqualToString:@"1"]) {
            
            [arrType1 addObject:model];
        }
    }
    
    recordModel *model1 = [arrType1 firstObject];
    
    self.imagesss = [model1.imagepath componentsSeparatedByString:@","].mutableCopy;
    
    
    imageArr = [NSMutableArray array];
  
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:button];
    
    button.backgroundColor = AppStyleColor;
    
    [button setTitle:@"完成" forState:UIControlStateNormal];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    [button addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Do any additional setup after loading the view.
}

- (void)commit{

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



}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)api:(BaseApi *)api failedWithCommand:(ApiCommand *)command error:(NSError *)error
{
    
    [Utils postMessage:command.response.msg onView:self.view];
    
}


- (void)api:(BaseApi *)api successWithCommand:(ApiCommand *)command responseObject:(id)responsObject
{
    
    if (api == _cityApi) {
        
        NSLog(@"%@",responsObject);
        
        self.citysArr = responsObject;
        
        for (CityModel *model in responsObject) {
            
            [self.cityList addObject:model.name];
            
            
        }
        
        NSLog(@"%@",self.cityList);
        
        
        [self.tableView reloadData];

        
    }
    
    
    if (api == _api) {
        
        OSSModel *model = responsObject;
        
        NSLog(@"uuuuuuuuuuuuxxxxxxxx%@    %@ %@ %@ %@",model.accessKeyId,model.accessKeySecret,model.bucket,model.expiration,model.securityToken);
        
        self.hub = [Public hudWhenRequest];
        [self.hub showInView:self.view animated:YES];
        
        [OSSImageUploader asyncUploadImages:imageArr access:model.accessKeyId secreat:model.accessKeySecret host:model.endpoint secutyToken:model.securityToken buckName:model.bucket complete:^(NSArray<NSString *> *names, UploadImageState state) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (state == 1) {
                    
                    [Utils postMessage:@"图片上传成功" onView:self.view];
                    
                    self.imageS = names;
                    NSLog(@"%@",names);
                    NSLog(@"%@  %ld",self.imageS,state);
                    
                   updatemyfileHeader  *header = [[updatemyfileHeader alloc]init];
                    
                    header.target = @"assessmentControl";
                    
                    header.method = @"updateRecord";
                    
                    header.versioncode = Versioncode;
                    
                    header.devicenum = Devicenum;
                    
                    header.fromtype = Fromtype;
                    
                    header.token = [User LocalUser].token;
                    
                    updatemyfileBody *body = [[updatemyfileBody alloc]init];
                    
                    body.id = self.model.id;
                    
                    body.name = self.name.text;

                    body.sex= self.sex.text;

                    body.age= self.age.text;
                    
                    body.city= self.address.text;

                    body.rname= self.phone.text;
                    
                    UpdateRequest *request = [[UpdateRequest alloc]init];
                    
                    request.head = header;
                    
                    request.body = body;
                    
                    NSMutableArray *imageArray = [NSMutableArray array];
                    
                    for (NSString *image in self.imageS) {
                        
                        ImageModel *model1 = [[ImageModel alloc]init];
                        
                        model1.imagepath = [NSString stringWithFormat:@"http://%@.%@/%@",model.bucket,model.endpoint,image];
                        
                        [imageArray addObject:model1];
                        
                    }
                    
                    body.images = imageArray;
                    
                    NSLog(@"99%@",request);
                    
                    [self.sendapi sendPic:request.mj_keyValues.mutableCopy];
                    
                }else{
                    
                    [Utils postMessage:@"图片上传失败" onView:self.view];
                    
                }
            });
            
        }];
        
        
    }
    
    
    if (api == _sendapi) {
        
        [self.hub dismissAnimated:YES];
        
        [Utils postMessage:@"图片上传成功" onView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (api == _updateapi) {
        
        [Utils postMessage:@"更新成功" onView:self.view];

        [self.navigationController popViewControllerAnimated:YES];
        
    }



}


- (SelectTypeTableViewCell *)name {
    if (!_name) {
        _name = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_name setTypeName:@"姓名" placeholder:@"请输入姓名"];
    }
    return _name;
}

- (SelectTypeTableViewCell *)sex {
    if (!_sex) {
        _sex = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _sex.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_sex setTypeName:@"性别" placeholder:@"请选择性别"];
        [_sex setEditAble:NO];
        
    }
    return _sex;
}

- (SelectTypeTableViewCell *)age {
    if (!_age) {
        _age = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_age setTypeName:@"年龄" placeholder:@"请输入年龄"];
        
        _age.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _age;
}

- (SelectTypeTableViewCell *)phone {
    if (!_phone) {
        _phone = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_phone setTypeName:@"疾病" placeholder:@"请输入疾病"];
        
        _phone.textField.keyboardType = UIKeyboardTypeNamePhonePad;
    }
    return _phone;
}

- (SelectTypeTableViewCell *)address {
    if (!_address) {
        _address = [[SelectTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _address.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_address setEditAble:NO];
        [_address setTypeName:@"地址" placeholder:@"请选择地址"];
    }
    return _address;
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return 5;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return [self.dataArray safeObjectAtIndex:indexPath.row];
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    weakify(self);
  
    if (indexPath.row == 0) {
        
        
        
        
    }else if (indexPath.row == 1) {//选择地区
        
        self.selectSex = [[HClActionSheet alloc] initWithTitle:@"请选择性别" style:HClSheetStyleWeiChat itemTitles:@[@"男",@"女"]];
        
        self.selectSex.delegate = self;
        self.selectSex.tag = 60;
        self.selectSex.titleTextColor = DefaultBlackLightTextClor;
        self.selectSex.titleTextFont = Font(16);
        self.selectSex.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectSex.itemTextColor = DefaultGrayTextClor;
        self.selectSex.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectSex.cancleTextColor = DefaultGrayTextClor;
        [self.selectSex didFinishSelectIndex:^(NSInteger index, NSString *title) {
            
            strongify(self);
            
            self.sex.text = title;
            
        }];
        
        
        
    }else if (indexPath.row == 3) {//选择地区
        
        self.selectAddress = [[HClActionSheet alloc] initWithTitle:@"请选择城市" style:HClSheetStyleWeiChat itemTitles:self.cityList];
        
        self.selectAddress.delegate = self;
        self.selectAddress.tag = 60;
        self.selectAddress.titleTextColor = DefaultBlackLightTextClor;
        self.selectAddress.titleTextFont = Font(16);
        self.selectAddress.itemTextFont = [UIFont systemFontOfSize:16];
        self.selectAddress.itemTextColor = DefaultGrayTextClor;
        self.selectAddress.cancleTextFont = [UIFont systemFontOfSize:16];
        self.selectAddress.cancleTextColor = DefaultGrayTextClor;
        [self.selectAddress didFinishSelectIndex:^(NSInteger index, NSString *title) {
            
            strongify(self);
            
            CityModel *city = [self.citysArr objectAtIndex:index];
            
            self.address.text = title;
            
        }];
        
    }
}

-(void)toast:(NSString *)title
{
    //    int seconds = 3;
    //    [self toast:title seconds:seconds];
    [Utils showErrorMsg:self.view type:0 msg:title];
    
}


- (void)orderCommitAction{
    
//    
//    if (self.planid.length == 0) {
//        
//        [Utils postMessage:@"请选择套餐类型" onView:self.view];
//        return;
//    }
//    
//    if (self.cityid.length == 0) {
//        
//        [Utils postMessage:@"请选择城市" onView:self.view];
//        
//        return;
//    }
//    
//    if (self.name.text.length == 0) {
//        
//        [Utils postMessage:@"请输入姓名" onView:self.view];
//        
//        return;
//    }
//    
//    if (self.age.text.length == 0) {
//        
//        [Utils postMessage:@"请输入年龄" onView:self.view];
//        
//        return;
//    }
//    
//    if (self.sex.text.length == 0) {
//        
//        [Utils postMessage:@"请选择性性别" onView:self.view];
//        
//        return;
//    }
//    
//    if (self.phone.text.length == 0) {
//        
//        [Utils postMessage:@"请输入手机号" onView:self.view];
//        
//        return;
//    }
//    
//    NSError *error;
//    
//    if (![ValidatorUtil isValidMobile:self.phone.text error:&error]) {
//        
//        [self toast:[error localizedDescription]];
//        
//        return;
//    }
//    
//    
//    orderCommitHeader *commithead = [[orderCommitHeader alloc]init];
//    
//    commithead.target = @"orderControl";
//    
//    commithead.method = @"createOrder";
//    
//    commithead.versioncode = Versioncode;
//    
//    commithead.devicenum = Devicenum;
//    
//    commithead.fromtype = Fromtype;
//    
//    commithead.token = [User LocalUser].token;
//    
//    orderCommitBody *commitOrderbody = [[orderCommitBody alloc]init];
//    
//    commitOrderbody.planid = self.planid;
//    
//    commitOrderbody.cityid = self.cityid;
//    
//    commitOrderbody.patientname  = self.name.text;
//    
//    commitOrderbody.patientsex  = self.sex.text;
//    
//    commitOrderbody.patientage = self.age.text;
//    
//    commitOrderbody.patientphone = self.phone.text;
//    
//    OrderCommitRequest *cityrequest = [[OrderCommitRequest alloc]init];
//    
//    cityrequest.head = commithead;
//    
//    cityrequest.body = commitOrderbody;
//    
//    [self.ordercommitApi orderCommit:cityrequest.mj_keyValues.mutableCopy];
//    
//    
//    self.selectPay = [[HClActionSheet alloc] initWithTitle:@"请选择支付方式" style:HClSheetStyleWeiChat itemTitles:@[@"支付宝支付",@"微信支付"]];
//    
//    self.selectPay.delegate = self;
//    self.selectPay.tag = 200;
//    self.selectPay.titleTextColor = DefaultBlackLightTextClor;
//    self.selectPay.titleTextFont = Font(16);
//    self.selectPay.itemTextFont = [UIFont systemFontOfSize:16];
//    self.selectPay.itemTextColor = DefaultGrayTextClor;
//    self.selectPay.cancleTextFont = [UIFont systemFontOfSize:16];
//    self.selectPay.cancleTextColor = DefaultGrayTextClor;
//    
//    [self.selectPay didFinishSelectIndex:^(NSInteger index, NSString *title) {
//        
//        AliRequestHeader *head = [[AliRequestHeader alloc]init];
//        
//        head.target = @"generalControl";
//        
//        head.method = @"createAlipayOrder";
//        
//        head.versioncode = Versioncode;
//        
//        head.devicenum = Devicenum;
//        
//        head.fromtype = Fromtype;
//        
//        head.token = [User LocalUser].token;
//        
//        AliRequestBody *body = [[AliRequestBody alloc]init];
//        
//        body.orderid = self.orderModel.orderid;
//        
//        AlipayRequest *request = [[AlipayRequest alloc]init];
//        
//        request.head = head;
//        
//        request.body = body;
//        
//        NSLog(@"%@",request);
//        
//        [self.alipay getAliOrder:request.mj_keyValues.mutableCopy];
//        
//        
//    }];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (!section) ? 0.0001f : 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    sectionView.backgroundColor = [UIColor whiteColor];
    
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth, 20)];
    [sectionView addSubview:self.label];
    self.label.textColor = DefaultGrayTextClor;
    self.label.text = @"相关病例";
    self.label.backgroundColor = [UIColor whiteColor];
    addImgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.label.bottom, kScreenWidth, ImageWidth+20)];
    addImgView.backgroundColor = [UIColor whiteColor];
    [sectionView addSubview:addImgView];
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
    
    return sectionView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
 
        
        return 140.0f;
 
}


#pragma mark - 添加图片监听
- (void)addImage {
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
    
    if (imageArr.count<= 0) {
        
        return self.imagesss.count;
        
    }else{
    
        return imageArr.count;

    
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ImageWidth, ImageWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"myCell";
    CommentCell *cell = (CommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    if (imageArr.count <= 0) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesss[indexPath.row]]];
        
    }else{
    
        cell.imageView.image = imageArr[indexPath.row];

    
    }
    
    cell.cancelBtn.tag = indexPath.row;
    [cell.cancelBtn addTarget:self action:@selector(cancelImg:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 取消选择的图片
- (void)cancelImg:(UIButton *)btn {
    CommentCell *cell = (CommentCell *)btn.superview;
    NSIndexPath *indexPath = [collection indexPathForCell:cell];
    
    if (imageArr.count <=0) {
        
        [self.imagesss removeObjectAtIndex:indexPath.row];

    }else{
    
        [imageArr removeObjectAtIndex:indexPath.row];

    }
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
