//
//  NewsDetailVC.m
//  WXCredit
//
//  Created by xiegf on 15/9/4.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "NewsDetailVC.h"
#import "BGAFWebservice.h"
#import "BGUtility.h"
#import "MsgString.h"

@interface NewsDetailVC ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation NewsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getNewsDetail];
}

- (IBAction)backBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getNewsDetail {
    NSString *soapMessage = [MsgString getXMLStringFrom:@{@"strMsgGuid":_msgID} with:@"GetNewsInfo"];
    BGAFWebservice *webService = [BGAFWebservice sharedInstance];
    [webService sendPostRequest:soapMessage type:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSString *contentStr;
        if ([[responseObject objectForKey:@"ReturnBool"] intValue] == 1) {
            NSDictionary *returnJson = [responseObject objectForKey:@"ResultJson"];
            _titleLabel.text = [returnJson objectForKey:@"MSG_TITLE"];
            _dateLabel.text = [BGUtility getDateStrFromDB:[returnJson objectForKey:@"MSG_TIME"]];
            contentStr = [returnJson objectForKey:@"MSG_CONTENT"];
        } else {
            contentStr = [responseObject objectForKey:@"ErrMsg"];
        }
        
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [_webView loadHTMLString:contentStr baseURL:baseURL];
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
