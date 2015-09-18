//
//  GTWebserviceCenter.m
//  GTiOSKit
//
//  Created by Liyuan on 15/5/27.
//  Copyright (c) 2015年 golden-tech. All rights reserved.
//

#import "GTWebserviceCenter.h"

#define HOST @"http://www.nearfull.com:9000"

@interface GTWebserviceCenter() {
//    __strong AFHTTPRequestOperation* currentRequest;
    __strong NSMutableArray* _suspendBlockQueue;
    __strong NSDictionary* _prefixParams;
    __strong NSURL* _requestBaseUrl;
    BOOL _isPopLogin;
}
@end

@implementation GTWebserviceCenter
static GTWebserviceCenter* _instance = nil;

+(id)sharedInstance{
    if(_instance == nil){
        _instance = [[GTWebserviceCenter alloc] initWebserviceCenter];
    }
    return _instance;
}

-(id)initWebserviceCenter{
    if(self){
        _requestBaseUrl = [NSURL URLWithString:HOST];
        _suspendBlockQueue = [NSMutableArray array];
    }
    return self;
}

-(NSString*)getFullRequestPath:(NSString*)path {
    if(_requestBaseUrl && ![path hasPrefix:@"http"]){
        path = [NSString stringWithFormat:@"%@%@",
                _requestBaseUrl.absoluteString,path];
    }
    return path;
}

#pragma mark 发送POST请求
-(void)sendPostRequest:(NSString *)path
             parameters:(NSDictionary *)params
                success:(void (^)(MKNetworkOperation *operation))success
                failure:(void (^)(MKNetworkOperation *operation, NSError *))failure
{
    void (^systemFailureBlock)(MKNetworkOperation *operation, NSError *error) = ^(MKNetworkOperation *operation, NSError *error){
        switch (error.code) {
            case -999:
                // 请求被手动取消
                break;
            case -1004:
                // 连接不上服务器
//                [GTUtility showDisErrorMiss:@"网络请求失败"];
                break;
            default:
//                [GTUtility showDisErrorMiss:@"网络请求失败"];
                break;
        }
        if(failure){
            failure(operation,error);
        }
    };
    
//    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"www.nearfull.com:9000/ws/v1/Account.asmx" customHeaderFields:nil];
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:@"www.nearfull.com" portNumber:9000 apiPath:@"ws/v1/Account.asmx" customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:path params:params httpMethod:@"POST"];
//    [op setHeader:@"application/soap+xml; charset=utf-8" withValue:@"Content-Type"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        success(completedOperation);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        systemFailureBlock(completedOperation, error);
    }];
    
    [engine enqueueOperation:op];
}

#pragma mark 发送文件下载请求
-(void)sendDownloadRequest:(NSString *)path
                parameters:(NSDictionary *)params
              downloadPath:(NSString *)downloadPath
                   success:(void (^)(MKNetworkOperation *))success
                   failure:(void (^)(MKNetworkOperation *, NSError *))failure
{
    void (^systemFailureBlock)(MKNetworkOperation *operation, NSError *error) = ^(MKNetworkOperation *operation, NSError *error){
        switch (error.code) {
            case -999:
                // 请求被手动取消
                break;
            case -1004:
                // 连接不上服务器
//                [GTUtility showDisErrorMiss:@"网络请求失败"];
                break;
            default:
//                [GTUtility showDisErrorMiss:@"网络请求失败"];
                break;
        }
        if(failure){
            failure(operation,error);
        }
    };
    
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:_requestBaseUrl.host customHeaderFields:nil];
    MKNetworkOperation *downloadOp = [engine operationWithPath:path params:params httpMethod:@"POST"];
    [downloadOp addDownloadStream:[NSOutputStream outputStreamToFileAtPath:downloadPath append:YES]];
    
    [downloadOp onDownloadProgressChanged:^(double progress) {
        NSLog(@"download process: %.2f", progress*100.0);
    }];
    
    [downloadOp addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"download file finished!");
        NSData *data = [completedOperation responseData];
        
        if (data) {
            // 返回数据失败
            NSError *error;
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!resDic) {
//                NSNumber *resultCodeObj = [resDic objectForKey:@"ResultCode"];
//                NSString *errorStr;
//                [GTUtility showAlert:@"%i"];
            }
        } else {
            success(completedOperation);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        systemFailureBlock(completedOperation, error);
    }];
    
    [engine enqueueOperation:downloadOp];
}

#pragma mark 发送文件上传请求
-(void)sendUploadRequest:(NSString *)path
              parameters:(NSDictionary *)params
                filePath:(NSString *)filePath
                 success:(void (^)(MKNetworkOperation *))success
                 failure:(void (^)(MKNetworkOperation *, NSError *))failure
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:_requestBaseUrl.host customHeaderFields:nil];
    MKNetworkOperation *op = [engine operationWithPath:path params:params httpMethod:@"POST"];
    
    [op addFile:filePath forKey:@"file" mimeType:@""];
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"upload file finished!");
        NSData *data = [completedOperation responseData];
        
        if (data) {
            NSError *error;
            NSDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!resDic) {
//                NSNumber *resultCodeObj = [resDic objectForKey:@"ResultCode"];
//                NSString *errorStr;
//                [GTUtility showAlert:@"%i"];
            }
        } else {
            success(completedOperation);
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        failure(completedOperation, error);
    }];
    
    [engine enqueueOperation:op];
}


@end
