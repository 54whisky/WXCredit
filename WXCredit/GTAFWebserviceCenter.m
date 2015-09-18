//
//  GTAFWebserviceCenter.m
//  GTKit
//
//  Created by 高达 on 14-8-20.
//  Copyright (c) 2014年 wisesz. All rights reserved.
//

#import "GTAFWebserviceCenter.h"
#import "AFHTTPRequestOperationManager.h"
#import "SVProgressHUD.h"

#define NVS_SERVER_IP @"http://www.nearfull.com:9000/"

@interface GTAFWebserviceCenter(){
    __strong AFHTTPRequestOperation* currentRequest;
    __strong NSMutableArray* _suspendBlockQueue;
    BOOL _isPopLogin;
    __strong NSURL* _requestBaseUrl;
}
@end

@implementation GTAFWebserviceCenter
static GTAFWebserviceCenter* _instance_ = nil;

+(id)sharedInstance{
    if(_instance_ == nil){
        _instance_ = [[GTAFWebserviceCenter alloc] initWebserviceCenter];
    }
    return _instance_;
}

-(id)initWebserviceCenter{
    self = [super initWithBaseURL:[NSURL URLWithString:NVS_SERVER_IP]];
    if(self){
        _suspendBlockQueue = [NSMutableArray array];
//        [self setDefaultHeader:@"content-type" value:@"application/json"];
        
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
        AFJSONResponseSerializer* jsonSerializer = [AFJSONResponseSerializer serializer];
        jsonSerializer.removesKeysWithNullValues = YES;
        self.responseSerializer = jsonSerializer;
        self.responseSerializer.stringEncoding = NSUTF8StringEncoding;
        self.securityPolicy.allowInvalidCertificates = YES;
        [self.reachabilityManager startMonitoring];
        _isPopLogin = NO;
    }
    return self;
}

// 这里修改了AFNetworking的属性,baseURL本来为readonly
-(void)setRequestBaseUrl:(NSURL*)url{
    if ([[url path] length] > 0 && ![[url absoluteString] hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    if(![url.absoluteString isEqualToString:self.baseURL.absoluteString]){
        _requestBaseUrl = url;
    }
}

// 发送GET请求
- (void)sendGetRequest:(NSString *)path
        parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self GET:[self getFullRequestPath:path]
                    parameters:parameters
                       success:success
                       failure:failure];
}

// 发送POST请求
- (void)sendPostRequest:(NSString *)path
         parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    void (^systemFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error){
        switch (error.code) {
            case -999:
                // 请求被手动取消
                break;
            case -1004:
                // 连接不上服务器
//                [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
                break;
            default:
//                [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
                break;
        }
        if(failure){
            failure(operation,error);
        }
    };

    @try {
    [self POST:[self getFullRequestPath:path]
                        parameters:parameters
                        success:success
                        failure:systemFailureBlock];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
}

// 发送带文件数据的请求
- (void)sendPostRequest:(NSString *)path
             parameters:(NSDictionary *)parameters
                constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    @try {
        [self POST:[self getFullRequestPath:path]
                parameters:parameters
                constructingBodyWithBlock:block
                success:success
                failure:failure];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
    }
    @finally {
    }
}

-(NSString*)getFullRequestPath:(NSString*)path{
    if(_requestBaseUrl && ![path hasPrefix:@"http"]){
        path = [NSString stringWithFormat:@"%@%@",
                        _requestBaseUrl.absoluteString,path];
    }
    return path;
}


// 清楚所有进行中的请求
-(void)cleanup{
    [[self operationQueue] cancelAllOperations];
}
@end
