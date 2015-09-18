//
//  PersonInfoVC.m
//  WXCredit
//
//  Created by xiegf on 15/9/4.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "PersonInfoVC.h"
#import "myPickerView.h"
#import "User.h"
#import "MsgString.h"
#import "BGAFWebservice.h"
#import "SVProgressHUD.h"
#import "UploadCell.h"
#import "BGUtility.h"

@interface PersonInfoVC ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    //下拉菜单
    UIActionSheet *myActionSheet;
}

// top View
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 借款信息
@property (weak, nonatomic) IBOutlet UIView *loanInfoView;
@property (weak, nonatomic) IBOutlet UITextField *loanValue;
@property (weak, nonatomic) IBOutlet UITextField *loanPer;
@property (weak, nonatomic) IBOutlet UILabel *loanUse;
@property (weak, nonatomic) IBOutlet UILabel *loanLimit;

// 个人信息
@property (weak, nonatomic) IBOutlet UIView *personInfoView;
@property (weak, nonatomic) IBOutlet UITextField *personIDNum;
@property (weak, nonatomic) IBOutlet UITextField *personPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *personHouseNum;
@property (weak, nonatomic) IBOutlet UILabel *personIncome;
//@property (weak, nonatomic) IBOutlet UILabel *personHouse;
@property (weak, nonatomic) IBOutlet UILabel *personMarital;
@property (weak, nonatomic) IBOutlet UILabel *personEducation;
@property (weak, nonatomic) IBOutlet UILabel *personDomicile;

// 联系人信息
@property (weak, nonatomic) IBOutlet UIView *contactsInfoView;
@property (weak, nonatomic) IBOutlet UILabel *ccRelation1;
@property (weak, nonatomic) IBOutlet UITextField *ccPhoneNum1;
@property (weak, nonatomic) IBOutlet UITextField *ccName1;
@property (weak, nonatomic) IBOutlet UILabel *ccRelation2;
@property (weak, nonatomic) IBOutlet UITextField *ccPhoneNum2;
@property (weak, nonatomic) IBOutlet UITextField *ccName2;

// 资料上传
@property (weak, nonatomic) IBOutlet UIView *uploadView;
@property (weak, nonatomic) IBOutlet UITableView *imgTableView;

@property (nonatomic, strong) NSArray *selectViewArray;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *pickerDataArray;
@property (nonatomic, strong) NSMutableArray *uploadImgArray;
@property (nonatomic, assign) NSUInteger curEditImgIdx;

@end

@implementation PersonInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectViewArray = @[_loanUse,_loanLimit,_personIncome,_personMarital,_personEducation,_personDomicile,_ccRelation1,_ccRelation2];
    _dataArray = @[@[@"买房",@"买车",@"装修",@"其他"],
                   @[@"半年",@"一年",@"两年",@"三年",@"四年",@"更多"],
                   @[@"3-5万",@"6-10万",@"11-15万",@"15万以上"],
                   @[@"已婚",@"未婚"],
                   @[@"小学",@"初中",@"高中",@"专科",@"本科",@"硕士",@"博士",@"博士后"],
                   @[@"上海市",@"江苏南京",@"江苏无锡",@"江苏镇江",@"江苏苏州",@"江苏南通",@"江苏扬州",@"江苏盐城",@"江苏徐州",@"江苏淮安",@"江苏连云港",@"江苏常州",@"江苏泰州",@"江苏宿迁",@"浙江杭州",@"浙江湖州",@"浙江嘉兴",@"浙江宁波",@"浙江绍兴",@"浙江台州",@"浙江温州",@"浙江丽水",@"浙江金华",@"浙江衢州",@"浙江舟山"],
                   @[@"家人",@"朋友",@"亲人",@"同学",@"同事"],
                   @[@"家人",@"朋友",@"亲人",@"同学",@"同事"]];
    
    [self showViewForCurIdx];
}

