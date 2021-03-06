//
//  RegisterVC.m
//  WXCredit
//
//  Created by xiegf on 15/8/27.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "RegisterVC.h"
#import "BGUtility.h"
#import "BGAFWebservice.h"
#import "SVProgressHUD.h"
#import "MsgString.h"

@interface RegisterVC ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneTxtField;
@property (nonatomic, weak) IBOutlet UITextField *nameTxtField;
@property (nonatomic, weak) IBOutlet UITextField *pswTxtField;
@property (nonatomic, weak) IBOutlet UITextField *enPswTxtField;
@property (nonatomic, weak) IBOutlet UITextField *qAnswerTxtField;

@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView:)];
    recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchView:(UITapGestureRecognizer*)recognizer {
    if ([_phoneTxtField isFirstResponder]) {
        [_phoneTxtField resignFirstResponder];
    } else if ([_nameTxtField isFirstResponder]) {
        [_nameTxtField resignFirstResponder];
    } else if ([_pswTxtField isFirstResponder]) {
        [_pswTxtField resignFirstResponder];
    } else if ([_enPswTxtField isFirstResponder]) {
        [_enPswTxtField resignFirstResponder];
    } else if ([_qAnswerTxtField isFirstResponder]) {
        [_qAnswerTxtField resignFirstResponder];
    }
}

- (IBAction)registerBtnClick {
    NSString *phoneStr = _phoneTxtField.text;
    if (![BGUtility isValidateMobile:phoneStr]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确，请重新输入"];
        [_phoneTxtField becomeFirstResponder];
        return;
    }
    
    NSString *nameStr = [_nameTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *pswStr = _pswTxtField.text;
    if (pswStr.length != 8) {
        [SVProgressHUD showErrorWithStatus:@"密码只能为8位数字"];
        _pswTxtField.text = @"";
        [_pswTxtField becomeFirstResponder];
        return;
    }
    
    NSString *enPswStr = _enPswTxtField.text;
    if (![enPswStr isEqualToString:pswStr]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致，请重新输入"];
        _pswTxtField.text = @"";
        _enPswTxtField.text = @"";
        [_pswTxtField becomeFirstResponder];
        return;
    }
    
    NSString *qAnswerStr = [_qAnswerTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (qAnswerStr.length != 4) {
        [SVProgressHUD showErrorWithStatus:@"请输入身份证号后四位作为验证问题"];
        _qAnswerTxtField.text = @"";
        [_qAnswerTxtField becomeFirstResponder];
        return;
    } else {
        BOOL res = YES;
        for (int i=0; i<4; i++) {
            char num = [qAnswerStr characterAtIndex:i];
            if (i<3 && (num < '0' || num > '9')) {
                res = NO;
                break;
            } else if (i==3 && (num < '0' || num > '9') && (num != 'x' || num != 'X')) {
                res = NO;
            }
        }
        
        if (!res) {
            [SVProgressHUD showErrorWithStatus:@"身份证号后四位输入有误，请重新输入"];
            _qAnswerTxtField.text = @"";
            [_qAnswerTxtField becomeFirstResponder];
            return;
        }
    }
    
    NSDictionary *param = @{@"strPhone":phoneStr, @"strName":nameStr, @"strPwd":pswStr, @"strVerifyQuestion":qAnswerStr};
    NSString *soapMessage = [MsgString getXMLStringFrom:param with:@"RegisterAccount"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            [SVProgressHUD showInfoWithStatus:@"注册成功！"];
            [self returnBtnClick];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

- (IBAction)returnBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTxtField) {
        [_nameTxtField resignFirstResponder];
        [_pswTxtField becomeFirstResponder];
    }
    return YES;
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
