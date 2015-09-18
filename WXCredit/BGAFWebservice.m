//
//  BGAFWebservice.m
//  WXCredit
//
//  Created by xiegf on 15/8/27.
//  Copyright (c) 2015年 ShengHongGroup. All rights reserved.
//

#import "BGAFWebservice.h"
#import "MsgString.h"

@implementation BGAFWebservice
static BGAFWebservice* _instance_ = nil;

+(id)sharedInstance{
    if(_instance_ == nil){
        _instance_ = [[BGAFWebservice alloc] initWebserviceCenter];
    }
    return _instance_;
}

-(instancetype)initWebserviceCenter {
    self = [super init];
    if (self) {
        self.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
        [self.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    }
    return self;
}

-(void)sendPostRequest:(NSString *)soapMessage
                  type:(int)type
               success:(void (^)(AFHTTPRequestOperation *, id))success
               failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
    [self.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapMessage;
    }];
    
    NSString *url;
    if (type == 0) {
        url = ACCOUNT_URL;
    } else if (type == 1) {
        url = CUSTOMER_URL;
    } else {
        url = MESSAGE_URL;
    }
    [self POST:url parameters:soapMessage success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        success(operation, [MsgString getDictionaryFrom:response]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@, %@", operation, error);
    }];
}

@end