-(void)showViewForCurIdx {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBgView:)];
    recognizer.numberOfTapsRequired = 1;
    User *curUser = [User shareInstance];
    switch (_curIdx) {
        case 0:
            _loanInfoView.hidden = NO;
            _personInfoView.hidden = YES;
            _contactsInfoView.hidden = YES;
            _uploadView.hidden = YES;
            
            [_loanInfoView addGestureRecognizer:recognizer];
            _titleLabel.text = @"借款信息";
            _loanUse.text = curUser.LOAN_USE;
            _loanValue.text = curUser.LOAN_VALUE;
            _loanLimit.text = curUser.LOAN_LIMIT;
            _loanPer.text = curUser.LOAN_PER;
            break;
        case 1:
            _loanInfoView.hidden = YES;
            _personInfoView.hidden = NO;
            _contactsInfoView.hidden = YES;
            _uploadView.hidden = YES;
            
            [_personInfoView addGestureRecognizer:recognizer];
            _titleLabel.text = @"个人信息";
            _personIDNum.text = curUser.ID_NUMBER;
            _personPhoneNum.text = curUser.CU_PHONE;
            _personIncome.text = curUser.ANNUAL_INCOME;
//            _personHouse.text = curUser.HOURSE_STATE;
            _personHouseNum.text = curUser.HOURSE_CARD;
            _personMarital.text = curUser.MARITAL_STATE;
            _personEducation.text = curUser.HIGHTEST_EDU;
            _personDomicile.text = curUser.DOMICILE;
            break;
        case 2:
            _loanInfoView.hidden = YES;
            _personInfoView.hidden = YES;
            _contactsInfoView.hidden = NO;
            _uploadView.hidden = YES;
            
            [_contactsInfoView addGestureRecognizer:recognizer];
            _titleLabel.text = @"联系人信息";
            _ccName1.text = curUser.CC_NAME1;
            _ccName2.text = curUser.CC_NAME2;
            _ccPhoneNum1.text = curUser.CC_PHONE1;
            _ccPhoneNum2.text = curUser.CC_PHONE2;
            _ccRelation1.text = curUser.CC_RELATION1;
            _ccRelation2.text = curUser.CC_RELATION2;
            break;
            
        default:
            _loanInfoView.hidden = YES;
            _personInfoView.hidden = YES;
            _contactsInfoView.hidden = YES;
            _uploadView.hidden = NO;
            
            _titleLabel.text = @"资料上传";
            
            _uploadImgArray = [NSMutableArray arrayWithArray:
                               @[@{@"type":@"IDZ", @"name":@"身份证正面", @"url":@"", @"filePath":@"", @"isEdit":@"0"},
                                 @{@"type":@"IDF", @"name":@"身份证背面", @"url":@"", @"filePath":@"", @"isEdit":@"0"},
                                 @{@"type":@"FCZ", @"name":@"房产证", @"url":@"", @"filePath":@"", @"isEdit":@"0"},
                                 @{@"type":@"TDZ", @"name":@"土地证", @"url":@"", @"filePath":@"", @"isEdit":@"0"},
                                 @{@"type":@"HKB", @"name":@"户口本", @"url":@"", @"filePath":@"", @"isEdit":@"0"},
                                 @{@"type":@"JHZ", @"name":@"结婚证", @"url":@"", @"filePath":@"", @"isEdit":@"0"},
                                 @{@"type":@"ZXZ", @"name":@"个人征信", @"url":@"", @"filePath":@"", @"isEdit":@"0"}]];
            
            [self getUploadImages];
            break;
    }
}

-(void)touchBgView:(UITapGestureRecognizer*)recognizer {
    if (_curIdx == 0) {
        if ([_loanValue isFirstResponder]) {
            [_loanValue resignFirstResponder];
        } else if ([_loanPer isFirstResponder]) {
            [_loanPer resignFirstResponder];
        }
    } else if (_curIdx == 1) {
        if ([_personIDNum isFirstResponder]) {
            [_personIDNum resignFirstResponder];
        } else if ([_personHouseNum isFirstResponder]) {
            [_personHouseNum resignFirstResponder];
        }
    } else if (_curIdx == 2) {
        if ([_ccName1 isFirstResponder]) {
            [_ccName1 resignFirstResponder];
        } else if ([_ccName2 isFirstResponder]) {
            [_ccName2 resignFirstResponder];
        } else if ([_ccPhoneNum1 isFirstResponder]) {
            [_ccPhoneNum1 resignFirstResponder];
        } else if ([_ccPhoneNum2 isFirstResponder]) {
            [_ccPhoneNum2 resignFirstResponder];
        }
    }
}

