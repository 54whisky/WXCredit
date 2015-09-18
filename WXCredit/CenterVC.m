//
//  CenterVC.m
//  WXCredit
//
//  Created by xiegf on 15/8/29.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "CenterVC.h"
#import "PersonInfoVC.h"
#import "NewsDetailVC.h"
#import "User.h"
#import "MsgString.h"
#import "BGAFWebservice.h"
#import "SVProgressHUD.h"
#import "NewsCell.h"

#define THIMB_COLOR RGBColor(61, 172, 219)

@interface CenterVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
// 底部菜单
@property (weak, nonatomic) IBOutlet UIButton *personCenterBtn;
@property (weak, nonatomic) IBOutlet UIView *personCenterBtnBackView;
@property (weak, nonatomic) IBOutlet UIButton *newsCenterBtn;
@property (weak, nonatomic) IBOutlet UIView *newsCenterBtnBackView;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;
@property (weak, nonatomic) IBOutlet UIView *companyBtnBackView;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;
@property (weak, nonatomic) IBOutlet UIView *feedbackBtnBackView;

// 个人中心
@property (weak, nonatomic) IBOutlet UIView *personCenterView;
@property (weak, nonatomic) IBOutlet UIImageView *personImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loanBtn;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactsBtn;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

// 信息中心
@property (weak, nonatomic) IBOutlet UIView *newsCenterView;
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;

// 公司简介
@property (weak, nonatomic) IBOutlet UIView *companyView;
@property (weak, nonatomic) IBOutlet UIWebView *profileView;

// 留言反馈
@property (weak, nonatomic) IBOutlet UIView *feedbackView;
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;

@property (strong, nonatomic) NSArray *viewArray;
@property (strong, nonatomic) NSArray *newsArray;

@end

@implementation CenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 底部菜单
    [_personCenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_personCenterBtn setTitleColor:THIMB_COLOR forState:UIControlStateSelected];
    [_personCenterBtn setImage:[UIImage imageNamed:@"personCenterIcon_n.png"] forState:UIControlStateNormal];
    [_personCenterBtn setImage:[UIImage imageNamed:@"personCenterIcon_s.png"] forState:UIControlStateSelected];
    
    [_newsCenterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_newsCenterBtn setTitleColor:THIMB_COLOR forState:UIControlStateSelected];
    [_newsCenterBtn setImage:[UIImage imageNamed:@"newsCenterIcon_n.png"] forState:UIControlStateNormal];
    [_newsCenterBtn setImage:[UIImage imageNamed:@"newsCenterIcon_s.png"] forState:UIControlStateSelected];
    
    [_companyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_companyBtn setTitleColor:THIMB_COLOR forState:UIControlStateSelected];
    [_companyBtn setImage:[UIImage imageNamed:@"companyIcon_n.png"] forState:UIControlStateNormal];
    [_companyBtn setImage:[UIImage imageNamed:@"companyIcon_s.png"] forState:UIControlStateSelected];
    
    [_feedbackBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_feedbackBtn setTitleColor:THIMB_COLOR forState:UIControlStateSelected];
    [_feedbackBtn setImage:[UIImage imageNamed:@"feedbackIcon_n.png"] forState:UIControlStateNormal];
    [_feedbackBtn setImage:[UIImage imageNamed:@"feedbackIcon_s.png"] forState:UIControlStateSelected];
    
    // 个人中心
    User *curUser = [User shareInstance];
    _nameLabel.text = curUser.CU_NAME;
    
    
    _viewArray = @[@[_personCenterView, _personCenterBtn, _personCenterBtnBackView], @[_newsCenterView, _newsCenterBtn, _newsCenterBtnBackView], @[_companyView, _companyBtn, _companyBtnBackView], @[_feedbackView, _feedbackBtn, _feedbackBtnBackView]];
    
    [self selectMenu:0];
    [self getUserInfo];
    [self getNewsList];
    [self getProfile];
}

