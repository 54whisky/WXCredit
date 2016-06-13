//
//  LoginVC.m
//  WXCredit
//
//  Created by xiegf on 15/8/26.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "CenterVC.h"
#import "ResetPasswordVC.h"
#import "MsgString.h"
#import "BGAFWebservice.h"
#import "User.h"
#import "SVProgressHUD.h"

@interface LoginVC ()

@property (nonatomic, weak) IBOutlet UIImageView *bgView;
@property (nonatomic, weak) IBOutlet UITextField *accountTxtField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTxtField;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 初始化
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBgImg:)];
    recognizer.numberOfTapsRequired = 1;
    [_bgView addGestureRecognizer:recognizer];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *loginInfo = [defaults objectForKey:@"LOGIN_INFO"];
    if (loginInfo) {
        _accountTxtField.text = [loginInfo objectForKey:@"strPhone"];
        _passwordTxtField.text = [loginInfo objectForKey:@"strPwd"];
        [self loginBtnClick:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBgImg:(UITapGestureRecognizer*)recognizer {
    if ([_accountTxtField isFirstResponder]) {
        [_accountTxtField resignFirstResponder];
    } else if ([_passwordTxtField isFirstResponder]) {
        [_passwordTxtField resignFirstResponder];
    }
}

- (IBAction)registerBtnClick:(id)sender {
    RegisterVC *registerVC = (RegisterVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self presentViewController:registerVC animated:YES completion:nil];
}

- (IBAction)resetPswBtnClick:(id)sender {
    ResetPasswordVC *resetVC = (ResetPasswordVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetPasswordVC"];
    [self presentViewController:resetVC animated:YES completion:nil];
}

-(IBAction)loginBtnClick:(id)sender {
    NSString *account = _accountTxtField.text;
    NSString *password = _passwordTxtField.text;
    
    NSDictionary *param = @{@"strPhone":account, @"strPwd":password};
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:param forKey:@"LOGIN_INFO"];
    [defaults synchronize];
    
    NSString *soapMessage = [MsgString getXMLStringFrom:param with:@"Login"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            NSDictionary *returnJson = [responseObject objectForKey:@"ResultJson"];
            User *curUser = [User shareInstance];
            curUser.CU_NAME = [returnJson objectForKey:@"CU_NAME"];
            curUser.CU_PHONE = [returnJson objectForKey:@"CU_PHONE"];
            curUser.CU_GUID = [returnJson objectForKey:@"CU_GUID"];
            [SVProgressHUD showErrorWithStatus:@"登录成功"];
            
            CenterVC *centerVC = (CenterVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CenterVC"];
            [self presentViewController:centerVC animated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"ErrMsg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
    
//    NSString *soapMessage = [MsgString getXMLStringFrom:param with:@"Login"];
//    @"<?xml version=\"1.0\" encoding=\"utf-8\"?> \n"
//    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">"
//    "<soap12:Body>"
//    "<Login xmlns=\"http://nearfull.com/\">"
//    "<strPhone>13305140284</strPhone>"
//    "<strPwd>12345678</strPwd>"
//    "</Login>"
//    "</soap12:Body>"
//    "</soap12:Envelope>";

//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//        return soapMessage;
//    }];
//    [manager POST:@"http://www.nearfull.com:9000/ws/v1/Account.asmx" parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@, %@", operation, response);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
//        NSLog(@"%@, %@", operation, error);
//    }];
    //{"__type":"AccountInfo:#wxxd.Ecl","CU_GUID":"DA185D461056F2D8","CU_NAME":"whisky","CU_PHONE":"13305140284"}
}

@end