- (IBAction)selectBtnClick:(id)sender {
    [self touchBgView:nil];
    
    myPickerView *pickerView = [[myPickerView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT-250, MAINSCREEN_WIDTH, 250) with:[_dataArray objectAtIndex:[sender tag]] for:[_selectViewArray objectAtIndex:[sender tag]]];
    [self.view addSubview:pickerView];
}

- (IBAction)saveBtnClick:(id)sender {
    User *curUser = [User shareInstance];
    NSDictionary *param;
    NSString *apiName;
    if (_curIdx == 0) {
        curUser.LOAN_USE = _loanUse.text;
        curUser.LOAN_VALUE = _loanValue.text;
        curUser.LOAN_LIMIT = _loanLimit.text;
        curUser.LOAN_PER = _loanPer.text;
        param = @{@"strCuGuid":curUser.CU_GUID,@"strLoanUse":curUser.LOAN_USE,@"decLoanValue":curUser.LOAN_VALUE,@"strLoanLimit":curUser.LOAN_LIMIT,@"decLoanPer":curUser.LOAN_PER};
        apiName = @"UpdLoanInfo";
    } else if (_curIdx == 1) {
        curUser.ID_NUMBER = _personIDNum.text;
        curUser.ANNUAL_INCOME = _personIncome.text;
        curUser.HOURSE_CARD = _personHouseNum.text;
        curUser.MARITAL_STATE = _personMarital.text;
        curUser.HIGHTEST_EDU = _personEducation.text;
        curUser.DOMICILE = _personDomicile.text;
        param = @{@"strCuGuid":curUser.CU_GUID,@"strIdNumber":curUser.ID_NUMBER,@"strQQ":curUser.CU_QQ,@"decIncome":curUser.ANNUAL_INCOME,@"strHourse":curUser.HOURSE_STATE,@"strHourseCard":curUser.HOURSE_CARD,@"strMarital":curUser.MARITAL_STATE,@"strEducation":curUser.HIGHTEST_EDU,@"strDomicile":curUser.DOMICILE};
        apiName = @"UpdBasicInfo";
    } else if (_curIdx == 2) {
        curUser.CC_NAME1 = _ccName1.text;
        curUser.CC_NAME2 = _ccName2.text;
        curUser.CC_PHONE1 = _ccPhoneNum1.text;
        curUser.CC_PHONE2 = _ccPhoneNum2.text;
        curUser.CC_RELATION1 = _ccRelation1.text;
        curUser.CC_RELATION2 = _ccRelation2.text;
        param = @{@"strCuGuid":curUser.CU_GUID,@"strName1":curUser.CC_NAME1,@"strPhone1":curUser.CC_PHONE1,@"strRelation1":curUser.CC_RELATION1,@"strName2":curUser.CC_NAME2,@"strPhone2":curUser.CC_PHONE2,@"strRelation2":curUser.CC_RELATION2};
        apiName = @"UpdConstact";
    } else {
        [self uploadImages];
        return;
    }
    
    NSString *soapMessage = [MsgString getXMLStringFrom:param with:apiName];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            [SVProgressHUD showErrorWithStatus:@"更新成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"更新失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 借款信息

#pragma mark- 个人信息

#pragma mark- 联系人信息

#pragma mark- 资料上传
-(void)getUploadImages {
    User *curUser = [User shareInstance];
    NSString *soapMessage = [MsgString getXMLStringFrom:@{@"strCuGuid":curUser.CU_GUID} with:@"GetImgUrl"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    __weak PersonInfoVC *weakSelf = self;
    [webService sendPostRequest:soapMessage type:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            NSArray *result = [responseObject objectForKey:@"ResultJson"];
            [weakSelf dealImages:result];
        } else {
            NSLog(@"获取图片信息失败 -- %@",[responseObject objectForKey:@"ErrMsg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

-(void)dealImages:(NSArray*)result {
    for (NSDictionary *resDic in result) {
        NSString *type = [resDic objectForKey:@"IMAGE_TYPE"];
        NSString *imgUrl = [resDic objectForKey:@"IMAGE_URL"];
        if (![imgUrl isEqualToString:@""]) {
            imgUrl = [BASE_URL stringByAppendingPathComponent:imgUrl];
        }
        for (int i=0; i<_uploadImgArray.count; i++) {
            NSMutableDictionary *dataDic = [_uploadImgArray[i] mutableCopy];
            if ([[dataDic objectForKey:@"type"] isEqualToString:type]) {
                [dataDic setObject:imgUrl forKey:@"url"];
                [_uploadImgArray replaceObjectAtIndex:i withObject:dataDic];
            }
        }
    }
    [_imgTableView reloadData];
}

#pragma mark-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_curIdx == 3) {
        return _uploadImgArray.count;
    } else {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 190;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentify = @"UploadCell";
    UploadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"UploadCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentify];
        cell = (UploadCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    }
    
    [cell fillData:[_uploadImgArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _curEditImgIdx = indexPath.row;
    [self openMenu];
}

-(void)openMenu
{
    //在这里呼出下方菜单按钮项
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
    
    [myActionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"]; // 获取裁剪过后的图片UIImagePickerControllerEditedImage
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSMutableDictionary *imgInfo = [_uploadImgArray objectAtIndex:_curEditImgIdx];
        //得到选择后沙盒中图片的完整路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",[BGUtility getUserRootPath],[imgInfo objectForKey:@"type"]];
        [fileManager createFileAtPath:filePath contents:data attributes:nil];
        
//        [imgInfo setValue:@"" forKey:@"url"];
        [imgInfo setValue:filePath forKey:@"filePath"];
        [imgInfo setValue:@"1" forKey:@"isEdit"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        [_imgTableView reloadData];
        
//        //创建一个选择后图片的小图标放在下方
//        //类似微薄选择图后的效果
//        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 120, 40, 40)];
//        
//        smallimage.image = image;
//        //加在视图中
//        [self.view addSubview:smallimage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadImages {
    for (int i=0; i<_uploadImgArray.count; i++) {
        NSMutableDictionary *infoDic = [_uploadImgArray[i] mutableCopy];
        
        if ([[infoDic objectForKey:@"isEdit"] isEqualToString:@"1"])
        {
            User *curUser = [User shareInstance];
            NSData* fileData = [NSData dataWithContentsOfFile:[infoDic objectForKey:@"filePath"]];
            NSString *fileDataStr = [fileData base64Encoding];
            NSDictionary *param = @{@"strCuGuid":curUser.CU_GUID,@"byteImage":fileDataStr,@"strImgType":[infoDic objectForKey:@"type"],@"strImgExt":@".png"};
            
            NSString *soapMessage = [MsgString getXMLStringFrom:param with:@"UploadFile"];
            BGAFWebservice *webService = [BGAFWebservice sharedInstance];
//            __weak PersonInfoVC *weakSelf = self;
            __weak NSMutableDictionary *weakDic = infoDic;
            [webService sendPostRequest:soapMessage type:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@", responseObject);
                if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
                    // 上传成功
                    NSDictionary *result = [responseObject objectForKey:@"ResultJson"];
                    NSString *imgUrl = [BASE_URL stringByAppendingPathComponent:[result objectForKey:@"IMAGE_URL"]];
                    [weakDic setValue:imgUrl forKey:@"url"];
                    [weakDic setValue:@"" forKey:@"filePath"];
                    [weakDic setValue:@"0" forKey:@"isEdit"];
                    [SVProgressHUD showSuccessWithStatus:@"图片保存成功！"];
                } else {
                    // 上传失败
                    NSLog(@"上传图片失败 -- %@",[responseObject objectForKey:@"ErrMsg"]);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@, %@", operation, error);
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