-(void)getUserInfo {
    User *curUser = [User shareInstance];
    NSString *soapMessage = [MsgString getXMLStringFrom:@{@"strCuGuid":curUser.CU_GUID} with:@"GetCustomerInfo"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            NSDictionary *returnJson = [responseObject objectForKey:@"ResultJson"];
            curUser.ID_NUMBER = [returnJson objectForKey:@"ID_NUMBER"];
            curUser.CU_QQ = [returnJson objectForKey:@"CU_QQ"];
            curUser.ANNUAL_INCOME = [returnJson objectForKey:@"ANNUAL_INCOME"];
            curUser.HOURSE_STATE = [returnJson objectForKey:@"HOURSE_STATE"];
            curUser.HOURSE_CARD = [returnJson objectForKey:@"HOURSE_CARD"];
            curUser.MARITAL_STATE = [returnJson objectForKey:@"MARITAL_STATE"];
            curUser.HIGHTEST_EDU = [returnJson objectForKey:@"HIGHTEST_EDU"];
            curUser.DOMICILE = [returnJson objectForKey:@"DOMICILE"];
            curUser.CC_NAME1 = [returnJson objectForKey:@"CC_NAME1"];
            curUser.CC_PHONE1 = [returnJson objectForKey:@"CC_PHONE1"];
            curUser.CC_RELATION1 = [returnJson objectForKey:@"CC_RELATION1"];
            curUser.CC_NAME2 = [returnJson objectForKey:@"CC_NAME2"];
            curUser.CC_PHONE2 = [returnJson objectForKey:@"CC_PHONE2"];
            curUser.CC_RELATION2 = [returnJson objectForKey:@"CC_RELATION2"];
            curUser.LOAN_USE = [returnJson objectForKey:@"LOAN_USE"];
            curUser.LOAN_VALUE = [NSString stringWithFormat:@"%.1f",[[returnJson objectForKey:@"LOAN_VALUE"] doubleValue]];
            curUser.LOAN_LIMIT = [returnJson objectForKey:@"LOAN_LIMIT"];
            curUser.LOAN_PER = [NSString stringWithFormat:@"%.1f",[[returnJson objectForKey:@"LOAN_PER"] doubleValue]];
            
            if ([curUser.ID_NUMBER isEqualToString:@""] || [curUser.HOURSE_CARD isEqualToString:@""]) {
                [SVProgressHUD showInfoWithStatus:@"信息未完善，请完善个人信息"];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"个人信息获取失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

-(void)getNewsList {
    NSString *soapMessage = [MsgString getXMLStringFrom:@{@"strVer":@"v1"} with:@"GetNewsList"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            _newsArray = [responseObject objectForKey:@"ResultJson"];
            [_newsTableView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"ErrMsg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

-(void)getProfile {
    NSString *soapMessage = [MsgString getXMLStringFrom:@{@"strVer":@"v1"} with:@"GetProfile"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSString *profileStr;
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            NSDictionary *returnJson = [responseObject objectForKey:@"ResultJson"];
            profileStr = [returnJson objectForKey:@"MSG_CONTENT"];
        } else {
            profileStr = [responseObject objectForKey:@"ErrMsg"];
        }
        
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [_profileView loadHTMLString:profileStr baseURL:baseURL];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

- (IBAction)menuBtnClick:(id)sender {
    [self selectMenu:[sender tag]];
}

-(void)selectMenu:(NSInteger)idx {
    for (int i=0; i<_viewArray.count; i++) {
        UIView *menuView = (UIView*)[[_viewArray objectAtIndex:i] objectAtIndex:0];
        UIButton *menuBtn = (UIButton*)[[_viewArray objectAtIndex:i] objectAtIndex:1];
        UIView *btnBackView = (UIView*)[[_viewArray objectAtIndex:i] objectAtIndex:2];
        
        if (i==idx) {
            menuView.hidden = NO;
            [menuBtn setSelected:YES];
            [btnBackView setBackgroundColor:RGBColor(241, 241, 241)];
            
            if (idx == 0) {
                _topView.backgroundColor = [UIColor clearColor];
            } else {
                _topView.backgroundColor = THIMB_COLOR;
            }
        } else {
            menuView.hidden = YES;
            [menuBtn setSelected:NO];
            [btnBackView setBackgroundColor:THIMB_COLOR];
        }
    }
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 个人中心
- (IBAction)enterPersonInfo:(id)sender {
    PersonInfoVC *personVC = (PersonInfoVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonInfoVC"];
    personVC.curIdx = (int)[sender tag];
    [self presentViewController:personVC animated:YES completion:nil];
}

#pragma mark- 信息中心
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentify = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        UINib *nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentify];
        cell = (NewsCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    }
    
    NSDictionary *msgData = [_newsArray objectAtIndex:indexPath.row];
    NSDictionary *newsInfo = @{@"title":[msgData objectForKey:@"MSG_TITLE"],@"date":[msgData objectForKey:@"MSG_TIME"]};
    [cell fillData:newsInfo];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *msgData = [_newsArray objectAtIndex:indexPath.row];
    NewsDetailVC *detailVC = (NewsDetailVC*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsDetailVC"];
    detailVC.msgID = [msgData objectForKey:@"MSG_GUID"];
    [self presentViewController:detailVC animated:YES completion:nil];
}

#pragma mark- 公司简介

#pragma mark- 留言反馈
- (IBAction)sendFeedBackMsg:(id)sender {
    NSDictionary *param = @{@"strCuGuid":[[User shareInstance] CU_GUID], @"strContent":_feedbackTextView.text};
    NSString *soapMessage = [MsgString getXMLStringFrom:param with:@"UpdFeedback"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"提交失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
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
